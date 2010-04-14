SUBDIRS = d3.1.3-1 radar d3.1.3-1_extended import mpc ping		\
	producer_consumer rma some_types sunseeker flight_mgmt		\
	mode_switch subprogram_ports delayed_connections prime_numbers	\
	multiple_instances ravenscar_example rap

CHECKABLE_SUBDIRS = d3.1.3-1 import ping rma sunseeker flight_mgmt	\
                    mode_switch delayed_connections prime_numbers	\
                    multiple_instances ravenscar_example

EXTRA_DIST = $(srcdir)/../Makefile.common

SAMPLE_DIR = ${shell $(CYGPATH_U) '$(OCARINA_RUNTIME)/../../../examples/ocarina/polyorb-hi-ada/aadlv1'}

install-data-local:
	$(INSTALL) -d $(DESTDIR)$(SAMPLE_DIR)
	$(INSTALL_DATA) $(srcdir)/README $(DESTDIR)$(SAMPLE_DIR)

uninstall-local:
	rm -rf $(DESTDIR)$(SAMPLE_DIR)

debug-makefile:
	for dir in $(SUBDIRS); do \
	  $(MAKE) -C $${dir} debug-makefile; \
	done

all-local:
	@echo "TO BUILD EXAMPLES, YOU SHOULD ISSUE '$(MAKE) build-all'"

build-all:
	for dir in $(SUBDIRS); do \
	  ($(MAKE) -C $${dir} build-all) || exit 1; \
	done

check-all:
	for dir in $(CHECKABLE_SUBDIRS); do \
          ($(MAKE) -C $${dir} check-all) || exit 1; \
        done
