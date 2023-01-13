# NOTE: This file was generated via generate.sh. Don't edit it directly

variable "REGISTRY" {
    default = "ghcr.io"
}

variable "REPO" {
    default = "sun-asterisk-research/laravel-base"
}

target "8_1_14-bullseye" {
    context = "./8.1/bullseye"
    cache-from = [
        "${REGISTRY}/${REPO}:8.1-bullseye"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.1-bullseye",
        "${REGISTRY}/${REPO}:8.1",
        "${REGISTRY}/${REPO}:8.1.14-bullseye",
        "${REGISTRY}/${REPO}:8.1.14",
    ]
}

target "8_1-bullseye" {
    inherits = ["8_1_14-bullseye"]
}

target "8_1_14-buster" {
    context = "./8.1/buster"
    cache-from = [
        "${REGISTRY}/${REPO}:8.1-buster"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.1-buster",
        "${REGISTRY}/${REPO}:8.1.14-buster",
    ]
}

target "8_1-buster" {
    inherits = ["8_1_14-buster"]
}

target "8_1_14-alpine3_17" {
    context = "./8.1/alpine3.17"
    cache-from = [
        "${REGISTRY}/${REPO}:8.1-alpine3.17"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.1-alpine3.17",
        "${REGISTRY}/${REPO}:8.1-alpine",
        "${REGISTRY}/${REPO}:8.1.14-alpine3.17",
        "${REGISTRY}/${REPO}:8.1.14-alpine",
    ]
}

target "8_1-alpine3_17" {
    inherits = ["8_1_14-alpine3_17"]
}

target "8_1_14-alpine3_16" {
    context = "./8.1/alpine3.16"
    cache-from = [
        "${REGISTRY}/${REPO}:8.1-alpine3.16"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.1-alpine3.16",
        "${REGISTRY}/${REPO}:8.1.14-alpine3.16",
    ]
}

target "8_1-alpine3_16" {
    inherits = ["8_1_14-alpine3_16"]
}

target "8_2_1-bullseye" {
    context = "./8.2/bullseye"
    cache-from = [
        "${REGISTRY}/${REPO}:8.2-bullseye"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8-bullseye",
        "${REGISTRY}/${REPO}:8",
        "${REGISTRY}/${REPO}:8.2-bullseye",
        "${REGISTRY}/${REPO}:8.2",
        "${REGISTRY}/${REPO}:8.2.1-bullseye",
        "${REGISTRY}/${REPO}:8.2.1",
        "${REGISTRY}/${REPO}:bullseye",
        "${REGISTRY}/${REPO}:latest",
    ]
}

target "8_2-bullseye" {
    inherits = ["8_2_1-bullseye"]
}

target "8_2_1-buster" {
    context = "./8.2/buster"
    cache-from = [
        "${REGISTRY}/${REPO}:8.2-buster"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8-buster",
        "${REGISTRY}/${REPO}:8.2-buster",
        "${REGISTRY}/${REPO}:8.2.1-buster",
        "${REGISTRY}/${REPO}:buster",
    ]
}

target "8_2-buster" {
    inherits = ["8_2_1-buster"]
}

target "8_2_1-alpine3_17" {
    context = "./8.2/alpine3.17"
    cache-from = [
        "${REGISTRY}/${REPO}:8.2-alpine3.17"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8-alpine3.17",
        "${REGISTRY}/${REPO}:8-alpine",
        "${REGISTRY}/${REPO}:8.2-alpine3.17",
        "${REGISTRY}/${REPO}:8.2-alpine",
        "${REGISTRY}/${REPO}:8.2.1-alpine3.17",
        "${REGISTRY}/${REPO}:8.2.1-alpine",
        "${REGISTRY}/${REPO}:alpine3.17",
        "${REGISTRY}/${REPO}:alpine",
    ]
}

target "8_2-alpine3_17" {
    inherits = ["8_2_1-alpine3_17"]
}

target "8_2_1-alpine3_16" {
    context = "./8.2/alpine3.16"
    cache-from = [
        "${REGISTRY}/${REPO}:8.2-alpine3.16"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8-alpine3.16",
        "${REGISTRY}/${REPO}:8.2-alpine3.16",
        "${REGISTRY}/${REPO}:8.2.1-alpine3.16",
        "${REGISTRY}/${REPO}:alpine3.16",
    ]
}

target "8_2-alpine3_16" {
    inherits = ["8_2_1-alpine3_16"]
}

target "7_3_33-bullseye" {
    context = "./7.3/bullseye"
    cache-from = [
        "${REGISTRY}/${REPO}:7.3-bullseye"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7.3-bullseye",
        "${REGISTRY}/${REPO}:7.3",
        "${REGISTRY}/${REPO}:7.3.33-bullseye",
        "${REGISTRY}/${REPO}:7.3.33",
    ]
}

target "7_3-bullseye" {
    inherits = ["7_3_33-bullseye"]
}

