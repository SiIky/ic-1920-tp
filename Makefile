all: contador.mcrl2 contador.lps contador.lts

%.lps: %.mcrl2
	mcrl22lps $< $@

%.lts: %.lps
	lps2lts $< $@
