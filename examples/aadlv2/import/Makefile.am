# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY =

ADA_SPECS = $(ADA_SPECS_WITH_BODY) \
	$(srcdir)/ping_spec.ads

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb) \
	$(srcdir)/ping_body.adb

AADL_SOURCES = \
	$(srcdir)/ping.aadl \
	$(srcdir)/ping-local.aadl \
	$(srcdir)/software.aadl

REF_OUTPUTS = $(srcdir)/node_a_leon.ref

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES=$(srcdir)/scenario.aadl
CHECKABLE_SCENARIO_FILES=

if HAS_GNATMAKE_FOR_LEON
   SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
endif

if HAS_TSIM_FOR_LEON
   CHECKABLE_SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES) \
	$(REF_OUTPUTS) $(srcdir)/import.c

CLEANDIRS=ping_native ping_leon
