#!/usr/bin/env bash

cp -r ${BUILD_PREFIX}/share/libtool/build-aux/config.* ./build-aux

./configure --with-gssapi-impl=mit --prefix=$PREFIX --build=${BUILD} --host=${HOST}
make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install
