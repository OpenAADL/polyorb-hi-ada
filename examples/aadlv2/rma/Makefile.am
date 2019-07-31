# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/hello.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/rma.aadl

REF_OUTPUTS = $(srcdir)/node_a.ref

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILE=$(srcdir)/scenario.aadl
CHECKABLE_SCENARIO_FILE=$(srcdir)/scenario.aadl

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILE) \
	$(REF_OUTPUTS)

CLEANDIRS=rma_erc32
