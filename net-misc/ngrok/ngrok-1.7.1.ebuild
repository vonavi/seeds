# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

EGO_PN="github.com/inconshreveable/ngrok"

inherit golang-build

DESCRIPTION="Introspected tunnels to localhost"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://ngrok.com"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-vcs/mercurial"

PATCHES="${FILESDIR}/${P}-fix-log4go-path.patch"

src_compile() {
	make release-all
}

src_install() {
	dobin bin/ngrok
	dobin bin/ngrokd
}
