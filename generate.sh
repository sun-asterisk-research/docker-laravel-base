#!/bin/bash

set -e

source generate_utils.sh

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

    mkdir -p "$dir"

    write_warn_edit $dockerfile

    for tpl in $(ls Dockerfile*.template | grep -E "Dockerfile-[0-9]+(-${distro})?.template"); do
        tpl "$tpl" \
            php_version \
            distro_release \
            extra_steps \
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

    tpl ci.yml.template php_minor targets platforms >> $workflow_file
}

# generate_config versions.yml
# generate_config versions_7.3.yml legacy_7_3_

# eval $(generate_config versions.yml)

if [ "$1" = "clean" ]; then
    eval $(generate_config ${2:-versions.yml})
    clean_all
else
    eval $(generate_config ${1:-versions.yml})
    generate_all
fi
