EXTRA_DIST= $(srcdir)/Makefile.rtems_ada \
	$(srcdir)/rtems_init.c

CLEANFILES = *~

makesrc = ${shell $(CYGPATH_U) '$(OCARINA_RUNTIME)/polyorb-hi-ada/make'}

install-data-local:
	$(INSTALL) -d $(DESTDIR)$(makesrc)
	for f in $(EXTRA_DIST); do $(INSTALL) -m 444 $$f $(DESTDIR)$(makesrc) ; done

uninstall-local:
	rm -rf $(DESTDIR)$(makesrc)


