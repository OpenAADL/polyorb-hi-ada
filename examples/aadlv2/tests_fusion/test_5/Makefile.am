# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = \
	$(srcdir)/ping.ads \
	$(srcdir)/pinged.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = \
	$(srcdir)/ping_local.aadl \
        $(srcdir)/software.aadl

README_FILE = $(srcdir)/README

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../../Makefile.common

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(README_FILE)

CLEANDIRS=ping_erc32
