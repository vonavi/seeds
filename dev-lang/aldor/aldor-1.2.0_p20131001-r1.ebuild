# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/pippijn/aldor.git"
EGIT_COMMIT="832e273"

inherit git-r3 autotools elisp-common

DESCRIPTION="The Aldor Programming Language"
HOMEPAGE="http://pippijn.github.io/aldor"
SRC_URI="doc? ( http://aldor.org/docs/libaldor.pdf.gz
		ftp://ftp-sop.inria.fr/cafe/software/algebra/algebra.html.tar.gz )
	emacs? ( http://hemmecke.de/aldor/aldor.el.nw )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc emacs"

RDEPEND="emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	doc? ( app-arch/gzip virtual/latex-base )
	emacs? ( app-text/noweb )"

DOCS="AUTHORS COPYRIGHT LICENSE README*"

S="${WORKDIR}/${P}/aldor"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf
}

src_compile() {
	einfo "Compiling aldor and its libraries"
	emake

	if use doc; then
		einfo "Documentation"
		( cd aldorug; emake aldorug.pdf ) || die "make aldorug.pdf failed"
		( cd lib/aldor/tutorial
			pdflatex tutorial.tex
			pdflatex tutorial.tex ) || die "make tutorial.pdf failed"
		cp "${DISTDIR}/libaldor.pdf.gz" .
		gunzip libaldor.pdf.gz
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
}

src_install() {
	einfo "Installing aldor and its libraries"
	emake DESTDIR="${D}" install

	if use doc; then
		einfo "Installing the aldor documentation"
		insinto "/usr/share/doc/${PF}"
		doins aldorug/aldorug.pdf lib/aldor/tutorial/tutorial.pdf *.pdf
		dohtml -r algebra.html
	fi

	if use emacs; then
		einfo "Installing the aldor emacs mode"
		elisp-site-file-install aldor.el
		elisp-site-file-install 64aldor-gentoo.el
	fi

	# Add information about ALDORROOT to environmental variables
	cat >> 99aldor <<- EOF
		ALDORROOT=${EPREFIX}/usr
	EOF
	doenvd 99aldor
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_prerm() {
	[ -f "${SITELISP}/site-gentoo.el" ] && elisp-site-regen
}
