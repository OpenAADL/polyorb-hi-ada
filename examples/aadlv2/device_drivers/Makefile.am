# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = $(srcdir)/ping.ads $(srcdir)/pinged.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = $(srcdir)/beeper.aadl $(srcdir)/generic_native.aadl	\
	$(srcdir)/software.aadl $(srcdir)/system_demo.aadl		\
	$(srcdir)/scenario.aadl

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES=$(srcdir)/scenario.aadl

if HAS_GNATMAKE_FOR_LEON
   SCENARIO_FILES+=
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES)

CLEANDIRS=the_demo_impl
