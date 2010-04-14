# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/repository.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/mi-local.aadl \
	$(srcdir)/multiple_instances.aadl \
	$(srcdir)/scenario_local.aadl

REF_OUTPUTS = $(srcdir)/node_a.ref

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES=
CHECKABLE_SCENARIO_FILES=

if HAS_GNATMAKE_FOR_LEON
   SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
endif

if HAS_TSIM_FOR_LEON
   CHECKABLE_SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES) \
        $(REF_OUTPUTS)

CLEANDIRS = multiple_instances_leon
