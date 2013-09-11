# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit games toolchain-funcs

DESCRIPTION="UCI chess engine http://www.stockfishchess.com/"
HOMEPAGE="http://www.stockfishchess.com/"
SRC_URI="https://github.com/mcostalba/Stockfish/archive/sf_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug optimization"

case $(tc-arch) in
	"x86"   ) IUSE+=" sse"    ;;
	"amd64" ) IUSE+=" popcnt" ;;
esac

DEPEND="optimization? ( sys-devel/gcc[lto] )"

S="${WORKDIR}/Stockfish-sf_${PV}/src"

src_compile() {
	local makeopts="ARCH="

	case $(tc-arch) in
		"x86"   )
			makeopts+="x86-32"
			! use sse && makeopts+="-old"
			;;
		"amd64" )
			makeopts+="x86-64"
			use popcnt && makeopts+="-modern"
			;;
	esac

	use debug && makeopts+=" debug=yes"
	! use optimization && makeopts+=" optimize=no"

	emake build ${makeopts} || die "emake failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"
	dodoc ../Copying.txt ../Readme.md || die "dodoc failed"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog
	elog "Note: The opening book hasn't been installed. If you want it, just"
	elog "      download it from ${HOMEPAGE}."
	elog "      In most cases you take now your xboard compatible application,"
	elog "      (xboard, eboard, knights) and just play chess against computer"
	elog "      opponent. Have fun."
	elog
}
