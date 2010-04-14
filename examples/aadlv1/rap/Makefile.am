# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = $(srcdir)/ac_flight_data.ads			\
	$(srcdir)/builtin_test.ads $(srcdir)/computations.ads		\
	$(srcdir)/hotas.ads $(srcdir)/hud_display.ads $(srcdir)/hw.ads	\
	$(srcdir)/keyset.ads $(srcdir)/mpd_status_display.ads		\
	$(srcdir)/mpd_stores_display.ads				\
	$(srcdir)/mpd_tactical_display.ads				\
	$(srcdir)/radar_controller.ads $(srcdir)/rwr_control.ads	\
	$(srcdir)/rwr_threat_response.ads $(srcdir)/steering.ads	\
	$(srcdir)/target_designation.ads $(srcdir)/target_tracking.ads	\
	$(srcdir)/weapon_release.ads $(srcdir)/weapon_selection.ads	\
	$(srcdir)/weapon_trajectory.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = $(srcdir)/RAP.aadl $(srcdir)/RAP_LEON.aadl	\
	$(srcdir)/RAP_NATIVE.aadl

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILE=$(srcdir)/scenario_native.aadl

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILE) \
        $(REF_OUTPUTS)

CLEANDIRS=rap_native