target "7_3_33-buster" {
    context = "./7.3/buster"
    cache-from = [
        "${REGISTRY}/${REPO}:7.3-buster"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7.3-buster",
        "${REGISTRY}/${REPO}:7.3.33-buster",
    ]
}

target "7_3-buster" {
    inherits = ["7_3_33-buster"]
}

target "7_3_33-alpine3_15" {
    context = "./7.3/alpine3.15"
    cache-from = [
        "${REGISTRY}/${REPO}:7.3-alpine3.15"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7.3-alpine3.15",
        "${REGISTRY}/${REPO}:7.3-alpine",
        "${REGISTRY}/${REPO}:7.3.33-alpine3.15",
        "${REGISTRY}/${REPO}:7.3.33-alpine",
    ]
}

target "7_3-alpine3_15" {
    inherits = ["7_3_33-alpine3_15"]
}

target "7_3_33-alpine3_14" {
    context = "./7.3/alpine3.14"
    cache-from = [
        "${REGISTRY}/${REPO}:7.3-alpine3.14"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7.3-alpine3.14",
        "${REGISTRY}/${REPO}:7.3.33-alpine3.14",
    ]
}

target "7_3-alpine3_14" {
    inherits = ["7_3_33-alpine3_14"]
}

target "7_4_33-bullseye" {
    context = "./7.4/bullseye"
    cache-from = [
        "${REGISTRY}/${REPO}:7.4-bullseye"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7-bullseye",
        "${REGISTRY}/${REPO}:7",
        "${REGISTRY}/${REPO}:7.4-bullseye",
        "${REGISTRY}/${REPO}:7.4",
        "${REGISTRY}/${REPO}:7.4.33-bullseye",
        "${REGISTRY}/${REPO}:7.4.33",
    ]
}

target "7_4-bullseye" {
    inherits = ["7_4_33-bullseye"]
}

target "7_4_33-buster" {
    context = "./7.4/buster"
    cache-from = [
        "${REGISTRY}/${REPO}:7.4-buster"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7-buster",
        "${REGISTRY}/${REPO}:7.4-buster",
        "${REGISTRY}/${REPO}:7.4.33-buster",
    ]
}

target "7_4-buster" {
    inherits = ["7_4_33-buster"]
}

target "7_4_33-alpine3_16" {
    context = "./7.4/alpine3.16"
    cache-from = [
        "${REGISTRY}/${REPO}:7.4-alpine3.16"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7-alpine3.16",
        "${REGISTRY}/${REPO}:7-alpine",
        "${REGISTRY}/${REPO}:7.4-alpine3.16",
        "${REGISTRY}/${REPO}:7.4-alpine",
        "${REGISTRY}/${REPO}:7.4.33-alpine3.16",
        "${REGISTRY}/${REPO}:7.4.33-alpine",
    ]
}

target "7_4-alpine3_16" {
    inherits = ["7_4_33-alpine3_16"]
}

target "7_4_33-alpine3_15" {
    context = "./7.4/alpine3.15"
    cache-from = [
        "${REGISTRY}/${REPO}:7.4-alpine3.15"
    ]
    tags = [
        "${REGISTRY}/${REPO}:7-alpine3.15",
        "${REGISTRY}/${REPO}:7.4-alpine3.15",
        "${REGISTRY}/${REPO}:7.4.33-alpine3.15",
    ]
}

target "7_4-alpine3_15" {
    inherits = ["7_4_33-alpine3_15"]
}

target "8_0_27-bullseye" {
    context = "./8.0/bullseye"
    cache-from = [
        "${REGISTRY}/${REPO}:8.0-bullseye"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.0-bullseye",
        "${REGISTRY}/${REPO}:8.0",
        "${REGISTRY}/${REPO}:8.0.27-bullseye",
        "${REGISTRY}/${REPO}:8.0.27",
    ]
}

target "8_0-bullseye" {
    inherits = ["8_0_27-bullseye"]
}

target "8_0_27-buster" {
    context = "./8.0/buster"
    cache-from = [
        "${REGISTRY}/${REPO}:8.0-buster"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.0-buster",
        "${REGISTRY}/${REPO}:8.0.27-buster",
    ]
}

target "8_0-buster" {
    inherits = ["8_0_27-buster"]
}

target "8_0_27-alpine3_16" {
    context = "./8.0/alpine3.16"
    cache-from = [
        "${REGISTRY}/${REPO}:8.0-alpine3.16"
    ]
    tags = [
        "${REGISTRY}/${REPO}:8.0-alpine3.16",
        "${REGISTRY}/${REPO}:8.0-alpine",
        "${REGISTRY}/${REPO}:8.0.27-alpine3.16",
        "${REGISTRY}/${REPO}:8.0.27-alpine",
    ]
}

target "8_0-alpine3_16" {
    inherits = ["8_0_27-alpine3_16"]
}
