# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/pippijn/aldor.git"
EGIT_COMMIT="832e273"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit git-r3 autotools-utils elisp-common

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
	virtual/yacc
	doc? ( app-arch/gzip virtual/latex-base )
	emacs? ( app-text/noweb )"

DOCS=( AUTHORS COPYRIGHT LICENSE )

S="${WORKDIR}/${P}/aldor"

src_compile() {
	if use doc ; then
		( cd aldorug; emake aldorug.pdf ) || die "make aldorug.pdf failed"
		( cd lib/aldor/tutorial
			pdflatex tutorial.tex
			pdflatex tutorial.tex ) || die "make tutorial.pdf failed"
		cp "${DISTDIR}/libaldor.pdf.gz" .
		gunzip libaldor.pdf.gz
		tar xzf "${DISTDIR}/algebra.html.tar.gz"
	fi

	if use emacs ; then
		notangle "${DISTDIR}/aldor.el.nw" > aldor.el
		notangle -Rinit.el "${DISTDIR}/aldor.el.nw" | \
			sed -e '1s/^.*$/;; aldor mode/' > 64aldor-gentoo.el
		if use doc ; then
			einfo "Documentation for the aldor emacs mode"
			noweave "${DISTDIR}/aldor.el.nw" > aldor-mode.tex
			pdflatex aldor-mode.tex
			pdflatex aldor-mode.tex
		fi
	fi

	autotools-utils_src_compile
}

src_install() {
	if use doc ; then
		DOCS+=( aldorug/aldorug.pdf lib/aldor/tutorial/tutorial.pdf libaldor.pdf )
		HTML_DOCS=( algebra.html/ )
	fi
	if use emacs ; then
		DOCS+=( aldor-mode.pdf )
		elisp-site-file-install aldor.el
		elisp-site-file-install 64aldor-gentoo.el
	fi
	autotools-utils_src_install

	# Add information about ALDORROOT to environmental variables
	cat > 99aldor <<- EOF
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
