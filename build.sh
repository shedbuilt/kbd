#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_DOCDIR="/usr/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}"
SHED_PKG_LOCAL_PKGCONFIG_PATH='/usr/lib/pkgconfig'
if [ -n "${SHED_PKG_LOCAL_OPTIONS[bootstrap]}" ]; then
    SHED_PKG_LOCAL_PKGCONFIG_PATH='/tools/lib/pkgconfig'
fi
# Patch
patch -Np1 -i "${SHED_PKG_PATCH_DIR}/kbd-2.0.4-backspace-1.patch" &&
# Disable resizecons
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure &&
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in &&
# Configure
PKG_CONFIG_PATH="$SHED_PKG_LOCAL_PKGCONFIG_PATH" \
./configure --prefix=/usr \
            --disable-vlock &&
# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1
# Install Documentation
if [ -n "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    mkdir -pv "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_DOCDIR}" &&
    cp -R -v docs/doc/* "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_DOCDIR}"
fi
