#!/usr/bin/env bash

./configure --with-gssapi-impl=mit --prefix=$PREFIX
make -j${CPU_COUNT}
make check
make install
