
FROM ubuntu:18.04
LABEL Name=pdfium Version=0.0.1

RUN apt-get update
RUN apt-get install -y wget python git cmake xz-utils lsb-release sudo

WORKDIR /opt
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH="/opt/depot_tools:${PATH}"

RUN mkdir /repo
WORKDIR /repo
RUN gclient config --unmanaged https://pdfium.googlesource.com/pdfium.git
RUN gclient sync

WORKDIR /repo/pdfium
RUN echo n | ./build/install-build-deps.sh

RUN gn gen out/Debug
ADD args.gn out/Debug/args.gn
ENTRYPOINT ninja -C out/Debug pdfium
