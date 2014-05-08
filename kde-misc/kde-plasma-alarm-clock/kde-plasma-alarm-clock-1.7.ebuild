# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
CMAKE_REQUIRED="never"
inherit python-single-r1 kde4-base

DESCRIPTION="Simple Alarm-Clock plasmoid"
HOMEPAGE="http://kde-apps.org/content/show.php/?content=151830"
SRC_URI="http://kde-apps.org/CONTENT/content-files/151830-${PN}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	app-arch/unzip
"
RDEPEND="
	$(add_kdebase_dep plasma-workspace python)
	$(add_kdebase_dep pykde4)
	dev-python/PyQt4
"

DOCS="README VERSION"

S="${WORKDIR}"

pkg_setup() {
	python-single-r1_pkg_setup
	kde4-base_pkg_setup
}

src_prepare() {
	# Makefile is too messy
	rm Makefile
	# Use a standard icon
	sed -e "s/Icon=.*/Icon=clock/g" -i metadata.desktop || die
}

src_install() {
	default
	insinto /usr/share/apps/plasma/plasmoids/${PN}/
	doins -r contents metadata.desktop
	insinto /usr/share/kde4/services/
	newins metadata.desktop ${PN}.desktop
}
