# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/yasnippet/yasnippet-0.8.0.ebuild $

inherit elisp

DESCRIPTION="Yet another snippet extension for Emacs"
HOMEPAGE="http://github.com/capitaomorte/yasnippet"
SRC_URI="https://github.com/downloads/capitaomorte/yasnippet/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-emacs/dropdown-list-20080316"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	elisp_src_unpack

	# remove bundled copy of dropdown-list
	rm "${S}/dropdown-list.el" || die
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r snippets || die "doins failed"
}

pkg_postinst() {
	elisp-site-regen

	elog "Please add the following code into your .emacs to use yasnippet:"
	elog "(yas-global-mode 1)"
	elog "(yas-load-directory \"${SITEETC}/${PN}/snippets\")"
}
