#!/bin/bash

set -e

source generate_utils.sh

# Print the value of an optional boolean key from versions*.yml, or the default when unset.
# Fails when the value is neither true nor false.
#
# Usage: bool_key <key name> <default>
# e.g. bool_key exact_tags_only false
#
bool_key() {
    local value="${!1:-$2}"

    if [ "$value" != true ] && [ "$value" != false ]; then
        echo "$1 must be true or false, got '$value'" >&2
        return 1
    fi

    echo "$value"
}

# Print "@sha256:<hex>" for an optional digest key from versions*.yml, or nothing when unset.
# The key holds the bare 64-char hex: generate_config can't carry a ":" inside a value.
#
# Usage: digest_suffix <key name>
# e.g. digest_suffix base_image_sha256
#
digest_suffix() {
    local value="${!1}"

    if [ -z "$value" ]; then
        return 0
    fi

    if ! [[ "$value" =~ ^[0-9a-f]{64}$ ]]; then
        echo "$1 must be a 64-char hex sha256 without the 'sha256:' prefix, got '$value'" >&2
        return 1
    fi

    echo "@sha256:$value"
}

# Check the optional keys of the loaded versions*.yml before anything is written.
# An exact tag is meant to be pinned by digest downstream, so exact_tags_only: true
# also requires the base image to be pinned (base_image_sha256).
#
validate_config() {
    local exact_only
    exact_only=$(bool_key exact_tags_only false) || return 1
    bool_key dockerhub_push true > /dev/null || return 1
    digest_suffix base_image_sha256 > /dev/null || return 1

    if [ "$exact_only" = true ] && [ -z "$base_image_sha256" ]; then
        echo "base_image_sha256 is required when exact_tags_only is true" >&2
        return 1
    fi
}

# Generate a script that can be used with `eval` to set meta variables from a tag
#
# Usage: meta_from_full_tag <full tag>
# e.g. meta_from_full_tag 8.1.11-alpine3.15
#
meta_from_full_tag() {
    local php_version distro_release
    IFS='-' read php_version distro_release <<< "$1"

    if contains "$distro_release" "$debian_releases"; then
        local distro=debian
    elif contains "$distro_release" "$alpine_releases"; then
        local distro=alpine
    fi

    cat << EOF
local php_version="$(get_version $php_version)"
local php_major="$(get_major $php_version)"
local php_minor="$(get_minor $php_version)"
local distro_release="$distro_release"
local distro="$distro"
EOF
}

# Generate dockerfile for a tag
#
# Usage: generate_dockerfile <full tag>
# e.g. generate_dockerfile 8.1.9-alpine3.16
#
generate_dockerfile() {
    eval $(meta_from_full_tag $1)

    echo "generating $php_minor/$distro_release ..."

    local dir="$php_minor/$distro_release"
    local dockerfile="$dir/Dockerfile"

    # Optional pin of the base php image by digest (key base_image_sha256)
    local base_image_digest
    base_image_digest=$(digest_suffix base_image_sha256)

    mkdir -p "$dir"

    write_warn_edit $dockerfile

    for tpl in $(ls Dockerfile*.template | grep -E "Dockerfile-[0-9]+(-${distro})?.template"); do
        tpl "$tpl" \
            php_version \
            distro_release \
            extra_steps \
            base_image_digest \
            >> $dockerfile
    done

    cp -r rootfs "$dir"

    if [ "$distro" = "debian" ]; then
        find rootfs/usr/local/bin -type f -exec sh -c "sed '1s|#!/bin/sh|#!/bin/bash|' \$0 > $dir/\$0" {} \;
    fi
}

# Generate everything
#
generate_all() {
    local targets

    for version in $(echo "$php_versions" | sed -e 's/ /\n/g' | sort); do
        targets="$targets $(generate_tags $version "$debian_releases $alpine_releases")"
    done

    for target in $targets; do
        generate_dockerfile $target
    done

    generate_bake_file $targets

    for version in $php_versions; do
        generate_workflow $version
    done
}

# Clean up generated files
#
clean_all() {
    for version in $php_versions; do
        rm -rf $(get_minor $version)
    done

    rm -f docker-bake.hcl
    rm -f .github/workflows/ci.yml
}

