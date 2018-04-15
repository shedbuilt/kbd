#!/bin/bash
patch -Np1 -i ${SHED_PKG_PATCH_DIR}/kbd-2.0.4-backspace-1.patch
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
if [ "$SHED_BUILD_MODE" == 'bootstrap' ]; then
    KBD_PKGCONFIG_PATH="/tools/lib/pkgconfig"
else
    KBD_PKGCONFIG_PATH="/usr/lib/pkgconfig"
fi
PKG_CONFIG_PATH="$KBD_PKGCONFIG_PATH" ./configure --prefix=/usr \
                                                  --disable-vlock || exit 1
make -j $SHED_NUM_JOBS || exit 1
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1
mkdir -pv ${SHED_FAKE_ROOT}/usr/share/doc/kbd-2.0.4
cp -R -v docs/doc/* ${SHED_FAKE_ROOT}/usr/share/doc/kbd-2.0.4
