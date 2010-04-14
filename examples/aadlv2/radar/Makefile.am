# BEGIN: DO NOT DELETE THIS LINE

ADA_SPECS_WITH_BODY = $(srcdir)/radar.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = $(srcdir)/radar.aadl $(srcdir)/radar_types.aadl	\
	$(srcdir)/scenario-ork-ada.aadl

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common
SCENARIO_FILES=

if HAS_GNATMAKE_FOR_LEON
   SCENARIO_FILES+=$(srcdir)/scenario-ork-ada.aadl
endif

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES)

CLEANDIRS=radar_simple
