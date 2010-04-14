# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = $(srcdir)/polyorb_hi-aperiodic_task.ads	\
	$(srcdir)/polyorb_hi-background_task.ads		\
	$(srcdir)/polyorb_hi-hybrid_task.ads			\
	$(srcdir)/polyorb_hi-hybrid_task_driver.ads		\
	$(srcdir)/polyorb_hi-marshallers_g.ads			\
	$(srcdir)/polyorb_hi-messages.ads			\
	$(srcdir)/polyorb_hi-output.ads				\
	$(srcdir)/polyorb_hi-periodic_task.ads			\
	$(srcdir)/polyorb_hi-port_kinds.ads			\
	$(srcdir)/polyorb_hi-protocols.ads			\
	$(srcdir)/polyorb_hi-sporadic_task.ads			\
	$(srcdir)/polyorb_hi-suspenders.ads			\
	$(srcdir)/polyorb_hi-thread_interrogators.ads		\
	$(srcdir)/polyorb_hi-scheduler.ads			\
	$(srcdir)/polyorb_hi-utils.ads


ADA_SPECS = $(ADA_SPECS_WITH_BODY) $(srcdir)/polyorb_hi.ads	\
	$(srcdir)/polyorb_hi-errors.ads				\
	$(srcdir)/polyorb_hi_generated.ads			\
	$(srcdir)/polyorb_hi-output_low_level.ads		\
	$(srcdir)/polyorb_hi-port_type_marshallers.ads		\
	$(srcdir)/polyorb_hi-streams.ads			\
	$(srcdir)/polyorb_hi-time_marshallers.ads		\
	$(srcdir)/polyorb_hi-transport_low_level.ads

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)			\
	$(srcdir)/polyorb_hi-output_low_level_leon.adb		\
	$(srcdir)/polyorb_hi-output_low_level_native.adb	\
	$(srcdir)/polyorb_hi-transport_low_level_sockets.adb

# END: DO NOT DELETE THIS LINE

ADA_ADC = $(srcdir)/gnat.adc $(srcdir)/hi-e.adc $(srcdir)/native.adc

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(ADA_ADC)

alidir = ${shell $(CYGPATH_U) '$(OCARINA_RUNTIME)/polyorb-hi-ada'}

install-data-local:
	$(INSTALL) -d $(DESTDIR)$(alidir)
	for f in $(ADA_SPECS) $(ADA_BODIES) $(ADA_ADC) polyorb_hi.gpr; do \
          $(INSTALL) -m 444 $$f $(DESTDIR)$(alidir); \
        done;

uninstall-local:
	rm -rf $(DESTDIR)$(alidir)
