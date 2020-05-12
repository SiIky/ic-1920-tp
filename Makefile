MD := report.md
PDF := $(MD:.md=.pdf)
DEPS := $(MD) \
    contador.mcrl2

TARGS := $(DEPS) $(PDF) \
    contador.lps \
    contador.lts \
    contador.mcrl2

all: $(TARGS)

report.md: lpsxsim0.png lpsxsim10.png lpsxsim1.png ltsgraph_contador.png ltsview0.png ltsview10.png ltsview3.png

%.lps: %.mcrl2
	mcrl22lps $< $@

%.lts: %.lps
	lps2lts $< $@

%.pdf: %.md
	pandoc -f markdown -t latex $< -o $@

watch:
	ls -1 $(DEPS) | entr -c make

.PHONY: all watch
