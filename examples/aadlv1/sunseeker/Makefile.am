# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/sunseeker_controller_pkg.ads \
	$(srcdir)/sunseeker_plant_pkg.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/sunseeker.aadl \
	$(srcdir)/sunseeker_dist.aadl \
	$(srcdir)/sunseeker_local.aadl

REF_OUTPUTS = $(srcdir)/sunseeker_local.ref

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES=$(srcdir)/scenario_dist.aadl
CHECKABLE_SCENARIO_FILES=

if HAS_GNATMAKE_FOR_LEON
   SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
endif

if HAS_TSIM_FOR_LEON
   CHECKABLE_SCENARIO_FILES+=$(srcdir)/scenario_local.aadl
endif

if HAS_GNATMAKE_FOR_LEON_GNAT
   SCENARIO_FILES+=$(srcdir)/scenario_local_gnat.aadl
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES) \
        $(REF_OUTPUTS)

CLEANDIRS=sunseekercontrolsystem_type_native sunseekercontrolsystem_type_leon \
	sunseekercontrolsystem_type_leon_gnat
