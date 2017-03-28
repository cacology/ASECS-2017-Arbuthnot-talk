pdftargets := $(patsubst %.md,%.pdf,$(wildcard *.md))
mdxtargets := $(patsubst %.md,%.mdx,$(wildcard *.md))

listpdftargets : ; @echo $(pdftargets)
listmdxtargets : ; @echo $(mdxtargets)

all: final.pdf
.PHONY : all

allmdx : $(mdxtargets)
.PHONY : allmdx

%.mdx : %.md
	pandoc -t markdown-citations -f markdown --filter pandoc-citeproc -o $@ $<

final.tex : $(mdxtargets)
	pandoc -s -f markdown -t context -o final.tex headers.yaml $(mdxtargets)

%.tex : %.md
	pandoc -s -f markdown -t context --filter pandoc-citeproc -o $@ headers.yaml $<

%.pdf : %.tex
	context $<

%.docx : %.md
	pandoc -s -f markdown --filter pandoc-citeproc -o $@ $<

%.odt : %.md
	pandoc -s -f markdown --filter pandoc-citeproc -o $@ $<

slides.html : slides.md
	pandoc -t revealjs -S -s slides.md -o slides.html

.PHONY : clean
clean :
	find . \( -name "*.tuc" -o -name "*.log" -o -name "*.tex" -o -name "*.mdx" \) \! -iregex ".*rev.*" -delete

.PHONY : cleanall
cleanall :
	find . \( -name "*.pdf" -o -name "*.tuc" -o -name "*.log" -o -name "*.tex" -o -name "*.mdx" -o -name "*.docx" -o -name "*.odt" \) \! -iregex ".*rev.*" -delete
