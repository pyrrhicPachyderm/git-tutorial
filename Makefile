SHELL := /bin/bash
LATEXMK_FLAGS = --pdf --cd
RM := rm -f

slidedoc := slides
notedoc := notes
handoutdoc := handout
content_tex_files := presentation.tex
supporting_tex_files := theme.tex

all: $(slidedoc).pdf $(notedoc).pdf $(handoutdoc).pdf
.PHONY: all

%.pdf: %.tex  $(content_tex_files) $(supporting_tex_files)
	latexmk $(LATEXMK_FLAGS) --jobname="$(basename $@)" $<

clean:
	@(\
		shopt -s globstar;\
		$(RM) **/*.aux **/*.log **/*.fls **/*.fdb_latexmk;\
		$(RM) **/*.out **/*.nav **/*.snm **/*.toc **/*.vrb;\
	)
	@$(RM) $(slidedoc).pdf $(notedoc).pdf $(handoutdoc).pdf
.PHONY: clean

spellcheck: $(content_tex_files)
	@for file in $^; do \
		aspell check --per-conf=./aspell.conf "$$file" ;\
	done
.PHONY: spellcheck

#Never remove secondary files; .SECONDARY with no dependencies.
.SECONDARY:
