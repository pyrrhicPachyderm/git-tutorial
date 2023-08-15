SHELL := /bin/bash
LATEXMK_FLAGS = --pdf --cd
RM := rm -f

slidedoc := slides
notedoc := notes
handoutdoc := handout
content_tex_files := presentation.tex
supporting_tex_files := theme.tex
supporting_image_files := sha1.pdf phd-final.png xkcd-git.png snapshot-2001-01-19.png snapshot-2004-05-29.png snapshot-2008-10-18.png
supporting_image_files := $(patsubst %,images/%,$(supporting_image_files))

all: $(slidedoc).pdf $(notedoc).pdf $(handoutdoc).pdf
.PHONY: all

%.pdf: %.tex $(content_tex_files) $(supporting_tex_files) $(supporting_image_files)
	latexmk $(LATEXMK_FLAGS) --jobname="$(basename $@)" $<

%.pdf: %.svg
	rsvg-convert -f pdf -o $@ $<
%.png: %.gif
	convert $< $@
%.png: %.jpg
	convert $< $@
%.png: %.tif
	convert $< $@

clean:
	@(\
		shopt -s globstar;\
		$(RM) **/*.aux **/*.log **/*.fls **/*.fdb_latexmk;\
		$(RM) **/*.out **/*.nav **/*.snm **/*.toc **/*.vrb;\
		$(RM) **/*.pdf;\
		$(RM) **/phd-*.png **/snapshot-*.png;\
	)
.PHONY: clean

spellcheck: $(content_tex_files)
	@for file in $^; do \
		aspell check --per-conf=./aspell.conf "$$file" ;\
	done
.PHONY: spellcheck

#Never remove secondary files; .SECONDARY with no dependencies.
.SECONDARY:
