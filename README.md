# Authors

- Vincent Cheval, University of Oxford <vincent.cheval@balliol.ox.ac.uk>
- Charlie Jacomme, Inria Grand Est <charlie.jacomme@inria.fr>
- Jessica Richards, University of Oxford <jessica.richards@kellogg.ox.ac.uk>

# ProVerif

We use a development version of ProVerif. All our tests were run on the following version:
https://gitlab.inria.fr/bblanche/proverif/-/tree/1a9ae40d62f44f937a7a68453c7841f5672a8d5c

# Models

We have four model files, as library files in `models/`:
 * `DR-functions.pvl` defines the main DR functions.
 * `PQXDH-model.pvl` defines the core PQXDH key exchange.
 * `DR-model.pvl`, initiates DR sessions with magical fresh keys.
 * `FULL-model.pvl`, composes PQXDH and DR.

The following folders contain additional files:
* `libs/` contains all common libraries to the different models
* `params/` folder containing many variants of configurations, sets several parameters to true/false.
* `attacks/` contains the attacks over the models.
* `DR-props/` contains the proofs over `DR-model.pvl`
* `FULL-props/` contains the proofs over `FULL-model.pvl`

# Configurations

We have several parameters in the model that can be turned on or off. These are stored in params/switches.pvl.

* `allow_DHs_param` - allows compromise of DHs keys (dhs)
* `allow_HE` - allows header encryption (headers)
* `allow_same_SPK` - allows reuse of SPK keys (spk)
* `fixed_version` - adds a check to prevent the none-ck attack 

The first three can be enabled / disabled by running the command `make config-OPTIONS` where `OPTIONS` are the desired features separated by dashes. E.g. `make config-dhs-headers-spk`. For all options disabled, run `make config-basic`.

Note under all standard configurations the `fixed_version` parameter is set to true, it should only be disabled in order to run the `fs-attack-none-ck.pv` file (this happens automatically in the make file).

# Attacks 

We have three attack files, that run on some query and return an attack against it.

 * `fs-attack-none-ck` - Corresponds to `attacks/fs-attack-none-ck.pv`. Directly attacks the forward secrecy query, using an unfixed DR specification that allows use of a none-ck for deriving message keys.
 * `fs-attack-replay` - Corresponds to `attacks/fs-attack-replay.pv`. Directly attacks the forward secrecy query, assuming two DR sessions can share an SK.
 * `fs-attack-weak-state` - Corresponds to `attacks/fs-attack-weak-state.pv`. Demonstrates that, due to the existence of weak states, compromise of medium term PQXDH information (SPK), can happen via a DR (DHs) compromise. Note this is not a full attack, but a demonstration of the issues that can arise from the storing of a weak state.

 For each attack in the Makefile, we specify the correct configuration to run it on. Therefore, note that running an attack may alter the current configuration. **Specifically, in order to run the none-ck attack, the fix will be disabled, so none of the proofs will work unless it is re-enabled.**

 Make commands and expected run time:
 * `make fs-attack-none-ck` (1s)
 * `make fs-attack-replay` (25s)
 * `make fs-attack-weak-state` (1 minute)

# DR-Proofs

## Lemmas

`libs/lemmas.cpp.pvl` defines some lemmas over the state, used for other proofs.

They are:
 * `lemmas_public_knowledge()` proved in `DR-proofs/lemmas/proof_lemma1.pv`
 * `lemmas_track_comp()` proved in `DR-proofs/lemmas/proof_lemma2.pv`
 * `lemmas_internal_state1()` proved in `DR-proofs/lemmas/proof_lemma3.pv`
 * `lemmas_session_state_invariants()` proved in `DR-proofs/lemmas/proof_lemma4.pv`
 * `lemmas_internal_state2()`, `lemmas_internal_state3()` proved in `DR-proofs/lemmas/proof_lemma5.pv`
 
Two additional correctness lemmas need to be proved `correctness_model_dictionnary()` and `correctness_model_dictionnary()` defined in `libs/format.pvl`. These are proved in `DR-proofs/lemmas/proof_lemma6.pv`.

Make commands and expected run time (under configuration dhs-spk):

 * `make dr-lemma1` (2s)
 * `make dr-lemma2` (1s)
 * `make dr-lemma3` (2s)
 * `make dr-lemma4` (3s)
 * `make dr-lemma5` (45s)
 * `make dr-lemma6` (3s)

## Sanity checks

We prove some sanity checks in `DR-proofs/sanity/*.pv`

Note that each sanity check checks sanity both with and without header encryption. Thus, if header encryption is not enabled, one of the checks should be expected to fail.

Make commands and expected run time (under configuration dhs-spk):

 * `make dr-sanity`  (6s)
 * `make dr-sanity2` (20s)
 * `make dr-sanity3` (40s)
 * `make dr-sanity4` (8 mins)
 * `make dr-sanity5` (6 mins)



## FS & PCS proofs

Forward secrecy is proved in `DR-proofs/proof_fs.pv`, Post compromise security in `DR-proofs/proof_pcs.pv`.

Note that both proofs rely on axioms proved in lemmas 1-6.

Make commands and expected run time (under configuration dhs-spk):

 * `make dr-fs` (8s)
 * `make dr-pcs` (50 mins)
 
## FULL-Proofs

The full proofs follow the same pattern, with `dr` in the make commands replaced with `full`. Notably, there is only one sanity check in this version `full-sanity`, due to the increased memory requirements.

Make commands and expected run time (under configuration basic):

 * `make full-lemma1` (12 minutes)
 * `make full-lemma2` (1 minute)
 * `make full-lemma3` (2 minutes)
 * `make full-lemma4` (12 minutes)
 * `make full-lemma5` (3 hours)
 * `make full-lemma6` (5 minutes)
 * `make full-sanity` (33 minutes)
 * `make full-fs`     (6 minutes)
 * `make full-pcs`    (7 hours)



