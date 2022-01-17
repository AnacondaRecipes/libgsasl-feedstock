#!/usr/bin/env bash

set -x

cp -r ${BUILD_PREFIX}/share/libtool/build-aux/config.* ./build-aux

./configure \
    --with-gssapi-impl=mit \
    --with-libgcrypt \
    --with-libgcrypt-prefix="${PREFIX}" \
    --without-openssl \
    --prefix=$PREFIX \
    --build=${BUILD} \
    --host=${HOST}

make -j${CPU_COUNT} ${VERBOSE_AT}

# Attempt to fix some file number limits on testing on osx.
if [[ ${target_platform} == osx-* ]]; then
    sudo sysctl -w kern.maxfiles=64000
    sudo sysctl -w kern.maxfilesperproc=64000
    sudo launchctl limit maxfiles 64000 64000
    ulimit -n 64000;
fi

if [[ "${target_platform}" != osx-* ]]; then
  make check
else
  make check || true
fi

make install
