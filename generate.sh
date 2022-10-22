#!/bin/bash

set -e

source generate_utils.sh

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

# Usage: generate_dockerfile <full tag>
# e.g. generate_dockerfile 8.1.9-alpine3.16
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

generate_all() {
    local distro_releases="$debian_releases $alpine_releases"

    local targets=""

    for version in $(echo "$php_versions" | sed -e 's/ /\n/g' | sort); do
        for distro in $distro_releases; do
            targets="$targets $version-$distro"
        done
    done

    for target in $targets; do
        generate_dockerfile $target
    done

    generate_bake_file $targets
    generate_workflow $targets
}

clean_all() {
    for version in $php_versions; do
        rm -rf $(get_minor $version)
    done

    rm -f docker-bake.hcl
    rm -f .github/workflows/ci.yml
}

generate_tags() {
    local IFS=','

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

format_bake_target() {
    sed 's/\./_/g'
}

generate_bake_file_target() {
    eval $(meta_from_full_tag $1)

    [ "$php_minor" = "$default_php_minor" ] && local is_default_version=true
    [ "$distro_release" = "$default_distro_release" ] && local is_default_distro_release=true

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
        generate_tags "$version_tags" "$distro_tags" \
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

generate_bake_file() {
    local bake_file="docker-bake.hcl"

    echo "generating $bake_file ..."

    write_warn_edit $bake_file

    local targets=$(echo "$@" | format_bake_target | format_list | indent 1 4 | trim)

    tpl docker-bake.template targets >> $bake_file

    for target in $@; do
        generate_bake_file_target $target >> $bake_file
    done
}

generate_workflow() {
    local workflow_file=".github/workflows/ci.yml"

    echo "generating $workflow_file ..."

    mkdir -p .github/workflows
    write_warn_edit $workflow_file

    local targets=$(echo "$@" | format_bake_target | format_list 2 | indent 5 2 | trim)
    local platforms=$(echo $platforms | sed 's/ /,/g')

    tpl ci.yml.template targets platforms >> $workflow_file
}

eval $(get_versions)

default_php_major="$(get_major $default_php_version)"
default_php_minor="$(get_minor $default_php_version)"
eval default_distro_release=\$"default_${default_distro}_release"

if [ "$#" = 0 ]; then
    generate_all
elif [ "$1" = "clean" ]; then
    clean_all
fi
