# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = $(wildcard $(srcdir)/polyorb_hi_drivers_*.ads)

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)		

# END: DO NOT DELETE THIS LINE

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES)

alidir = ${shell $(CYGPATH_U) '$(OCARINA_RUNTIME)/polyorb-hi-ada'}

install-data-local:
	$(INSTALL) -d $(DESTDIR)$(alidir)
	for f in $(ADA_SPECS) $(ADA_BODIES); do \
          $(INSTALL) -m 444 $$f $(DESTDIR)$(alidir); \
        done;

uninstall-local:
	rm -rf $(DESTDIR)$(alidir)
