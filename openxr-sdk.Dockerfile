# Copyright (c) 2019-2021 The Khronos Group Inc.
#
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is a Docker container for OpenXR SDK CI builds.
# Intended for CI or interactive use.

FROM ubuntu:18.04
LABEL maintainer="Ryan Pavlik <ryan.pavlik@collabora.com>"

ENV LANG C.UTF-8

# Enable i386 multiarch
RUN dpkg --add-architecture i386

# Runtime-required packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y -qq \
    apt-transport-https \
    build-essential \
    ca-certificates \
    clang-10 \
    clang-format-10 \
    cmake \
    git \
    gnupg \
    libegl1-mesa-dev \
    libgl1-mesa-dev \
    libgtest-dev \
    libvulkan-dev \
    libwayland-dev \
    libx11-xcb-dev \
    libxcb-dri2-0-dev \
    libxcb-glx0-dev \
    libxcb-icccm4-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxml2-utils \
    libxrandr-dev \
    libxxf86vm-dev \
    mesa-common-dev \
    ninja-build \
    pkg-config \
    python3 \
    python3-attr \
    python3-chardet \
    python3-dev \
    python3-jinja2 \
    python3-lxml \
    python3-networkx \
    python3-pillow \
    python3-pip \
    python3-pytest \
    python3-requests \
    python3-setuptools \
    python3-tabulate \
    python3-wheel \
    wayland-protocols \
    wget \
    gcc-multilib \
    g++-multilib \
    libelf-dev:i386 \
    libgl1-mesa-dev:i386 \
    libvulkan-dev:i386 \
    libwayland-dev:i386 \
    libx11-dev:i386 \
    libx11-xcb-dev:i386 \
    libxcb-dri2-0-dev:i386 \
    libxcb-glx0-dev:i386 \
    libxcb-icccm4-dev:i386 \
    libxcb-keysyms1-dev:i386 \
    libxcb-randr0-dev:i386 \
    libxrandr-dev:i386 \
    libxxf86vm-dev:i386 \
    linux-libc-dev:i386 \
    mesa-common-dev:i386 \
    && apt-get clean

# Don't delete /var/lib/apt/lists/ before this command!
COPY release-codename.py /usr/bin/release-codename.py
RUN release-codename.py | tee /codename

# Install old clang-format-6.0
RUN echo "deb https://apt.llvm.org/$(cat /codename)/ llvm-toolchain-$(cat /codename)-6.0 main" >> /etc/apt/sources.list.d/llvm.list && \
    cat /etc/apt/sources.list.d/llvm.list 1>&2 && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/llvm.gpg && \
    apt-get update -qq && apt-get install -f && apt-get install --no-install-recommends -y -qq clang-format-6.0 clang-6.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy in the toolchain file
COPY i386.cmake /i386.cmake
