AC_PREREQ(2.57)
AC_INIT(PolyORB-HI/Ada, 1.1w, polyorb-hi-devel@listes.enst.fr)
AC_CONFIG_SRCDIR(src)
AC_CONFIG_AUX_DIR(support)

##########################################
# Initialization.
##########################################

AC_CANONICAL_SYSTEM
AM_INIT_AUTOMAKE([1.9 tar-pax] foreign)

##########################################
# Check fo various programs.
##########################################

AC_CHECK_PROG(MV, mv, mv)
AC_CHECK_PROG(RM, rm, rm)
AC_CHECK_PROG(CP, cp, cp)
AC_CHECK_PROG(GREP, grep, grep)
AC_CHECK_PROG(CHMOD, chmod, chmod)
AC_CHECK_PROG(TEX, tex, tex)
AC_CHECK_PROG(BIBTEX, bibtex, bibtex)
AC_PROG_RANLIB
AC_EXEEXT

##########################################
# Check for GNU Make
##########################################

AM_GNU_MAKE

##########################################
# Check for various GNAT installations
##########################################

# The user must have at least an operation native GNAT Ada compiler

AM_PROG_WORKING_ADA

AM_PROG_GNATMAKE
AM_PROG_WORKING_ADA
AC_CHECK_PROG(GNATCLEAN, gnatclean, gnatclean)

# Chech for GNAT for LEON and GNAT for ERC32. Since they are two
# different targets, we cannot use the configure --target flag that
# enable to specify a unique target platform. We cannot use
# AM_CROSS_PROG_GNATMAKE either fro the same reasons.

TAB="   "

AC_CHECK_PROG(GNATMAKE_FOR_LEON, sparc-elf-gnatmake, sparc-elf-gnatmake)
AC_CHECK_PROG(GNATCLEAN_FOR_LEON, sparc-elf-gnatclean, sparc-elf-gnatclean)
AC_CHECK_PROG(TSIM_FOR_LEON, tsim-leon, tsim-leon)
AC_CHECK_PROG(GNATMAKE_FOR_LEON_GNAT, leon-elf-gnatmake, leon-elf-gnatmake)
AC_CHECK_PROG(GNATCLEAN_FOR_LEON_GNAT, leon-elf-gnatclean, leon-elf-gnatclean)
AC_SUBST(GNATMAKE_FOR_LEON)
AC_SUBST(GNATCLEAN_FOR_LEON)
AC_SUBST(TSIM_FOR_LEON)
AC_SUBST(GNATMAKE_FOR_LEON_GNAT)
AC_SUBST(GNATCLEAN_FOR_LEON_GNAT)
AM_CONDITIONAL(HAS_GNATMAKE_FOR_LEON, [test ! "x$GNATMAKE_FOR_LEON" = "x"])
AM_CONDITIONAL(HAS_TSIM_FOR_LEON, [test ! "x$TSIM_FOR_LEON" = "x"])
AM_CONDITIONAL(HAS_GNATMAKE_FOR_LEON_GNAT, [test ! "x$GNATMAKE_FOR_LEON_GNAT" = "x"])

if test "x$GNATMAKE_FOR_LEON" = "x"; then
   AC_MSG_WARN([
${TAB}${TAB}${TAB} GNAT for LEON target has not been found. 
${TAB}${TAB}${TAB} All examples using this platform will 
${TAB}${TAB}${TAB} be disabled.])
fi

if test "x$GNATMAKE_FOR_LEON_GNAT" = "x"; then
   AC_MSG_WARN([
${TAB}${TAB}${TAB} GNATPRO for LEON target has not been found. 
${TAB}${TAB}${TAB} All examples using this platform will 
${TAB}${TAB}${TAB} be disabled.])
fi

AC_CHECK_PROG(GNATMAKE_FOR_ERC32, erc32-elf-gnatmake, erc32-elf-gnatmake)
AC_CHECK_PROG(GNATCLEAN_FOR_ERC32, erc32-elf-gnatclean, erc32-elf-gnatclean)
AC_CHECK_PROG(TSIM_FOR_ERC32, tsim-erc32, tsim-erc32)
AC_SUBST(GNATMAKE_FOR_ERC32)
AC_SUBST(GNATCLEAN_FOR_ERC32)
AC_SUBST(TSIM_FOR_ERC32)
AM_CONDITIONAL(HAS_GNATMAKE_FOR_ERC32, [test ! "x$GNATMAKE_FOR_ERC32" = "x"])
AM_CONDITIONAL(HAS_TSIM_FOR_ERC32, [test ! "x$TSIM_FOR_ERC32" = "x"])

if test "x$GNATMAKE_FOR_ERC32" = "x"; then
   AC_MSG_WARN([
${TAB}${TAB}${TAB} GNAT for ERC32 target has not been found. 
${TAB}${TAB}${TAB} All examples using this platform will 
${TAB}${TAB}${TAB} be disabled.])
fi

AC_CHECK_PROG(GNATMAKE_FOR_MARTE, mgnatmake, mgnatmake)
AC_SUBST(GNATMAKE_FOR_MARTE)
AM_CONDITIONAL(HAS_GNATMAKE_FOR_MARTE, [test ! "x$GNATMAKE_FOR_MARTE" = "x"])

