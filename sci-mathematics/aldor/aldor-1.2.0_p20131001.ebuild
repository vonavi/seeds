# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools

DESCRIPTION="The Aldor Programming Language"
HOMEPAGE="http://pippijn.github.io/aldor"
SRC_URI="https://api.github.com/repos/pippijn/aldor/tarball/832e273 -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DOCS="AUTHORS COPYRIGHT LICENSE README*"

S="${WORKDIR}/pippijn-aldor-832e273/aldor"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf
}

src_compile() {
	emake
}
