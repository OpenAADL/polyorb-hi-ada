# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/msgs.ads \
	$(srcdir)/ping.ads \
	$(srcdir)/pinged.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY) \
	$(srcdir)/user_types.ads

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

REF_OUTPUTS =  $(srcdir)/node_a_leon.ref

AADL_SOURCES = \
	$(srcdir)/ping.aadl \
	$(srcdir)/ping-local.aadl \
	$(srcdir)/scenario.aadl \
	$(srcdir)/scenario_local.aadl \
	$(srcdir)/scenario_local_gnat.aadl \
	$(srcdir)/software.aadl

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES=$(srcdir)/scenario.aadl
CHECKABLE_SCENARIO_FILES=

if HAS_GNATMAKE_FOR_MARTE
   SCENARIO_FILES+=$(srcdir)/scenario_local_marte.aadl
endif

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

CLEANDIRS=ping_native ping_leon ping_leon_gnat ping_marte
