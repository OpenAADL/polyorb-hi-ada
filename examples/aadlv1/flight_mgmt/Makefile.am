# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/manager.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/flt_mgmt.aadl \
	$(srcdir)/scenario_local.aadl \
	$(srcdir)/software.aadl

REF_OUTPUTS = $(srcdir)/mgmt.ref

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES=
CHECKABLE_SCENARIO_FILES=

if HAS_GNATMAKE_FOR_ERC32
   SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
endif

if HAS_TSIM_FOR_ERC32
   CHECKABLE_SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES) \
        $(REF_OUTPUTS)

CLEANDIRS = flight_mgmt_erc32
