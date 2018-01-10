#!/bin/bash
patch -Np1 -i ${SHED_PATCHDIR}/kbd-2.0.4-backspace-1.patch
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
if [ "$SHED_BUILDMODE" == 'bootstrap' ]; then
    KBD_PKGCONFIG_PATH="/tools/lib/pkgconfig"
else
    KBD_PKGCONFIG_PATH="/usr/lib/pkgconfig"
fi
PKG_CONFIG_PATH="$KBD_PKGCONFIG_PATH" ./configure --prefix=/usr \
                                                  --disable-vlock || exit 1
make -j $SHED_NUMJOBS || exit 1
make DESTDIR="$SHED_FAKEROOT" install || exit 1
mkdir -pv ${SHED_FAKEROOT}/usr/share/doc/kbd-2.0.4
cp -R -v docs/doc/* ${SHED_FAKEROOT}/usr/share/doc/kbd-2.0.4
