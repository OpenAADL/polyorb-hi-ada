# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/toy.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/toy_example.aadl

REF_OUTPUTS = $(srcdir)/gnc_tmtc_pos.ref

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES=
CHECKABLE_SCENARIO_FILES=

if HAS_GNATMAKE_FOR_LEON
  SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
if HAS_TSIM_FOR_LEON
  CHECKABLE_SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
endif
endif

if HAS_GNATMAKE_FOR_LEON_GNAT
  SCENARIO_FILES+=$(srcdir)/scenario_local_gnat.aadl
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES) \
        $(REF_OUTPUTS)

CLEANDIRS=toy_example_leon toy_example_leon_gnat
