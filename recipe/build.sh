#!/usr/bin/env bash

set -x

# Create libgcrypt-config wrapper for newer libgcrypt versions
mkdir -p $PREFIX/bin
cat > $PREFIX/bin/libgcrypt-config << 'EOF'
#!/bin/bash
case "$1" in
    --version) pkg-config --modversion libgcrypt ;;
    --libs) pkg-config --libs libgcrypt ;;
    --cflags) pkg-config --cflags libgcrypt ;;
    *) pkg-config "$@" libgcrypt 2>/dev/null || exit 1 ;;
esac
exit 0
EOF
chmod +x $PREFIX/bin/libgcrypt-config

# Ensure it's in PATH for configure
export PATH=$PREFIX/bin:$PATH

cp -r ${BUILD_PREFIX}/share/libtool/build-aux/config.* ./build-aux

./configure --help

./configure --with-gssapi-impl=mit --with-libgcrypt --prefix=$PREFIX --build=${BUILD} --host=${HOST}
make -j${CPU_COUNT} ${VERBOSE_AT}

if [[ "${target_platform}" != osx-* ]]; then
  make check
else
  make check || true
fi
make install
