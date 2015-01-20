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

# Results



We filled, reconstructed and analyzed a total of 94 RGCs from five
genetic mouse lines: CB2 (n=19), Cdh3 (n=11) , DRD4 (n=26), Hoxd10
(n=29) and TRHR (n=9) (Table 1). In these mouse lines GFP is expressed
in 1-2 specific types of RGCs.  This makes it possible to reliably and
selectively target the same types of RGCs in different animals. We
will refer to these five lines as “genetic types” and we assume for
the initial analysis that each of these uniquely define one RGC
type. **Comment on Hoxd10 as multiple types here, using as control**
Three example RGCs of each genetic type are shown in Figure 1. The
axons (red) and dendrites (black) were manually traced, and the
locations of the somas were marked. Each RGC collects information
about a small region in the visual field; the shape and distribution
of the dendritic tree differs depending on the function the RGC
performs. It is an open problem to identify the RGC type based on
morphological characteristics. Here we are interested in using
objective methods to assess this RGC patterning.

## Quantifying RGC morphology

Our aim was to use machine learning tools to predict RGC type by
morphology. To do this we need to translate the RGC morphologies into
a set of numbers quantifying that specific RGC. Fifteen morphological
features were calculated (Table 2). Together they define a feature
vector, which captured both large-scale characteristics of the neuron
such as stratification depth, area of the dendritic arbor and number
of branches, and also finer aspects such as the mean angle and the
tortuosity of the branches (Figure 2).

## Single features do not uniquely predict RGC type

We first investigated whether any one feature could predict the RGC
type. Previous studies [@Kong2005; @Sumbul2014-vm] showed
that stratification depth, relative to the two VAChT bands, is a good
predictor of RGC type, but it could not uniquely determine RGC
type. Our RGC z-stacks included VAChT staining, however, due to the
way the data was acquired we were unable to reliably distinguish
between the two VAChT bands. Instead we calculated the stratification
depth relative to the soma (**is that what the 2009 Puschin paper did
too?; Volgyi et al. 2009 also I believe**) and found that there was a
considerable overlap between the different RGC types. There were also
overlaps between the RGC types based on other features. For example,
Table 3 shows that Hoxd10 generally had a larger dendritic area than
other RGC types but that the standard deviation is so large that the
range spans the whole spectrum of values of other RGC types. To assess
the predictive powers of the individual features, we trained a Naïve
Bayes classifier for each individual feature. The most discriminative
feature was mean terminal segment length, which alone correctly
predicted 64.7 ± 1.7 % of the cases.

## Selection of multiple feature vectors

Rodrieck and Brening (1983) described the need to base RGC classification on objectively measurable features, which if used to form axes, would define a feature space. If we look at the cartoon in Figure 3A, we can see that dendritic area on the y-axis can separate the red and green clusters quite well, but it is a poor predictor when separating the green and blue groups. By introducing soma area as an additional feature we can now see that the different types separate in feature space. What a classifier does is look at the position of an unknown RGC **(black dot, marked with ?)**, and see where it is located relative to the previously identified RGCs in the abstract feature space. In this case the RGC is within the green region, so it is very likely that it is of that type. If points belonging to the same RGC type cluster together in space and each cluster is distinct (Figure 3A), then it is possible to correctly predict all RGC types. If instead the classes completely overlap in feature space (Figure 3B) then classification is next to impossible. In the intermediate case there is some overlap between individual RGC types in feature space (Figure 3C), then classification is still possible but there will be some miss-classifications.

Using the fifteen features listed, we can translate each neuron into a fifteen-dimensional feature vector (Figure 2F) which is then a point in feature space. A priori it is not certain that all fifteen features should be used in classification.  With each additional feature, the dimensionality of the feature space increases, causing the data points to be more spread out. Adding features with little or no useful information increases the distance between all cells in feature space. As more irrelevant features are added, the difference between within-class distance and between-class distance decreases, making the cells harder to classify. Another potential complication is that some of the features capture similar properties, leading to correlations between the features. The pairwise correlations between all features are reported in Table 4.  For example, mean segment length and mean terminal segment length are highly correlated with each other, but strongly anti-correlated with density of branch points. To assess which subset of features would give the best classification we did an exhaustive search using all possible combinations of the fifteen features. We choose the Naïve Bayes classifier, as initial tests showed that it was fast and had reasonably good classification performance. A bootstrap aggregation classifier and Support Vector Machine performed equally well. The performance of each set of features was assessed using five-fold cross-validation. Because of variations in ranking between individual runs, we repeated this procedure 20 times to get robust results. The results from this exploration are shown in Table 6, which shows the best subset for each given number of features. Classification performance initially increases with the number of features, however after eight features, additional features were detrimental to performance. We found that, in our dataset, stratification depth (relative to soma position) and bistratification distance were poor predictors. Here, we opted for a five feature classifier, as adding a sixth feature only marginally improved performance. The features used were Dendritic Area, Density of Branch Points, Fractal Dimension, Mean Terminal Segment Length and Soma Area, which gave an average classification rate of 83%.   By contrast, the baseline for classifier performance when guessing randomly is about 24%. 

## Assessing the classification

