#!/bin/sh

set -e

test `basename $PWD` != "c_src" && cd c_src

case "$1" in
  clean)
    rm -rf secp256k1
    rm -rf libbitcoin-consensus
    ;;

  *)
    # CC for secp256k1 has to be gcc
    export CC="gcc"
    unset LDFLAGS
  	test -f libbitcoin-concensus/src/.libs/libbitcoin-consensus.so && exit 0
  	test -f secp256k1/.libs/libsecp256k1.so && exit 0

    (test -d secp256k1 || git clone https://github.com/bitcoin/secp256k1)
	(cd secp256k1 &&  ./autogen.sh && ./configure --with-pic --enable-module-recovery && make)
	# Setup pkg-info template
    echo "prefix=$(pwd)/secp256k1" > libsecp256k1.pc
    cat libsecp256k1.pc.template >> libsecp256k1.pc
    export PKG_CONFIG_PATH="$(pwd)"
    # Need to export c++ now to continue the libbitcoin-consensus compilation
    export CC="g++"
    (test -d libbitcoin-consensus || git clone https://github.com/libbitcoin/libbitcoin-consensus.git)

	(cd libbitcoin-consensus && autoreconf -i && ./configure --enable-static --with-pic --without-tests && make)
    ;;
esac

