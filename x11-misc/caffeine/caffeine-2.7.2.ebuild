# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_{6,7} )
inherit distutils-r1 gnome2-utils

DESCRIPTION="Prevent the desktop becoming idle in full-screen mode"
HOMEPAGE="https://launchpad.net/caffeine"
SRC_URI="https://launchpad.net/~caffeine-developers/+archive/ubuntu/ppa/+files/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

DOCS="COPYING* README"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Show desktop entry everywhere
	sed '/^OnlyShowIn/d' \
		-i share/applications/caffeine.desktop || die "fixing .desktop file failed"
	# Remove non-ASCII characters
	sed 's/'$'\u00C2\u00A9''/(C)/' \
		-i caffeine || die "fixing the executable file failed"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
