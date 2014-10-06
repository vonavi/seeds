# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools elisp-common

DESCRIPTION="The Aldor Programming Language"
HOMEPAGE="http://pippijn.github.io/aldor"
SRC_URI="https://api.github.com/repos/pippijn/aldor/tarball/832e273 -> ${P}.tar.gz
	doc? ( http://aldor.org/docs/aldorug.pdf.gz
		http://aldor.org/docs/libaldor.pdf.gz
		http://aldor.org/docs/tutorial.pdf.gz
		ftp://ftp-sop.inria.fr/cafe/software/algebra/algebra.html.tar.gz )
	emacs? ( http://hemmecke.de/aldor/aldor.el.nw )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc emacs"

RDEPEND="emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	doc? ( app-arch/gzip )
	emacs? ( app-text/noweb doc? ( virtual/latex-base ) )"

DOCS="AUTHORS COPYRIGHT LICENSE README*"

S="${WORKDIR}/pippijn-aldor-832e273/aldor"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf
}

src_compile() {
	if use doc; then
		einfo "Documentation"
		cp "${DISTDIR}/aldorug.pdf.gz" .
		cp "${DISTDIR}/libaldor.pdf.gz" .
		cp "${DISTDIR}/tutorial.pdf.gz" .
		gunzip aldorug.pdf.gz libaldor.pdf.gz tutorial.pdf.gz
		tar xzf "${DISTDIR}/algebra.html.tar.gz"
	fi

	if use emacs; then
		einfo "The aldor emacs mode"
		notangle "${DISTDIR}/aldor.el.nw" > aldor.el
		notangle -Rinit.el "${DISTDIR}/aldor.el.nw" | \
			sed -e '1s/^.*$/;; aldor mode/' > 64aldor-gentoo.el
		if use doc; then
			einfo "Documentation for the aldor emacs mode"
			noweave "${DISTDIR}/aldor.el.nw" > aldor-mode.tex
			pdflatex aldor-mode.tex
			pdflatex aldor-mode.tex
		fi
	fi

	einfo "Compiling aldor and its libraries"
	emake
}

src_install() {
	if use doc; then
		einfo "Installing the aldor documentation"
		insinto "/usr/share/doc/${P}"
		doins *.pdf
		doins -r algebra.html
	fi

	if use emacs; then
		einfo "Installing the aldor emacs mode"
		elisp-site-file-install aldor.el
		elisp-site-file-install 64aldor-gentoo.el
	fi

	einfo "Installing aldor and its libraries"
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_prerm() {
	[ -f "${SITELISP}/site-gentoo.el" ] && elisp-site-regen
}
