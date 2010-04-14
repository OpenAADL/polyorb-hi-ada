# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/repository.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/common.aadl \
	$(srcdir)/modes_CE.aadl \
	$(srcdir)/modes_CS.aadl \
	$(srcdir)/scenario_CE.aadl \
	$(srcdir)/scenario_CS.aadl

REF_OUTPUTS = $(srcdir)/mode_switch_ce.ref $(srcdir)/mode_switch_cs.ref

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES=
CHECKABLE_SCENARIO_FILES=

if HAS_GNATMAKE_FOR_ERC32
   SCENARIO_FILES+=$(srcdir)/scenario_CS.aadl $(srcdir)/scenario_CE.aadl
endif

if HAS_TSIM_FOR_ERC32
   CHECKABLE_SCENARIO_FILES+=$(srcdir)/scenario_CS.aadl $(srcdir)/scenario_CE.aadl
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES) \
        $(REF_OUTPUTS)

CLEANDIRS=test_modes_cs_erc32 test_modes_ce_erc32
