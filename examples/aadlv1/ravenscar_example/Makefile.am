# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/auxiliary.ads \
	$(srcdir)/events.ads \
	$(srcdir)/event_source.ads \
	$(srcdir)/logs.ads \
	$(srcdir)/production_workload.ads \
	$(srcdir)/work.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

REF_OUTPUTS = $(srcdir)/wom_leon_local.ref

AADL_SOURCES = \
	$(srcdir)/hw_leon.aadl \
	$(srcdir)/hw_leon_local.aadl \
	$(srcdir)/hw_native.aadl \
	$(srcdir)/ravenscar_example.aadl \
	$(srcdir)/scenario_leon.aadl \
	$(srcdir)/scenario_leon_local.aadl \
	$(srcdir)/scenario_native.aadl

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES = $(srcdir)/scenario_native.aadl
CHECKABLE_SCENARIO_FILES =

if HAS_GNATMAKE_FOR_LEON
   SCENARIO_FILES+=$(srcdir)/scenario_leon_local.aadl
endif

if HAS_TSIM_FOR_LEON
   CHECKABLE_SCENARIO_FILES+=$(srcdir)/scenario_leon_local.aadl
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES) \
        $(REF_OUTPUTS)

CLEANDIRS=case_study_native case_study_leon_local
