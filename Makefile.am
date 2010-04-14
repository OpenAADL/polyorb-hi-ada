AUTOMAKE_OPTIONS = no-dependencies
ACLOCAL_AMFLAGS = -I support
CLEANFILES = config-stamp

SUBDIRS = support tools doc src share
DIST_SUBDIRS = $(SUBDIRS) examples

# Force the installation before running the testsuite
examples:: install
	$(MAKE) -C examples build-all

check-local: run-examples

run-examples:: examples
	$(MAKE) -C examples check-all

clean-examples::
	$(MAKE) -C examples clean

distclean-examples::
	$(MAKE) -C examples distclean

po_hi_doc_dir=${shell $(CYGPATH_U) '$(OCARINA_PREFIX)/share/doc/ocarina'}

install-data-local:
	$(MAKE) -C examples DESTDIR="$(DESTDIR)" install
	$(INSTALL) -d $(DESTDIR)$(po_hi_doc_dir) 
	$(INSTALL_DATA) $(srcdir)/ChangeLog $(DESTDIR)$(po_hi_doc_dir)/ChangeLog_polyorb_hi_ada

uninstall-local:
	$(MAKE) -C examples DESTDIR="$(DESTDIR)" uninstall
	rm -f $(DESTDIR)$(po_hi_doc_dir)/ChangeLog_polyorb_hi_ada

debug-makefile:
	@echo "GNATMAKE           = $(GNATMAKE)"
	@echo "GNATMAKE_FOR_LEON  = $(GNATMAKE_FOR_LEON)"
	@echo "GNATMAKE_FOR_ERC32 = $(GNATMAKE_FOR_ERC32)"
	$(MAKE) -C examples debug-makefile

