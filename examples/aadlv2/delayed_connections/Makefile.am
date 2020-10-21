# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/delayed_connections.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/dc-local.aadl \
	$(srcdir)/software.aadl

REF_OUTPUTS = $(srcdir)/node_a_leon.ref

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES= $(srcdir)/scenario_local.aadl
CHECKABLE_SCENARIO_FILES=$(srcdir)/scenario_local.aadl

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES) \
	$(REF_OUTPUTS)

CLEANDIRS=delayed_connections_leon