To get a sense of what the different RGC types looked like we selected
a typical and an atypical RGC from each genetic type (Figure 4), based
upon the classification of these RGCs. Each row in the figure shows
two cells: the left being the most typical in the class, and in the
right a cell that was incorrectly classified. We see, for example,
that the two Cdh3 RGCs shown look quite different. The more typical
RGC (left) is more compact while the atypical one (right) occupies a
larger area with diffuse dendrites similar to the Hoxd10 RGC.

As classification was good, but not error-free, we investigated which
cells were misclassified using a confusion matrix. This matrix
displays the different RGC types as rows, and the predicted classes as
columns. Perfect classification would result in non-zero elements
along only the leading diagonal. The confusion matrix (Table 7) shows
that Hoxd10 and TRHR were the two RGC types that were most difficult
to predict, with 21% (6/29) and 44% (4/9) misclassification. We can
compare this with the confusion matrix from the unsupervised learning
(Table 5, using the same five features). Here Hoxd10 spans all the
five clusters. TRHR is restricted to one cluster, but share it with
four other RGC types.


To better understand why Hoxd10 and TRHR have worse performance we
need to look at the feature space. For feature spaces of higher
dimensions this might be difficult. We can pick two or possibly three
of the features and plot the RGCs in a subspace of the full feature
space. Figure 5A shows the RGCs plotted on the Soma Area and Density
of Branch Points. Here we can see that for these features, TRHR has a
large overlap with DRD4 and to some extent Cdh3. Likewise, Hoxd10 has
large overlaps with other genetic types.

## Hoxd10 contain multiple subtypes

** Update Hoxd10 is multiple types **
Why is Hoxd10 performing so poorly compared to other genetic types? One explanation might be that multiple RGC types are grouped under the Hoxd10 type. By projecting the feature vectors from 5D down to the first two principal components we can observe the different RGCs in relation to each other. Principal component analysis (PCA) finds the directions in feature space along which the data has the largest variation. Figure 5B shows that the majority of the Hoxd10 cells are grouped together into a cluster that partially overlaps with DRD4. There are also a few outliers that overlap with CB2 and TRHR. 

If two or more morphologically distinct RGC types are included in one
genetic type, an algorithm that looks for spatial clustering in
feature space might separate the genetic type into two or more
groups. Unsupervised clustering methods cluster RGCs based on their
relative location in feature space. A popular method for unsupervised
clustering is k-means, which is an iterative method to find k clusters
in a data set. To find out how many clusters to split the Hoxd10 cells
into we tried a range from k=2 to 6. When only clustering the Hoxd10
data, we found that the silhouette value (0.62) was maximal for
k=3. This corresponds to two major clusters, and the third cluster
containing one outlier (See Figure X1). The RGCs in the different
Hoxd10 clusters are shown in Figure X2, X3 and X4. ** move to start? This result is in
line with the finding by [Dhande et al (2013)], that Hoxd10 labels
three types of On-direction-selective and one type of On-Off
direction-selective/anterior tuned RGC. Hoxd10 is therefore not a
unique RGC type. **

Confidence in classification

When using a Naïve Bayes classifier, we get a measure of how certain
the classifier is of the results. If there is only a small overlap
between the clusters, we expect the classifier to be fairly certain
about most of its predictions. When the classifier is wrong, we expect
the confidence in the results to be lower [@Khan2001-71f]. Figure 5C
shows the confidence of the classification for different RGCs, with a
higher score signifying a more confident classification. Triangles
mark the cells that were incorrectly classified. There are some errors
hovering around the 0.5 mark, but perhaps more concerning are the
incorrectly RGCs that the classifier was quite certain about. Each
class had one example of a RGC with high posterior probability for the
wrong type, except for Hoxd10, which had three.  One reason for this
could be that there is something abnormal about these cells, causing
them to appear in the wrong place in feature space. However, these
cells were visually inspected but nothing unusual was seen.

## Re-analysis of the Sümbül  et al (2014) data set

A recent study by Sümbül et al (2014) achieved near perfect
classification for RGC types based on dendritic arborisation depth in
the inner plexiform layer. To verify the fidelity of our data we also
applied our method to the Sümbül et al. dataset. This dataset has been
pre-processed using the VAChT band information to flatten the
dendritic trees, furthermore the soma size was missing from the data
set. We have therefore repeated the feature selection process for this
data. Table 9 shows the best feature sets found.  There are some
notable differences with Table 6,that shows the same selection applied
to our data. Bistratification distance and stratification depth were
more often picked as classifiers of the Sümbül data, while dendritic
area and density of branch points were less informative.  The former
is understandable, as the pre-processing was done to enhance these
two, the latter two could perhaps be a consequence of the warping of
the dendritic tree. The classification performance (column 2 of Table
9) is comparable with what we saw for our data, confirming that the
data in this study, VAChT bands aside, is of a similar value to RGC
classification as the Sümbül approach, and that errors in classifier
are similar in both datasets. It is important to note though that the
Sümbül dataset contains seven RGC types, and ours has five RGC
types. Two RGC subtypes are in both datasets. The difference in the
quality of the VAChT band data is probably due to differences in
experimental protocol, as the Sümbül experiments have been optimized
to retain the VAChT band information, as well as the non-linear
pre-processing that un-warps the arbors based on the VAChT-band.

## Summary

The dendritic stratification relative to the VAChT-bands was shown
previously to be a good predictor of RGC type. We used machine
learning techniques to see how well we could predict RGC type without
the VAChT-band information. We found that it was possible to get about
84% correct classification using five morphological features derived
from the dendritic tree and soma.


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
