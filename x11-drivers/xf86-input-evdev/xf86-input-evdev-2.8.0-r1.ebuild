# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $BAR-overlay/x11-drivers/xf86-input-evdev-2.6.3.ebuild,v 1.1 2011/11/12 -tclover Exp $

# Originally written by tclover, distributed at:
# https://github.com/tokiclover/bar-overlay/tree/master/x11-drivers/xf86-input-evdev

EAPI=5

HOMEPAGE="http://gitorious.org/at-home-modifier/pages/Home"
DESCRIPTION="Generic Linux input driver with at-home-modifier hack"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86"
XORG_EAUTORECONF="yes"

inherit xorg-2

SRC_URI="${SRC_URI} https://gitorious.org/at-home-modifier/download/blobs/raw/master/patch/ahm-${PV}.patch"

RDEPEND="sys-libs/mtdev
		 >=x11-base/xorg-server-1.12[udev]"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6
	>=x11-proto/inputproto-2.1.99.3"

src_prepare() {
	epatch "${DISTDIR}"/ahm-${PV}.patch
	xorg-2_src_prepare
}

src_install() {
	xorg-2_src_install
	dodoc README*
}
