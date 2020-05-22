MAXSTATES := 10

MD := report.md

MCRL2 := \
    Cm.mcrl2 \
    Ctm.mcrl2 \
    Ctm_lim.mcrl2 \
    buffers.mcrl2 \
    queue.mcrl2 \
    simple_c.mcrl2 \

MCF := \
    liveness1.mcf \
    liveness2.mcf \
    liveness3.mcf \
    qliveness1.mcf \
    qliveness2.mcf \
    qsafety1.mcf \
    qsafety2.mcf \
    safety1.mcf \
    safety2.mcf \
    safety3.mcf \

PBES := \
    Ctm_liveness1.pbes \
    Ctm_liveness2.pbes \
    Ctm_liveness3.pbes \
    Ctm_safety1.pbes \
    Ctm_safety2.pbes \
    Ctm_safety3.pbes \
    queue_qliveness1.pbes \
    queue_qliveness2.pbes \
    queue_qsafety1.pbes \
    queue_qsafety2.pbes \

LPS := $(MCRL2:.mcrl2=.lps)
LTS := $(MCRL2:.mcrl2=.lts)
PDF := $(MD:.md=.pdf)
PROPS := $(PBES:.pbes=.prop)

DEPS := $(MD) $(MCRL2) $(MCF)
TARGS := $(PDF) $(LTS) $(LPS) $(PBES)
ALL := $(DEPS) $(TARGS)

all: $(ALL)

props: $(PROPS)

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
	pbes2bool $<

Ctm_liveness1.pbes: liveness1.mcf Ctm.lps
	lps2pbes -f $^ $@

Ctm_liveness2.pbes: liveness2.mcf Ctm.lps
	lps2pbes -f $^ $@

Ctm_liveness3.pbes: liveness3.mcf Ctm.lps
	lps2pbes -f $^ $@

Ctm_safety1.pbes: safety1.mcf Ctm.lps
	lps2pbes -f $^ $@

Ctm_safety2.pbes: safety2.mcf Ctm.lps
	lps2pbes -f $^ $@

Ctm_safety3.pbes: safety3.mcf Ctm.lps
	lps2pbes -f $^ $@

queue_qsafety1.pbes: qsafety1.mcf queue.lps
	lps2pbes -f $^ $@

queue_qsafety2.pbes: qsafety2.mcf queue.lps
	lps2pbes -f $^ $@

queue_qliveness1.pbes: qliveness1.mcf queue.lps
	lps2pbes -f $^ $@

queue_qliveness2.pbes: qliveness2.mcf queue.lps
	lps2pbes -f $^ $@

exe3: Ctm_lim.lts Cm.lts
	./exe3.sh

clean:
	$(RM) $(TARGS)

.PHONY: all clean exe3 props watch
