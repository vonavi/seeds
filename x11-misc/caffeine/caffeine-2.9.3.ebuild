# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python3_4 )
inherit distutils-r1 gnome2-utils

DESCRIPTION="Stop the desktop from becoming idle in full-screen mode"
HOMEPAGE="https://launchpad.net/caffeine"
SRC_URI="https://launchpad.net/~caffeine-developers/+archive/ubuntu/ppa/+files/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
LANGS="ar bg bs ca cs da de el en_GB eo es eu fi fr gl he hu it ja lt ms nl no pl pt_BR pt ro ru sk sv th tr uk vi xh zh_TW"
IUSE=""

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

RDEPEND="
	dev-libs/libappindicator
	dev-python/ewmh[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/python3-xlib[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	x11-misc/xdg-utils
"
DEPEND="sys-devel/gettext"

DOCS="COPYING* README VERSION"

S="${WORKDIR}/${PN}"

_clean_up_locales() {
	einfo "Cleaning up locales..."
	for lang in ${LANGS}; do
		use "linguas_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${ED}"/usr/share/locale/"${lang}" || die
	done
}

python_prepare_all() {
	# Remove non-ASCII characters
	sed -i \
		-e 's/\xc2\xa9/(c)/' \
		caffeine{,-indicator} || die "fixing the executable file failed"

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_prepare_all

	_clean_up_locales
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
