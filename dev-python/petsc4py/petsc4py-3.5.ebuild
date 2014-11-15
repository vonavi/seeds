# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Python bindings for PETSc"
HOMEPAGE="https://bitbucket.org/petsc/petsc4py"
SRC_URI="https://bitbucket.org/petsc/petsc4py/downloads/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	=sci-mathematics/petsc-${PV}*[python]
"
RDEPEND="${DEPEND}"

DOCS="CHANGES.rst DESCRIPTION.rst LICENSE.rst README.rst"
