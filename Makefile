## Create the pvl lemma file
genlemmas: 
	rm -f libs/lemmas.pvl
	echo "(* WARNING: File generated from lemmas.m4.pvl *)" > libs/lemmas.pvl
	cpp -P -E -w --define-macro=LEMMA libs/lemmas.cpp.pvl | sed -e "s/PROPNAME/lemma/g" >> libs/lemmas.pvl
	cpp -P -E -w --define-macro=AXIOM libs/lemmas.cpp.pvl | sed -e "s/PROPNAME/axiom/g" >> libs/lemmas.pvl


############# Parameter configuration #############

config-basic:
	rm -f params/switches.pvl
	echo "(* Header encryption disallowed, DHs compromise disallowed, SPK reuse disallowed *)" > params/switches.pvl
	cat params/switch-options/basic.pvl >> params/switches.pvl

config-dhs-headers-spk:
	rm -f params/switches.pvl
	echo "(* Header encryption allowed, DHs compromise allowed, SPK reuse allowed *)" > params/switches.pvl
	cat params/switch-options/headers-dhs-spk.pvl >> params/switches.pvl

config-dhs-headers:
	rm -f params/switches.pvl
	echo "(* Header encryption allowed, DHs compromise allowed, SPK reuse disallowed *)" > params/switches.pvl
	cat params/switch-options/headers-dhs.pvl >> params/switches.pvl

config-headers-spk:
	rm -f params/switches.pvl
	echo "(* Header encryption allowed, DHs compromise disallowed, SPK reuse allowed *)" > params/switches.pvl
	cat params/switch-options/headers-spk.pvl >> params/switches.pvl

config-headers:
	rm -f params/switches.pvl
	echo "(* Header encryption allowed, DHs compromise disallowed, SPK reuse disallowed *)" > params/switches.pvl
	cat params/switch-options/headers.pvl >> params/switches.pvl

config-dhs:
	rm -f params/switches.pvl
	echo "(* Header encryption disallowed, DHs compromise allowed, SPK reuse disallowed *)" > params/switches.pvl
	cat params/switch-options/dhs.pvl >> params/switches.pvl

config-dhs-spk:
	rm -f params/switches.pvl
	echo "(* Header encryption disallowed, DHs compromise allowed, SPK reuse allowed *)" > params/switches.pvl
	cat params/switch-options/dhs-spk.pvl >> params/switches.pvl

config-spk:
	rm -f params/switches.pvl
	echo "(* Header encryption disallowed, DHs compromise disallowed, SPK reuse allowed *)" > params/switches.pvl
	cat params/switch-options/spk.pvl >> params/switches.pvl

config-unfixed:
	rm -f params/switches.pvl
	echo "(* Disable the none-ck specification fix *)" > params/switches.pvl
	cat params/switch-options/unfixed.pvl >> params/switches.pvl

############# Libraries #############

CoreLibs = -lib params/switches.pvl\
		-lib libs/gsverif_library.pvl\
		-lib libs/crypto.pvl\
		-lib libs/format.pvl\
		-lib libs/proof_helpers.pvl\
		-lib models/DR-functions.pvl\
		-lib libs/lemmas.pvl\

DRlibsComp = -lib params/params-all-comp.pvl\
		 $(CoreLibs) \
		 -lib models/DR-model.pvl\

DRlibsNoComp = -lib params/params-no-comp.pvl\
		 $(CoreLibs) \
		 -lib models/DR-model.pvl\

FULLlibsComp = 	-lib params/params-all-comp.pvl\
				$(CoreLibs)\
				-lib models/PQXDH-model.pvl\
				-lib models/FULL-model.pvl\

FULLlibsCompPrecise = 	-lib params/params-all-comp-precise.pvl\
						$(CoreLibs)\
						-lib models/PQXDH-model.pvl\
						-lib models/FULL-model.pvl\

FULLlibsNoComp =-lib params/params-no-comp.pvl\
				$(CoreLibs)\
				-lib models/PQXDH-model.pvl\
				-lib models/FULL-model.pvl\

############# Attacks #############

