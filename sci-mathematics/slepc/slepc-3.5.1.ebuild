# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit python

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Scalable Library for Eigenvalue Problem Computations"
HOMEPAGE="http://www.grycap.upv.es/slepc/"
SRC_URI="http://www.grycap.upv.es/slepc/download/distrib/${MY_P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="cxx debug fortran static-libs"

DEPEND=">=sci-mathematics/petsc-3.1_p4[debug?,cxx?,fortran?]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	unset SLEPC_DIR
	export SLEPC_ARCH=${PETSC_ARCH} \
		|| die "\PETSC_ARCH environment variable not set"
}

src_prepare() {
	sed -i -e "s:petscdir,'include','petscversion.h':petscdir,'petscversion.h':" \
		config/petscversion.py \
		|| die "sed petscversion.py failed"
	sed -i -e 's:${PETSC_DIR}/include:${PETSC_DIR}:' \
		makefile \
		|| die "sed makefile failed"
}

src_configure() {
	${PYTHON} "${S}/config/configure.py" \
		|| die "configuration failed"
}

src_compile() {
	SLEPC_DIR=${S} emake || die "emake failed"
}

src_install() {
	insinto /usr/include/"${PN}"
	doins "${S}"/include/*.h
	insinto /usr/include/"${PN}/${SLEPC_ARCH}"/include
	doins "${S}/${SLEPC_ARCH}"/include/*
	insinto /usr/include/"${PN}"/conf
	if use fortran; then
		insinto /usr/include/"${PN}"/finclude
		doins "${S}"/include/finclude/*.h
	fi
	insinto /usr/include/"${PN}"/conf
	doins "${S}"/conf/*
	insinto /usr/include/"${PN}/${SLEPC_ARCH}"/conf
	doins "${S}/${SLEPC_ARCH}"/conf/slepc{rules,variables}

	insinto /usr/include/"${PN}"/private
	doins "${S}"/include/private/*.h

	dosed "s:SLEPC_INSTALL_DIR =.*:SLEPC_INSTALL_DIR = /usr:" /usr/include/"${PN}/${SLEPC_ARCH}"/conf/slepcvariables

	cat > ${T}/99slepc <<EOF
SLEPC_ARCH=${SLEPC_ARCH}
SLEPC_DIR=/usr/include/${PN}
EOF
	doenvd ${T}/99slepc

	use static-libs \
		&& dolib.a  "${S}/${PETSC_ARCH}"/lib/*.a  \
		|| dolib.so "${S}/${PETSC_ARCH}"/lib/*.so
}
