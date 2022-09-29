# NOTE: This file was generated via generate.sh. Don't edit it directly

variable "REGISTRY" {
    default = "ghcr.io"
}

variable "REPO" {
    default = "sun-asterisk-research/laravel-base"
}

group "default" {
    targets = [
        "7_4_30-bullseye",
        "7_4_30-buster",
        "7_4_30-alpine3_16",
        "7_4_30-alpine3_15",
        "8_0_23-bullseye",
        "8_0_23-buster",
        "8_0_23-alpine3_16",
        "8_0_23-alpine3_15",
        "8_1_10-bullseye",
        "8_1_10-buster",
        "8_1_10-alpine3_16",
        "8_1_10-alpine3_15",
    ]
}

target "7_4_30-bullseye" {
    context = "./7.4/bullseye"
    cache-from = [
        "${REGISTRY}/${REPO}:7.4-bullseye"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7-bullseye",
        "${REGISTRY}/${REPO}:7",
        "${REGISTRY}/${REPO}:7.4-bullseye",
        "${REGISTRY}/${REPO}:7.4",
        "${REGISTRY}/${REPO}:7.4.30-bullseye",
        "${REGISTRY}/${REPO}:7.4.30",
    ]
}

target "7_4-bullseye" {
    inherits = ["7_4_30-bullseye"]
}

target "7_4_30-buster" {
    context = "./7.4/buster"
    cache-from = [
        "${REGISTRY}/${REPO}:7.4-buster"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7-buster",
        "${REGISTRY}/${REPO}:7.4-buster",
        "${REGISTRY}/${REPO}:7.4.30-buster",
    ]
}

target "7_4-buster" {
    inherits = ["7_4_30-buster"]
}

target "7_4_30-alpine3_16" {
    context = "./7.4/alpine3.16"
    cache-from = [
        "${REGISTRY}/${REPO}:7.4-alpine3.16"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7-alpine3.16",
        "${REGISTRY}/${REPO}:7-alpine",
        "${REGISTRY}/${REPO}:7.4-alpine3.16",
        "${REGISTRY}/${REPO}:7.4-alpine",
        "${REGISTRY}/${REPO}:7.4.30-alpine3.16",
        "${REGISTRY}/${REPO}:7.4.30-alpine",
    ]
}

target "7_4-alpine3_16" {
    inherits = ["7_4_30-alpine3_16"]
}

target "7_4_30-alpine3_15" {
    context = "./7.4/alpine3.15"
    cache-from = [
        "${REGISTRY}/${REPO}:7.4-alpine3.15"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7-alpine3.15",
        "${REGISTRY}/${REPO}:7.4-alpine3.15",
        "${REGISTRY}/${REPO}:7.4.30-alpine3.15",
    ]
}

target "7_4-alpine3_15" {
    inherits = ["7_4_30-alpine3_15"]
}

target "8_0_23-bullseye" {
    context = "./8.0/bullseye"
    cache-from = [
        "${REGISTRY}/${REPO}:8.0-bullseye"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.0-bullseye",
        "${REGISTRY}/${REPO}:8.0",
        "${REGISTRY}/${REPO}:8.0.23-bullseye",
        "${REGISTRY}/${REPO}:8.0.23",
    ]
}

target "8_0-bullseye" {
    inherits = ["8_0_23-bullseye"]
}

target "8_0_23-buster" {
    context = "./8.0/buster"
    cache-from = [
        "${REGISTRY}/${REPO}:8.0-buster"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.0-buster",
        "${REGISTRY}/${REPO}:8.0.23-buster",
    ]
}

target "8_0-buster" {
    inherits = ["8_0_23-buster"]
}

target "8_0_23-alpine3_16" {
    context = "./8.0/alpine3.16"
    cache-from = [
        "${REGISTRY}/${REPO}:8.0-alpine3.16"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.0-alpine3.16",
        "${REGISTRY}/${REPO}:8.0-alpine",
        "${REGISTRY}/${REPO}:8.0.23-alpine3.16",
        "${REGISTRY}/${REPO}:8.0.23-alpine",
    ]
}

target "8_0-alpine3_16" {
    inherits = ["8_0_23-alpine3_16"]
}

target "8_0_23-alpine3_15" {
    context = "./8.0/alpine3.15"
    cache-from = [
        "${REGISTRY}/${REPO}:8.0-alpine3.15"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.0-alpine3.15",
        "${REGISTRY}/${REPO}:8.0.23-alpine3.15",
    ]
}

target "8_0-alpine3_15" {
    inherits = ["8_0_23-alpine3_15"]
}

target "8_1_10-bullseye" {
    context = "./8.1/bullseye"
    cache-from = [
        "${REGISTRY}/${REPO}:8.1-bullseye"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8-bullseye",
        "${REGISTRY}/${REPO}:8",
        "${REGISTRY}/${REPO}:8.1-bullseye",
        "${REGISTRY}/${REPO}:8.1",
        "${REGISTRY}/${REPO}:8.1.10-bullseye",
        "${REGISTRY}/${REPO}:8.1.10",
        "${REGISTRY}/${REPO}:bullseye",
        "${REGISTRY}/${REPO}:latest",
    ]
}

target "8_1-bullseye" {
    inherits = ["8_1_10-bullseye"]
}

target "8_1_10-buster" {
    context = "./8.1/buster"
    cache-from = [
        "${REGISTRY}/${REPO}:8.1-buster"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8-buster",
        "${REGISTRY}/${REPO}:8.1-buster",
        "${REGISTRY}/${REPO}:8.1.10-buster",
        "${REGISTRY}/${REPO}:buster",
    ]
}

target "8_1-buster" {
    inherits = ["8_1_10-buster"]
}

target "8_1_10-alpine3_16" {
    context = "./8.1/alpine3.16"
    cache-from = [
        "${REGISTRY}/${REPO}:8.1-alpine3.16"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8-alpine3.16",
        "${REGISTRY}/${REPO}:8-alpine",
        "${REGISTRY}/${REPO}:8.1-alpine3.16",
        "${REGISTRY}/${REPO}:8.1-alpine",
        "${REGISTRY}/${REPO}:8.1.10-alpine3.16",
        "${REGISTRY}/${REPO}:8.1.10-alpine",
        "${REGISTRY}/${REPO}:alpine3.16",
        "${REGISTRY}/${REPO}:alpine",
    ]
}

target "8_1-alpine3_16" {
    inherits = ["8_1_10-alpine3_16"]
}

target "8_1_10-alpine3_15" {
    context = "./8.1/alpine3.15"
    cache-from = [
        "${REGISTRY}/${REPO}:8.1-alpine3.15"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8-alpine3.15",
        "${REGISTRY}/${REPO}:8.1-alpine3.15",
        "${REGISTRY}/${REPO}:8.1.10-alpine3.15",
        "${REGISTRY}/${REPO}:alpine3.15",
    ]
}

target "8_1-alpine3_15" {
    inherits = ["8_1_10-alpine3_15"]
}