fs-attack-replay: genlemmas config-dhs
	proverif \
		$(DRlibsComp) \
		attacks/fs-attack-replay.pv

fs-attack-none-ck: genlemmas config-unfixed
	proverif \
		$(DRlibsComp) \
		attacks/fs-attack-none-ck.pv

fs-attack-weak-state: genlemmas config-dhs
	proverif \
		$(FULLlibsComp) \
		attacks/fs-attack-weak-state.pv

############# DR Proofs #############

## State and secrecy lemmas (6)

dr-lemma1: genlemmas 
	proverif \
		$(DRlibsComp) \
		DR-proofs/lemmas/proof_lemma1.pv

dr-lemma2: genlemmas 
	proverif \
		$(DRlibsComp) \
		DR-proofs/lemmas/proof_lemma2.pv

dr-lemma3: genlemmas 
	proverif \
		$(DRlibsComp) \
		DR-proofs/lemmas/proof_lemma3.pv

dr-lemma4: genlemmas 
	proverif \
		$(DRlibsComp) \
		DR-proofs/lemmas/proof_lemma4.pv

dr-lemma5: genlemmas 
	proverif \
		$(DRlibsComp) \
		DR-proofs/lemmas/proof_lemma5.pv

dr-lemma6: genlemmas 
	proverif \
		$(DRlibsComp) \
		DR-proofs/lemmas/proof_lemma6.pv

## Sanities (5) dr-sanity is most basic

dr-sanity: genlemmas
	proverif \
		$(DRlibsNoComp) \
		DR-proofs/sanity/sanity.pv

dr-sanity2: genlemmas
	proverif \
		$(DRlibsNoComp) \
		DR-proofs/sanity/sanity2.pv

dr-sanity3: genlemmas
	proverif \
		$(DRlibsNoComp) \
		DR-proofs/sanity/sanity3.pv

dr-sanity4: genlemmas
	proverif \
		$(DRlibsNoComp) \
		DR-proofs/sanity/sanity4.pv

dr-sanity5: genlemmas
	proverif \
		$(DRlibsNoComp) \
		DR-proofs/sanity/sanity5.pv

## FS and PCS proofs

dr-fs: genlemmas
	proverif \
		$(DRlibsComp) \
		DR-proofs/proof_fs.pv

dr-pcs: genlemmas
	proverif \
		$(DRlibsComp) \
		DR-proofs/proof_pcs.pv

############# Full Proofs #############

## State and secrecy lemmas (6)

full-lemma1: genlemmas 
	proverif \
		$(FULLlibsComp) \
		-lib libs/full_restrictions.pvl\
		FULL-proofs/lemmas/proof_lemma1.pv

full-lemma2: genlemmas 
	proverif \
		$(FULLlibsComp) \
		-lib libs/full_restrictions.pvl\
		FULL-proofs/lemmas/proof_lemma2.pv

full-lemma3: genlemmas 
	proverif \
		$(FULLlibsComp) \
		-lib libs/full_restrictions.pvl\
		FULL-proofs/lemmas/proof_lemma3.pv

full-lemma4: genlemmas 
	proverif \
		$(FULLlibsComp) \
		-lib libs/full_restrictions.pvl\
		FULL-proofs/lemmas/proof_lemma4.pv

full-lemma5: genlemmas 
	proverif \
		$(FULLlibsCompPrecise) \
		-lib libs/full_restrictions.pvl\
		FULL-proofs/lemmas/proof_lemma5.pv

full-lemma6: genlemmas 
	proverif \
		$(FULLlibsComp) \
		-lib libs/full_restrictions.pvl\
		FULL-proofs/lemmas/proof_lemma6.pv

## Sanity

full-sanity: genlemmas
	proverif \
		$(FULLlibsNoComp) \
		FULL-proofs/sanity.pv

## FS and PCS proofs

full-fs: genlemmas
	proverif \
		$(FULLlibsComp) \
		-lib libs/full_restrictions.pvl\
		FULL-proofs/proof_fs.pv

full-pcs: genlemmas
	proverif \
		$(FULLlibsComp) \
		-lib libs/full_restrictions.pvl\
		FULL-proofs/proof_pcs.pv