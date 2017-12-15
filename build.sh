#!/bin/bash
patch -Np1 -i ${SHED_PATCHDIR}/kbd-2.0.4-backspace-1.patch
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install
mkdir -pv ${SHED_FAKEROOT}/usr/share/doc/kbd-2.0.4
cp -R -v docs/doc/* ${SHED_FAKEROOT}/usr/share/doc/kbd-2.0.4
