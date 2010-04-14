SUBDIRS = rma ping some_types sunseeker d3.1.3-1 d3.1.3-1_extended	\
          flight_mgmt import mpc multiple_instances prime_numbers	\
          producer_consumer subprogram_ports ravenscar_example		\
          mode_switch delayed_connections tests_fusion radar		\
          device_drivers ping_overflow rasta

CHECKABLE_SUBDIRS = rma ping sunseeker d3.1.3-1 import prime_numbers	\
                    mode_switch ravenscar_example delayed_connections	\
                    flight_mgmt multiple_instances

EXTRA_DIST = $(srcdir)/../Makefile.common

SAMPLE_DIR = ${shell $(CYGPATH_U) '$(OCARINA_RUNTIME)/../../../examples/ocarina/polyorb-hi-ada/aadlv2'}

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
