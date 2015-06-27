# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/sni-qt/sni-qt-0.2.6-r1.ebuild,v 1.2 2015/03/10 16:23:53 kensington Exp $

EAPI=5

inherit cmake-multilib

DESCRIPTION="A Qt plugin which turns all QSystemTrayIcon into StatusNotifierItems"
HOMEPAGE="https://launchpad.net/sni-qt"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +skype"

RDEPEND="
	dev-libs/libdbusmenu-qt[qt4,${MULTILIB_USEDEP}]
	>=dev-qt/qtcore-4.8.6:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtdbus-4.8.6:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtgui-4.8.6:4[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qttest-4.8.6:4[${MULTILIB_USEDEP}] )
"

src_prepare() {
	use skype && epatch "${FILESDIR}/skype.patch"

	if ! use test ; then
		comment_add_subdirectory tests/auto
	fi

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DQT_QMAKE_EXECUTABLE="/usr/$(get_libdir)/qt4/bin/qmake"
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	if use skype; then
		insinto /usr/share/pixmaps/skype
		doins "${FILESDIR}"/skype_*.svg
	fi

	cmake-utils_src_install
}
