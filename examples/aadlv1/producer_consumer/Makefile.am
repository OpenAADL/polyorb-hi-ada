# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/producer_consumer.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/producer_consumer.aadl \
	$(srcdir)/software.aadl

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILE=$(srcdir)/scenario.aadl

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILE)

CLEANDIRS=pc_simple_native
