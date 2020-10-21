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

SCENARIO_FILES=$(srcdir)/scenario.aadl $(srcdir)/scenario_local.aadl
CHECKABLE_SCENARIO_FILES=$(SCENARIO_FILES)

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES) \
	$(REF_OUTPUTS) $(srcdir)/import.c

CLEANDIRS=ping_native ping_leon
