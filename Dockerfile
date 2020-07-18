FROM ubuntu:18.04 AS base

ARG WORKDIR=
ARG INSTALL_DIR=${WORKDIR}/_install

FROM base AS build_deps
ARG WORKDIR
WORKDIR ${WORKDIR}
# libserialport
RUN apt-get update && apt-get -y install --no-install-recommends \
	git-core \
	gcc \
	make \
	autoconf \
	automake \
	libtool
# libsigrok
RUN apt-get update && apt-get -y install --no-install-recommends \
	g++ \
	autoconf-archive \
	pkg-config \
	libglib2.0-dev \
	libglibmm-2.4-dev \
	libzip-dev \
	libusb-1.0-0-dev \
	libftdi1-dev \
	check \
	doxygen \
	nettle-dev
# smuview
RUN apt-get update && apt-get -y install --no-install-recommends \
	cmake \
	libboost-dev \
	python3-dev \
	libqt5svg5-dev \
	qtbase5-dev \
	libqwt-qt5-dev \
	ca-certificates

FROM build_deps AS build
ARG INSTALL_DIR
COPY build.sh .
RUN ./build.sh ${INSTALL_DIR}

FROM base
ARG INSTALL_DIR
RUN apt-get update && apt-get -y install --no-install-recommends \
	libftdi1-2 \
	libglibmm-2.4-1v5 \
	libzip4 \
	libpython3.6 \
	libqwt-qt5-6 \
	python3
COPY --from=build ${INSTALL_DIR}/ /usr/
RUN apt-get update && apt-get -y install --no-install-recommends \
	strace
CMD ["smuview"]