# Generate all possible tags by performing matrix multiplication
#
# Usage: generate_tags <versions> <variants>
# e.g. generate_tags "7.4.32 8.0.24 8.1.11" "bullseye buster"
# would returns 7.4.32-bullseye 7.4.32-buster 8.0.24-bullseye 8.0.24-buster 8.1.11-bullseye 8.1.11-buster
#
generate_tags() {
    local tags

    for version in $1; do
        for distro in $2; do
            local tag=$(echo "$version-$distro" | sed -E -e 's/default(-|$)//g' | trim -)
            if [ -z "$tag" ]; then
                tag=latest
            fi
            tags="$tags $tag"
        done
    done

    echo "$tags"
}

# Normalize bake targets (replacing dots with underscores)
#
format_bake_target() {
    sed 's/\./_/g'
}

# Generate bake file targets for a tag
# Includes major/minor version tag and short tags if PHP version or variant is the default one
#
# Usage: generate_bake_file_target <tag>
# e.g. generate_bake_file_target 8.1.11-bullseye
#
generate_bake_file_target() {
    local distro_release_var_name="default_${default_distro}_release"

    local default_php_minor="$(get_minor $default_php_version)"
    local default_distro_release=${!distro_release_var_name}

    eval $(meta_from_full_tag $1)

    local version_tags="$php_minor,$php_version"

    if eval [ "$php_minor" = \$"default_php_${php_major}_version" ]; then
        version_tags="$php_major,$version_tags"
    fi

    if [ "$php_minor" = "$default_php_minor" ]; then
        version_tags="$version_tags,default"
    fi

    local distro_tags="$distro_release"

    if [ "$distro" = "alpine" ] && [ "$distro_release" = "$default_alpine_release" ]; then
        distro_tags="$distro_tags,alpine"
    fi

    if [ "$distro_release" = "$default_distro_release" ]; then
        distro_tags="$distro_tags,default"
    fi

    # Opt-in: publish only the immutable full tag, without minor/major versions or aliases
    local exact_only
    exact_only=$(bool_key exact_tags_only false)

    if [ "$exact_only" = true ]; then
        version_tags="$php_version"
        distro_tags="$distro_release"
    fi

    tags=$(
        IFS=',' generate_tags "$version_tags" "$distro_tags" \
        | sed -E 's/(^|[[:space:]])/\1${REGISTRY}\/${REPO}:/g' \
        | format_list \
        | indent 1 4 \
        | trim
    )

    bake_target=$(echo "$php_version-$distro_release" | format_bake_target)
    bake_target_minor_version=$(echo "$php_minor-$distro_release" | format_bake_target)

    tpl docker-bake-target.template \
        bake_target \
        bake_target_minor_version \
        php_version \
        php_minor \
        distro_release \
        tags
}

# Generate docker-bake.hcl file
#
generate_bake_file() {
    local bake_file="docker-bake.hcl"

    echo "generating $bake_file ..."

    if [ "$APPEND" != "true" ]; then
        write_warn_edit $bake_file
        cat docker-bake.template >> $bake_file
    fi

    for target in $@; do
        generate_bake_file_target $target >> $bake_file
    done
}

# Generate workflow file for the specified PHP version
#
# Usage: generate_workflow <version>
# e.g. generate_workflow 8.1.11
# Would generate the workflow file .github/workflows/8.1.yml
#
generate_workflow() {
    local php_minor=$(get_minor $1)
    local targets="$(generate_tags $1 "$debian_releases $alpine_releases" | format_bake_target | format_list 2 | indent 5 2 | trim)"

    local workflow_file=".github/workflows/$php_minor.yml"

    echo "generating $workflow_file ..."

    mkdir -p .github/workflows
    write_warn_edit $workflow_file

    local platforms=$(echo $platforms | sed 's/ /,/g')

    # Docker Hub steps also need the secrets; dockerhub_push: false turns them off for this file
    local dockerhub_push_enabled
    dockerhub_push_enabled=$(bool_key dockerhub_push true)

    tpl ci.yml.template php_minor targets platforms dockerhub_push=dockerhub_push_enabled >> $workflow_file
}

if [ "$1" = "clean" ]; then
    eval $(generate_config ${2:-versions.yml})
    clean_all
else
    eval $(generate_config ${1:-versions.yml})
    validate_config || { echo "${1:-versions.yml}: invalid config, nothing generated" >&2; exit 1; }
    generate_all
fi
