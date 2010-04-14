# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/msgs.ads \
	$(srcdir)/ping.ads \
	$(srcdir)/pinged.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY) \
	$(srcdir)/user_types.ads

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/ping.aadl \
	$(srcdir)/scenario.aadl \
	$(srcdir)/software.aadl

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILE=$(srcdir)/scenario.aadl

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILE)

CLEANDIRS=ping_native
