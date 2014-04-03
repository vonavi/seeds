# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit elisp

DESCRIPTION="YASnippet is a template system for Emacs."
HOMEPAGE="https://github.com/capitaomorte/yasnippet"
SRC_URI="https://github.com/capitaomorte/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
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
