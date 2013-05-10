# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit kde4-base

MY_PN="gmailnotifier-keluoinhac"
MY_PV="0.2.2"
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="GMail Notifier Plasmoid"
HOMEPAGE="http://kde-apps.org/content/show.php?content=153658"
SRC_URI="http://kde-apps.org/CONTENT/content-files/153658-${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

S="${WORKDIR}/${MY_P}"