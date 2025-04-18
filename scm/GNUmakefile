# scm/GNUmakefile

depth = ..

TEMPLATES = install-out install po

# This assignment is lazy and uses the function src-wildcard that will only
# be defined when including the templates. The reason we need this here is the
# definition of local-po in po-targets.make, which checks that ALL_PO_SOURCES
# is not empty.
SCM_FILES = $(call src-wildcard,*.scm)
GEN_SCM_FILES = $(outdir)/font-encodings.scm

INSTALLATION_DIR = $(local_lilypond_datadir)/scm/lily
INSTALLATION_FILES = $(SCM_FILES)

INSTALLATION_OUT_DIR = $(INSTALLATION_DIR)
INSTALLATION_OUT_FILES = $(GEN_SCM_FILES)

XGETTEXT_FLAGS = --language=Scheme

include $(depth)/make/lilypond.make

$(outdir)/font-encodings.scm: $(buildscript-dir)/generate-encodings.py
	$(call ly_progress,Making,$@,< $(notdir $<))
	$(PYTHON) $< -s > $@

TAGS_SOURCES += $(SCM_FILES)

# Sync with $(tree-share-prefix) in the top-level GNUmakefile.in!
tree-share-prefix = $(top-build-dir)/out/share/lilypond/current
guile-ccache = $(tree-share-prefix)/guile-bytecode

$(outdir)/%.scm: | %.scm
	ln -sf $(abs-src-dir)/$*.scm $@

LINKED_SCM_FILES = $(addprefix $(outdir)/,$(SCM_FILES))

default: $(GEN_SCM_FILES) $(LINKED_SCM_FILES)

ifndef VERBOSE
  # TODO: Guile 3.0.11 will have an -I command-line switch to "silence
  # informative diagnostics."  Once available, figure out how to use it from
  # within lilypond.
  GUILE_COMPILE_QUIET = 2>&1 | grep -v '^;;; compil\(ing\|ed\) '
else
  GUILE_COMPILE_QUIET =
endif

# This rule depends on *all* .scm files because Guile is horribly bad at
# dependency tracking for macros. If any of the source files changes, we
# have to rebuild the entire bytecode to be sure.
#
# We depend on `LINKED_SCM_FILES`, which relies on the order-only
# prerequisite for `%.scm` to link the Scheme files to the output directory.
$(outdir)/bytecode.dummy: compile.ly $(LINKED_SCM_FILES) $(GEN_SCM_FILES)
	$(RM) -f $(outdir)/*.go
	$(RM) -r $(guile-ccache)
	GUILE_AUTO_COMPILE=1 $(LILYPOND_BINARY) $< $(GUILE_COMPILE_QUIET)
	for i in $$(find $(guile-ccache) -name "*.scm.go"); do \
		mv $$i $(outdir)/$$(basename $$i .scm.go).go; \
	done
	$(RM) -r $(guile-ccache)
	touch $@ $(outdir)/bytecode-default.dummy

# Due to Guile's problems figuring out if files need to be recompiled if macros
# are involved, make the default target delete *all* of them if any of the
# source files changes.
$(outdir)/bytecode-default.dummy: $(LINKED_SCM_FILES) $(GEN_SCM_FILES)
	[ ! -f $(outdir)/lily.go ] || \
		echo "*** Changes in source .scm file detected, purging all compiled bytecode!"
	$(RM) -f $(outdir)/*.go
	touch $@

.PHONY: no-bytecode
no-bytecode: $(outdir)/bytecode-default.dummy

bytecode_installation_dir = $(local_lilypond_libdir)/ccache/lily

.PHONY: bytecode \
        install-bytecode

ifeq ($(strip $(CROSS)),no)
  bytecode: $(outdir)/bytecode.dummy
  install-bytecode:
	  -$(INSTALLPY) -d $(DESTDIR)$(bytecode_installation_dir)
	  $(INSTALLPY) -m 644 $(wildcard $(outdir)/*.go) \
	               $(DESTDIR)$(bytecode_installation_dir)/

  ifeq ($(BYTECODE),yes)
    default: bytecode
    local-install: install-bytecode
  else
    default: no-bytecode
    local-install:
  endif
else
  bytecode \
  install-bytecode:
	  $(error Scheme byte-compilation disabled while cross-compiling)

  default: no-bytecode
  local-install:
endif
