# Engineering _in silico_ epigenetic memory in mammalian cells

Implementation of a synthetic system to realize placement, detection and reset of orthogonal epigenetic marks in mammalian cells in MATLAB (& SimBiology). A proof-of-principle finite-state machine is also provided.

**Note:** This is a team-project during the course "Introduction to Biological Computers" in ETH Zurich.

Specifically, we describe the molecular architecture and provide dynamical models of a dCas9-based epigenetic _Write_ module capable of writing orthogonal epigenetic tags on specified loci and in a targetable manner in mammalian cells, a _Read_ module, as well as a novel _Reset_ module.

To construct an orthogonal system, the DNA epigenetic marker of choice that we selected is N6-methyladenine (m6A), which is extremely [rare in eukaryotes](https://link.springer.com/article/10.1007/s11008-005-0064-2) and an _E.coli_ DNA adenine methyltransferase (Dam) was employed, which catalyzes the [methylation of adenines](https://www.sciencedirect.com/science/article/pii/S0092867418314612) in GATC sites.

## Modules

* **Write** module similar to [Park et al.](https://www.sciencedirect.com/science/article/pii/S0092867418314612), however the Dam methylase was fused to dCas9 instead of a ZF protein
* **Read** module  based on a restriction enzyme (DpnI) specific to the sequence GATC, coupled to an activator (VP64) to induce the production of a reporter fluorescent protein (GFP)
* **Reset** module including an [ALKBH1 demethylase](https://www.sciencedirect.com/science/article/pii/S109727651830460X) and with analogous design to the Write module. The targeting function is not performed by a dCas9-gRNA complex but with a ZF protein, in order to achieve independent targeting by the two modules.

## Epigenetic finite-state machine

The example finite-state machine is shown in the following figure:

![Finite-state machine implemented by the synthetic epigenetic system](https://github.com/Ariwor/in-silico-epigenetic-memory/blob/master/Example_state_machine.png)

The automaton consists of:

* 2 states (S0, S1), defined as the unmethylated (S0) and methylated (S1) version of the target site
* 2 inputs (I1, I2), encoded as ”pulses” of two gRNAs (gRNA 1, gRNA 2)

The model is constructed by incorporating the _Write-Read-Reset_ modules together with a plasmid (genome integrated) that inducibly produces the second input gRNA (gRNA 2). The production of the Reset module is gRNA 2-dependent, as gRNA 2 drives a dCas9 protein fused to a VP64 transcriptional activation domain to [activate](https://www.nature.com/articles/nmeth.2598/) expression of the _Reset_ module. To couple the expression of this dCas9-VP64-gRNA activation complex to the current state of the finite automaton, namely unmethylated (S0) or methylated (S1), the synRead protein (of the _Read_ module) leads to the VP64-dependent activation of the fusion protein dCas9-VP64.

## General assumptions for all models

The choice was made to represent all the concentrations in molarity, transforming units of molecules/cells by assuming a median mammalian cell volume of 2 * 10<sup>-12</sup> L. The plasmids were considered to be integrated inside the genome (two copies/cell) and thus not diluted or consumed by reaction. We assumed that recognition sites for the binding of the fusion proteins ZF-ALKBH1 and dCas9-Dam are the same. The engineered loci contained 60 GATC sites for potential methylation, which is acquired from [Park et al.](https://www.sciencedirect.com/science/article/pii/S0092867418314612) The models have versions with and without dilution, with not genome-integrated species being diluted during every cell division, with a dilution rate taken from [Park et al.](https://www.sciencedirect.com/science/article/pii/S0092867418314612), which corresponds to a doubling time of 20 h.
