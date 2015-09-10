/*
 *  This make file contains rules for creating packages
 *
 */

include ../../pkgrules.mk

:ALL: pkg-as pkg-gs 

pkg-as :PACKAGE: audio audio/english audio/spanish audio/vietnamese audio/cantonese audio/hmong package/as PKGTYPES=*.wav|*.sh|*.std|*.txt|depend|prototype|pkginfo|postinstall|postremove|i.fsu

pkg-gs :PACKAGE: gateway audio/english audio/spanish audio/vietnamese audio/cantonese audio/hmong package/gs report PKGTYPES=*.dbd|*.chk|*.dbu|*.wav|*.rod|*.rox|*.sh|*.txt|depend|prototype|pkginfo|postinstall|preremove|postremove|*.jsp|i.fsu
