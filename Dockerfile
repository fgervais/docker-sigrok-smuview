FROM ubuntu:18.04 AS base

ARG INSTALL_DIR=/_install

FROM base AS build
RUN apt-get update && apt-get -y install --no-install-recommends \
	git-core \
	gcc \
	make \
	autoconf \
	automake \
	libtool
RUN git clone git://sigrok.org/libserialport && \
	cd libserialport && \
	./autogen.sh && \
	./configure --prefix=${INSTALL_DIR} && \
	make && \
	make install

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
	swig \
	default-jdk
RUN git clone git://sigrok.org/libsigrok && \
	cd libsigrok && \
	./autogen.sh && \
	PKG_CONFIG_PATH=${INSTALL_DIR}/lib/pkgconfig ./configure --prefix=${INSTALL_DIR} && \
	make -j16 && \
	make install

RUN apt-get update && apt-get -y install --no-install-recommends \
	cmake \
	libboost-dev \
	python3-dev \
	libqt5svg5-dev \
	qtbase5-dev \
	libqwt-qt5-dev
RUN git clone https://github.com/knarfS/smuview && \
	cd smuview && \
	mkdir build && \
	cd build && \
	PKG_CONFIG_PATH=${INSTALL_DIR}/lib/pkgconfig cmake -DCMAKE_INSTALL_PREFIX:PATH=${INSTALL_DIR} ../ && \
	make -j16 && \
	make install

FROM base
RUN apt-get update && apt-get -y install --no-install-recommends \
	libftdi1-2 \
	libglibmm-2.4-1v5 \
	libzip4 \
	libpython3.6 \
	libqwt-qt5-6 \
	python3
COPY --from=build ${INSTALL_DIR}/ /usr/
CMD ["smuview"]