if test "x$GNATMAKE_FOR_MARTE" = "x"; then
   AC_MSG_WARN([
${TAB}${TAB}${TAB} GNAT for MARTE target has not been found. 
${TAB}${TAB}${TAB} All examples using this platform will 
${TAB}${TAB}${TAB} be disabled.])
fi

##########################################
# Check for Ocarina
##########################################

AM_PATH_OCARINA(1.1, ,AC_MSG_ERROR([Ocarina 1.1 or later is not installed on your system]))

##########################################
# Check for maintainer (debug) mode.
##########################################

GNATFLAGS=""

define(DEBUG_OPTIONS, [dnl
  GNATFLAGS="-XBUILD=debug"
  WARNINGS_ARE_ERRORS=""
  debug=true])
define(NODEBUG_OPTIONS, [dnl
  GNATFLAGS="-XBUILD=release"
  WARNINGS_ARE_ERRORS="--  "
  debug=false])

AC_ARG_ENABLE(debug,
[  --enable-debug          Turn on debugging options],
[if [[ "$enableval" = "yes" ]]; then
  DEBUG_OPTIONS
else
  NODEBUG_OPTIONS
fi],
[DEBUG_OPTIONS])

AC_SUBST(GNATFLAGS)
AC_SUBST(WARNINGS_ARE_ERRORS)
AM_CONDITIONAL(DEBUG, test x$debug = xtrue)

##########################################
# Windows requires specific targets
##########################################

case "$host_os" in
  cygwin* | mingw*)
    windows=true
    ;;
  *)
    windows=false
    ;;
esac
AM_CONDITIONAL(WINDOWS, test x$windows = xtrue)

############################################
# Set the value corresponding to cygpath -u
############################################

if test x"$CYGPATH_W" = x"echo"; then
   CYGPATH_U="echo"
else
   CYGPATH_U="cygpath -u"
fi
AC_SUBST(CYGPATH_U)

###############################################################
# Force the installation prefix to be equal to the Ocarina one
###############################################################

prefix='$(OCARINA_PREFIX)'

##########################################
# Output generated files
##########################################

dnl Important! One file per line, nothing before
dnl or after except whitespace! This section
dnl may, one day, be edited automatically to remove 
dnl some entries.

AC_OUTPUT([
	Makefile
	doc/Makefile
	support/Makefile
	tools/Makefile
	share/Makefile
	share/make/Makefile
	src/Makefile
	src/polyorb_hi.gpr
	examples/Makefile
	examples/aadlv1/Makefile
	examples/aadlv1/d3.1.3-1_extended/Makefile
	examples/aadlv1/d3.1.3-1/Makefile
	examples/aadlv1/delayed_connections/Makefile
	examples/aadlv1/flight_mgmt/Makefile
	examples/aadlv1/import/Makefile
	examples/aadlv1/mode_switch/Makefile
	examples/aadlv1/mpc/Makefile
	examples/aadlv1/multiple_instances/Makefile
	examples/aadlv1/ping/Makefile
	examples/aadlv1/prime_numbers/Makefile
	examples/aadlv1/producer_consumer/Makefile
	examples/aadlv1/radar/Makefile
	examples/aadlv1/ravenscar_example/Makefile
	examples/aadlv1/rap/Makefile
	examples/aadlv1/rma/Makefile
	examples/aadlv1/some_types/Makefile
	examples/aadlv1/subprogram_ports/Makefile
	examples/aadlv1/sunseeker/Makefile
	examples/aadlv2/Makefile
	examples/aadlv2/rma/Makefile
	examples/aadlv2/ping/Makefile
	examples/aadlv2/ping_overflow/Makefile
	examples/aadlv2/some_types/Makefile
	examples/aadlv2/sunseeker/Makefile
        examples/aadlv2/d3.1.3-1/Makefile
        examples/aadlv2/d3.1.3-1_extended/Makefile
	examples/aadlv2/device_drivers/Makefile
        examples/aadlv2/flight_mgmt/Makefile
        examples/aadlv2/import/Makefile
        examples/aadlv2/mpc/Makefile
        examples/aadlv2/multiple_instances/Makefile
        examples/aadlv2/prime_numbers/Makefile
        examples/aadlv2/producer_consumer/Makefile
        examples/aadlv2/subprogram_ports/Makefile
	examples/aadlv2/radar/Makefile
        examples/aadlv2/rasta/Makefile
        examples/aadlv2/ravenscar_example/Makefile
        examples/aadlv2/mode_switch/Makefile
        examples/aadlv2/delayed_connections/Makefile
	examples/aadlv2/tests_fusion/Makefile
	examples/aadlv2/tests_fusion/test_1/Makefile
	examples/aadlv2/tests_fusion/test_2/Makefile
	examples/aadlv2/tests_fusion/test_3/Makefile
	examples/aadlv2/tests_fusion/test_4/Makefile
	examples/aadlv2/tests_fusion/test_5/Makefile
	examples/aadlv2/tests_fusion/test_6/Makefile
	examples/aadlv2/tests_fusion/test_7/Makefile
	examples/aadlv2/tests_fusion/test_8/Makefile
])

AC_MSG_NOTICE(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%)
AC_MSG_NOTICE(PolyORB High Integrity configuration is complete!)
AC_MSG_NOTICE(GNU make command name: "$GNU_MAKE")
AC_MSG_NOTICE(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%)
