#!/bin/sh

set -e

test `basename $PWD` != "c_src" && cd c_src

case "$1" in
  clean)
    rm -rf libbitcoin-consensus
    ;;

  *)
  	test -f libbitcoin-concensus/src/.libs/libbitcoin-consensus.so && exit 0

    (test -d libbitcoin-consensus || git clone https://github.com/libbitcoin/libbitcoin-consensus.git)

	(cd libbitcoin-consensus && autoreconf -i && ./configure --enable-static --with-pic --without-tests && make)
    ;;
esac
