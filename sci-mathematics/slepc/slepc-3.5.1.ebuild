# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 versionator

MY_MINORV=$(get_version_component_range 1-2)

DESCRIPTION="Scalable Library for Eigenvalue Problem Computations"
HOMEPAGE="http://www.grycap.upv.es/slepc/"
SRC_URI="http://www.grycap.upv.es/slepc/download/distrib/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cxx debug fortran"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="
	${PYTHON_DEPS}
	>=sci-mathematics/petsc-${MY_MINORV}[cxx?,debug?,fortran?,python]
	>=dev-python/petsc4py-${MY_MINORV}
"
RDEPEND="${DEPEND}"

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
	SLEPC_DIR=${S} MAKEOPTS= emake || die "emake failed"
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
		doins -r include/finclude/*
	fi

	dolib.so "${PETSC_ARCH}"/lib/*.so
	dolib.so "${PETSC_ARCH}"/lib/*.so.*

	insinto /usr/conf
	doins conf/*
	insinto /usr/${SLEPC_ARCH}/conf
	doins ${SLEPC_ARCH}/conf/{slepcrules,slepcvariables}

	# Fix configuration files
	sed -i \
		-e "s:SLEPC_DESTDIR =.*:SLEPC_DESTDIR = /usr:" \
		"${ED}"/usr/include/"${PN}/${SLEPC_ARCH}"/conf/slepcvariables

	cat > 99slepc <<- EOF
		SLEPC_ARCH=${SLEPC_ARCH}
		SLEPC_DIR=/usr/include/${PN}
	EOF
	doenvd 99slepc
}
