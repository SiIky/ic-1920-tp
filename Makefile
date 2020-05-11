MD := report.md
PDF := $(MD:.md=.pdf)
DEPS := $(MD) \
    contador.mcrl2

TARGS := $(PDF) \
    contador.lps \
    contador.lts \
    contador.mcrl2

all: $(TARGS)

%.lps: %.mcrl2
	mcrl22lps $< $@

%.lts: %.lps
	lps2lts $< $@

%.pdf: %.md
	pandoc -f markdown -t latex $< -o $@

watch:
	ls -1 $(DEPS) | entr -c make

.PHONY: all watch
