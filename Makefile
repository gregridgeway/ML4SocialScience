# Makefile: Efficient Quarto rendering for both HTML and PDF

QMD_FILES := $(wildcard *.qmd)
HTML_FILES := $(QMD_FILES:.qmd=.html)
PDF_FILES := $(QMD_FILES:.qmd=.pdf)

all: $(HTML_FILES) $(PDF_FILES)

# One rule to render both outputs efficiently
%.html %.pdf: %.qmd
	quarto render $<

html: $(HTML_FILES)
pdf: $(PDF_FILES)

clean:
	rm -f $(HTML_FILES) $(PDF_FILES)
