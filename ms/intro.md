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

# TODO

Problems with unicode in methods: trying this without success:
https://groups.google.com/forum/?fromgroups#!topic/pandoc-discuss/urzu6dQU_R4

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

# Methods

Five different transgenic strains of mice were chosen for this
study. By utilizing genetic markers for CB2, Cdh3, DRD4, Hoxd10 and
TRHR, individual RGCs of a specific subtype could be targeted (Table
1).

## Experimental procedure

All experimental procedures were approved by the Institutional Animal
Care and Use Committee (IACUC) at the University California, San
Diego. The following BAC transgenic mouse lines were used:
Calretinin-EGFP (CB2-GFP; [@Huberman2008-5a6]), Homeobox d10-EGFP
[Hoxd10-GFP; @Dhande2013-vp], Cadherin 3-EGFP [Cdh3-GFP;
@Osterhout2011-9b9], Dopamine receptor D4-EGFP [DRD4-GFP;
@Rivlin-Etzion2011-ji] and thyrotropin-releasing hormone
receptor-EGFP [TRHR-GFP; @Rivlin-Etzion2011-ji].

Intracellular cell filling and immunostaining of the retina were
performed using methods described in detail previously
[@Beier2013-mc; @Dhande2013-vp; @Cruz-Martin2014-sf; @Osterhout2014-ko]. Mice
were anesthetized with isoflurane and the eyes were removed.  Retinas
were dissected and kept in an oxygenated (95% O~2~/ 5% CO~2~) solution
of Ames’ medium (Sigma Cat # A1420), containing 23 mM NaHCO3.  Single
GFP+ RGCs were visualized under epifluorescence, and then targeted
under DIC with electrodes made with borosilicate glass (Sutter
instruments; 15-20 MΩ). Cells were filled with Alexa Fluor 555
hydrizide (Invitrogen Cat # A20501MP; 10 mM solution in 200 mM KCl),
with the application of hyperpolarizing current pulses ranging between
0.1-0.9 nA, for 1-5 minutes.

Retinas were then fixed for 1 hour in 4% paraformaldehyde (PFA), then washed with 1x phosphate buffered saline (PBS) and incubated for 1 hour at room temperature in a blocking solution consisting of 10% goat serum with 0.25 % Triton-X. The retinas were then incubated for 1 day at 4°C with the following primary antibodies diluted in blocking solution: rabbit anti-GFP (1:1000, Invitrogen Cat # A6455). Retinas were rinsed with PBS (3x, 30 minutes each), and incubated for 2 hours at room temperature with the following secondary antibodies:  Alexa Fluor 488 goat anti-rabbit (1:1000, Life Technologies Cat# A11034). Sections were rinsed with PBS (3x, 30 minutes each) and mounted onto glass slides and coverslipped with Prolong Gold containing DAPI (Invitrogen P36931).

RGCs were imaged with a laser scanning confocal microscope (Zeiss LSM
710 or 780), using a LD C-Apochromat 40X/1.1 water immersion objective
lens (Z-step = 0.48-0.5 Z-step µm; scanning resolution = 1024x1024
pixels, Kalman averaging = 2-4). Complete morphological
reconstructions were obtained manually using Neurolucida software
(10.42.1, MBF Bioscience) and exported to our custom-written Matlab
scripts for analysis.  All relevant data and code relating to this
project are available
[https://github.com/Hjorthmedh/RGCmorphology](https://github.com/Hjorthmedh/RGCmorphology).

## Analysis of RGC morphology

@Rodieck1983-nb proposed measuring multiple features to define a
feature space, within which different RGC types could be
identified. Our analysis calculated 15 morphological features to
quantify the characteristics of individual RGCs (Table 2). From these
features, we defined a feature vector, which specified a point in the
15 dimensional feature space. The individual features are:

### Dendritic Area and Soma Area

The dendritic area is the convex hull enclosing all of the dendrites
(Figure 3A), and the soma area is calculated in a similar way. All
areas are measured in the XY-plane.

### Fractal Dimension

Fractal dimension measures the neuron’s coverage of the retina at
different length scales. Here we used the box counting method
described in @Fernandez2001-ef. The neuron was projected onto the XY
plane and a grid was placed over it (Figure 3B). This grid was then
successively refined. The magnification is defined as the maximal
distance between grid lines / current distance between grid lines. At
each step, the number of grid boxes that contains a piece of dendrite
was counted. The logarithm of the number of non-empty grid squares was
plotted against the logarithm of the magnification. A line was fitted
to these points using the least squares method, and the resulting
slope is an estimate of the fractal dimension.

### Stratification Depth and Bistratification distance

Commonly, stratification depth is defined as the center of mass of the
dendritic tree relative to the two VAChT bands [@Kong2005; @Sumbul2014-vm]
that mark the locations of the starburst amacrine cells. Due to
unreliable labeling the locations of the two VAChT bands are unknown,
instead the depth is measured relative to the soma.

Bistratification distance is the distance between the upper and lower
parts of the dendritic tree (Figure 3C). Two Gaussians are fitted to a
histogram (along the z-axis) of the dendritic tree, and the (scaled)
bistratification distance is calculated by

$$ d_{BS}=(d_{A}-d_{B} )/ \max(\sigma_{A},\sigma_{B}) $$

where d~A,B~ are the centres of the Gaussians, and σ~A,B~ are the
standard deviations. This is calculated for both bistratified and
monostratified cells, but for bistratified neurons this distance will
be larger.

### Branch Asymmetry and Angle
For each branch point (Figure 3D), the branch asymmetry compares the
number of leaves nL that each of the branches has. It is defined as
the ratio $$ \max(n_L^i) / \sum_i n_L^i $$
The branch angle is calculated as the angle between the two branches
in 3D space.

### Length measures and Branch Points

The dendritic tree is divided into segments, split by the branch
points. From these measures such as mean segment length, mean terminal
segment length, total dendritic length and dendritic diameter are
derived.  Mean segment tortuosity is the ratio of the path length from
the soma to the dendritic end point divided by the Euclidean distance
between them. The dendritic density is the total dendritic length
divided by the total dendritic area, the density of branch points is
defined analogously.

### Correlation Matrix

To assess if any pairs of features were highly correlated or
anti-correlated, we first calculated the Pearson correlation for all
15*14/2 feature pairs. To determine the threshold we shuffled the
elements in each column in the 94x15 feature matrix, and then
recalculated the pairwise correlation. This shuffling was repeated
1000 times, and the max of the absolute correlation was saved each
time. The 99th percentile was used as the threshold for significant
correlation.


### Unsupervised clustering

To assess the structure of the RGCs in the feature space we performed
unsupervised clustering using the five feature set previously
selection using k-means clustering. The rational was that the features
chosen for the classifier would be those that were informative for
separating the RGC types, and we wanted to see if there was a natural
grouping in feature space.

### Selection of Classification Method

We evaluated four different types of classification methods: Decision
tree based
methods[Freund and Schapire,1997, Breiman 1996, 2001, Shapire and Singer, 1999, Seiffert et al, 2008, Warmuth, Liao, and Ratsch, 2006],
Support Vector Machines
[Hastie et al 2008; Christianini and Shawe-Taylor 2000]., Subspace
[Ho 1998] and Naïve Bayes Classifiers. [Manning et al 2008].

We used the results from Matlab’s built in sequential feature
selection function to decide which classifier to use.  We also
confirmed the results by repeating the comparison using the features
picked by the exhaustive search (see below) for three of the methods:
Naive Bayes, SVMs and Bagging.

### Selection of Classification Features

The features for the classifier were selected using an exhaustive
search of all combinations of the 15 features using Naïve Bayes. We
partitioned the 94 RGCs into five folds, and used four of them for
training and the remaining one for testing. This was repeated five
times, ones for each of the five folds, to perform a five-fold cross
validation. This procedure was then repeated 20 times using different
folds, for a total of 100 classification tests. We then plotted the
number of features against the performance, and picked a feature set
where adding additional features only improved the performance
marginally.

### Confusion matrix

The confusion matrix summarizes the predictions of a classifier. Each
row represents one of the five genetic types, and each column lists
the predicted types. Correctly classified RGCs are counted on the
leading diagonal. For each RGC, we created a test set containing all
RGCs except that cell, trained the classifier, and then predicted the
type of the RGC that was held back.

### Feature Space Plot

We created two different feature space plots, the first only plotted
the RGCs on two of the features. The second used principal component
analysis (computed in Matlab, with variance normalization) to
visualize the feature space, and plotted the RGCs on the two first
principal components. These correspond to the two directions with the
largest variation of the data set. **The classification of individual
cells was generated in the same way as for the confusion matrix, using
the leave one out method, and the results verified with
cross-validation.**


### Typical and atypical cells

To assess the confidence in the classification, we used the posterior
probability from the Naïve Bayes classifier. Following the methodology
established by @Khan2001-71f we plotted the most typical RGC of each
type, which was defined as the one with the highest posterior
probability. We also plotted the most atypical RGC of each type, which
was defined as the RGC with the highest posterior probability for
another type other than its genetic type.


## Acknowledgements

We thank Uygar Sümbül for sharing tracings of retinal ganglion cells,
and his code for classification of cell types. The authors were
supported by the Wellcome Trust (JJJH and SJE, grant number: 083205),
NIH (RNE-D and ADH). We thank  Ellese Cotterill for comments on the
manuscript.



# References

<!-- (setq reftex-cite-format '((?\C-m . "[@%l]"))
	       reftex-default-bibliography '("rgcmorph.bib"))
 -->
