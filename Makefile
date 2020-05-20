MAXSTATES := 10

MD := report.md

MCRL2 := \
    Cm.mcrl2 \
    Ctm.mcrl2 \
    buffers.mcrl2 \
    queue.mcrl2 \
    simple_c.mcrl2 \

PDF := $(MD:.md=.pdf)
LTS := $(MCRL2:.mcrl2=.lts)
LPS := $(MCRL2:.mcrl2=.lps)

DEPS := $(MD) $(MCRL2)
TARGS := $(PDF) $(LTS) $(LPS)

ALL := $(DEPS) $(TARGS)

PROPS := \
    Ctm_liveness1.prop \
    Ctm_liveness2.prop \
    Ctm_liveness3.prop \
    Ctm_safety1.prop \
    Ctm_safety2.prop \
    Ctm_safety3.prop \

all: $(ALL) props

props: $(PROPS)
	cat $(PROPS)

report.md: lpsxsim0.png lpsxsim10.png lpsxsim1.png ltsgraph_contador.png ltsview0.png ltsview10.png ltsview3.png temporalProperties.png

%.lps: %.mcrl2
	mcrl22lps $< $@

Ctm.lts: Ctm.lps
	lps2lts -l $(MAXSTATES) Ctm.lps Ctm.lts

%.lts: %.lps
	lps2lts $< $@

%.pdf: %.md
	pandoc -s -f markdown -t latex $< -o $@

watch:
	ls -1 $(DEPS) | entr -c make

%.prop: %.pbes
	pbes2bool $< > $@

Ctm_liveness1.pbes: liveness1.mcf Ctm.lps
	lps2pbes --formula=liveness1.mcf Ctm.lps $@

Ctm_liveness2.pbes: liveness2.mcf Ctm.lps
	lps2pbes --formula=liveness2.mcf Ctm.lps $@

Ctm_liveness3.pbes: liveness3.mcf Ctm.lps
	lps2pbes --formula=liveness3.mcf Ctm.lps $@

Ctm_safety1.pbes: safety1.mcf Ctm.lps
	lps2pbes --formula=safety1.mcf Ctm.lps $@

Ctm_safety2.pbes: safety2.mcf Ctm.lps
	lps2pbes --formula=safety2.mcf Ctm.lps $@

Ctm_safety3.pbes: safety3.mcf Ctm.lps
	lps2pbes --formula=safety3.mcf Ctm.lps $@

clean:
	$(RM) $(TARGS)

.PHONY: all clean props watch
