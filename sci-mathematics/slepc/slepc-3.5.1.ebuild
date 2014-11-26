# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1

DESCRIPTION="Scalable Library for Eigenvalue Problem Computations"
HOMEPAGE="http://www.grycap.upv.es/slepc/"
SRC_URI="http://www.grycap.upv.es/slepc/download/distrib/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cxx debug fortran"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND=">=sci-mathematics/petsc-${PV}[cxx?,debug?,fortran?,python]"
DEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

pkg_setup() {
	unset SLEPC_DIR
	export SLEPC_ARCH=${PETSC_ARCH} \
		|| die "PETSC_ARCH environment variable not set"
}

src_configure() {
	python_setup
	${PYTHON} config/configure.py \
		|| die "configuration failed"
}

src_compile() {
	# PETSc compiles are automatically parallel, do not provide the -j
	# option to make
	SLEPC_DIR=${S} emake -j1 || die "emake failed"
}

src_install() {
	insinto /usr/include
	doins include/*.h
	insinto /usr/${SLEPC_ARCH}/include
	doins ${SLEPC_ARCH}/include/*.h
	insinto /usr/include/slepc-private
	doins include/slepc-private/*.h

	if use fortran ; then
		insinto /usr/include/finclude
		doins include/finclude/*.{h,h90}
		insinto /usr/include/finclude/ftn-auto
		doins include/finclude/ftn-auto/*.h90
		insinto /usr/include/finclude/ftn-custom
		doins include/finclude/ftn-custom/*.h90
		insinto /usr/${SLEPC_ARCH}/include
		doins ${SLEPC_ARCH}/include/*.mod
	fi

	dolib.so ${SLEPC_ARCH}/lib/*.so
	dolib.so ${SLEPC_ARCH}/lib/*.so.*

	insinto /usr/conf
	doins conf/*
	insinto /usr/${SLEPC_ARCH}/conf
	doins ${SLEPC_ARCH}/conf/{slepcrules,slepcvariables}

	# Fix configuration files
	sed -i \
		-e "s:${S}/${SLEPC_ARCH}/lib:/usr/$(get_libdir):g" \
		"${ED}"/usr/${SLEPC_ARCH}/include/slepcconf.h || die
	sed -i \
		-e "s:SLEPC_DESTDIR =.*:SLEPC_DESTDIR = ${EPREFIX}/usr:" \
		"${ED}"/usr/${SLEPC_ARCH}/conf/slepcvariables || die

	cat > 99slepc <<- EOF
		SLEPC_ARCH=${SLEPC_ARCH}
		SLEPC_DIR=${EPREFIX}/usr
	EOF
	doenvd 99slepc
}
