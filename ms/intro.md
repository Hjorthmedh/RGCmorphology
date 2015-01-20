---
title: Classification of retinal ganglion cell types according to
 dendritic branching and somal characteristics.
author:
- name: J J Johannes Hjorth
  affiliation: University of Cambridge
- name: Rana N El-Danaf
  affiliation: UCSD
- name: Andrew D Huberman
  affiliation: UCSD
- name: Stephen J Eglen
  affiliation: University of Cambridge
  email: S.J.Eglen@damtp.cam.ac.uk

date: 2015-01-19
bibliography: <!-- \bibliography{/Users/kjhealy/Documents/bibs/socbib-pandoc.bib} This is a hack for Emacs users so that RefTeX knows where your bibfile is, and you can use RefTeX citation completion in your .md files. -->
...

Contributions

Conceived and designed the project: ADH, SJE.

Collected experimental data: RNE-D. 

Analysed and interpreted data: JJJH, RNE-D, ADH, SJE.

Wrote the paper: JJJH, RNE-D, ADH, SJE.

\clearpage

# Abstract

There are estimated to be around 20 different types of retinal
ganglion cells in the mouse retina. Newly developed genetic markers
allow for the identification and targeting of specific retinal
ganglion cell (RGC) types, which have different functional and
morphological features. The purpose of this study was to develop tools
to identify RGCs types based on the most common available sources of
information about their morphology: soma size and dendritic branching
pattern. We used five different transgenic mouse lines, in each of
which 1-2 RGCs types selectively express green fluorescent protein
(GFP). Cell tracings of 94 RGCs were acquired from retinas of CB2-GFP
(transient Off alpha RGCs), Cdh3-GFP (M2 ipRGCs; “diving” RGCs,
DRD4-GFP (pOn-Off DSGCs), Hoxd10-GFP (On-DSGCs and aOn-Off DSGCs)and
TRHR-GFP (pOn-Off DSGCs) transgenic mice. Fifteen morphological
features of GFP expressing cells were calculated, and we used machine
learning techniques to classify the cells. We found that dendritic
area, density of branch points, fractal dimension box counting, mean
terminal segment length and soma area were enough to create a
classifier that could correctly identify 83 % of the RGC types we
examined.  This approach is therefore useful for experiments that do
not have access to the genetically labeled mouse lines and or detailed
information about stratification of RGC types.

\clearpage

# Introduction

How many types of mammalian retinal ganglion cell (RGC) are there? The
answer to this question depends partly on how you define a neuronal type
[@Cook1998], but it is commonly assumed that RGC types have distinct
morphologies and physiologies.  The pioneering work of @Boycott1974-aa
 suggested that there were at least three morphological
classes (alpha, beta and gamma) of RGC in cat, and these three types
mapped onto previously-defined physiological classes (X, Y and W)
[@Cleland1971-bo].  For example, alpha cells were defined as having
larger dendritic fields and somata compared to neighbouring beta cells.
Since these early studies, subsequent work has primarily focused on
finer divisions of the gamma class which was thought to be a mixed
grouping (REF).  Furthermore, it is unclear whether individual
morphological features alone are unique predictors of cell type, as
demonstrated by the large overlap in RGC somata area (their Figure 6)
among the alpha/beta/gamme cat RGCs, but that multiple features should
be considered simultaneously when classifying neurons.  @Rodieck1983-nb
formalised this notion, proposing to use multiple features
to define a multidimensional "feature space" in which to define RGC
types.  If cells form distinct types, then the expectation is that cells
of the same type should cluster together in one part of this feature
space, and that different cell types occupy different parts of feature
space.

Recent advances in imaging and genetics have led to a dramatic
increase in data available, especially from mice but also other
species, to test whether cells of distinct types form clusters in
multidimensional space.  Estimates for mouse retina vary from 12
[@Kong2005] to 22 [@Volgyi2009] based either on manual classification
of cell types or unsupervised machine learning methods.  These
unsupervised approaches use statistical methods to determine the
optimal number of clusters in the data (e.g. using silhoutte widths
technique; REF).  However, these approachees have no ground-truth data
to compare with the predicted number of cell types.

In this study, we analyse the morphology of RGCs from several mutant
mice lines where typically one or a few types of RGC is labelled with
GFP.  We use supervised machine learning techniques to predict whether
the anatomical features can predict the "genetic type" of the mouse,
i.e. the mouse line from where the cell was labelled.  This provides
us with ground-truth data which we can use to evaluate our methods
againts.  From each RGC we measured fifteen features, from which we
found five that were highly predictive of cell type.  We compare our
findings with a recent study [@Sumbul2014-vm] where near-perfect
classification was achieved when information about stratification
depth is included.  We suggest that our anatomical measures can
provide a reliable basis for classification in the absence of
stratification depth information, and thus that the @Rodieck1983-nb
method of classification is robust when applied to mouse RGCs.

\clearpage

## Acknowledgements

We thank Uygar Sümbül for sharing tracings of retinal ganglion cells,
and his code for classification of cell types. The authors were
supported by the Wellcome Trust (JJJH and SJE, grant number: 083205),
NIH (RNE-D and ADH). We thank  Ellese Cotterill for comments on the
manuscript.



# References
