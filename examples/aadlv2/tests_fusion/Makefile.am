SUBDIRS = test_1 \
          test_2 \
          test_3 \
          test_4 \
          test_5 \
          test_6 \
          test_7 \
          test_8

LOCAL_FILES = $(srcdir)/compile_all.sh \
              $(srcdir)/testall.sh \
              $(srcdir)/analyze_all.sh \
              $(srcdir)/single_fusion.sh \
              $(srcdir)/load_file_list \
              $(srcdir)/README

EXTRA_DIST = $(LOCAL_FILES)

SAMPLE_DIR = ${shell $(CYGPATH_U) '$(OCARINA_RUNTIME)/../../../examples/ocarina/polyorb-hi-ada/aadlv2/tests_fusion'}

install-data-local:
	$(INSTALL) -d $(DESTDIR)$(SAMPLE_DIR)
	$(INSTALL) $(LOCAL_FILES) $(DESTDIR)$(SAMPLE_DIR)

uninstall-local:
	rm -rf $(DESTDIR)$(SAMPLE_DIR)

debug-makefile:
	for dir in $(SUBDIRS); do \
	  $(MAKE) -C $${dir} debug-makefile; \
	done

all-local:
	@echo "TO BUILD EXAMPLES, YOU SHOULD ISSUE '$(MAKE) build-all'"

check-all:

build-all:
#	$(DESTDIR)/$(SAMPLE_DIR)/testall.sh && $(DESTDIR)/$(SAMPLE_DIR)/compile_all.sh
# XXX deactivated, need to correct path issues for distcheck
