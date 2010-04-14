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

if HAS_GNATMAKE_FOR_ERC32
   SCENARIO_FILE=$(srcdir)/scenario.aadl
endif

if HAS_TSIM_FOR_ERC32
   CHECKABLE_SCENARIO_FILE=$(srcdir)/scenario.aadl
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILE) \
        $(REF_OUTPUTS)

CLEANDIRS=rma_erc32
