# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base

DESCRIPTION="Very small utility to convert TTF files to EOT"
HOMEPAGE="http://code.google.com/p/ttf2eot/"
SRC_URI="http://ttf2eot.googlecode.com/files/ttf2eot-0.0.2-2.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD LGPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-cstddef.patch"
)

S="${WORKDIR}/${PN}-0.0.2-2"

src_compile() {
	emake || die "Failed compiling ttf2eot."
}

src_install() {
	exeinto /usr/bin
	doexe ttf2eot
	dodoc ChangeLog README
}
