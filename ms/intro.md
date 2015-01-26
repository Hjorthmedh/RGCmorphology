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
nocite: |
  @Huberman2009-xf, @Osterhout2011-9b9, @Huberman2008-5a6,
  @Dhande2013-vp, @Rivlin-Etzion2011-ji
date: 2015-01-26 <!-- TODO update by hand. -->
...

<!-- nocite above to ensure we cite all the refs from Table 1. -->
---

Contributions

Conceived and designed the project: ADH, SJE.

Collected experimental data: RNE-D. 

Analysed and interpreted data: JJJH, RNE-D, ADH, SJE.

Wrote the paper: JJJH, RNE-D, ADH, SJE.

\clearpage

# TODO

J Neurophysiol special issue on cell types as initial target.  J Comp
Neurol second choice.

Check Sumbul for what exactly we mean by **near-perfect** classification?

\clearpage

# Abstract

There are estimated to be around 20 different types of retinal
ganglion cells in the mouse retina. Recently-developed genetic markers
allow for the identification and targeting of specific retinal
ganglion cell (RGC) types, which have different functional and
morphological features. The purpose of this study was to develop
computational tools to identify RGCs types based on the most common
available sources of information about their morphology: soma size and
dendritic branching pattern. We used five different transgenic mouse
lines, in each of which 1--3 RGCs types selectively express green
fluorescent protein (GFP). Cell tracings of 94 RGCs were acquired from
retinas of CB2-GFP (transient Off alpha RGCs), Cdh3-GFP (M2 ipRGCs;
“diving” RGCs, DRD4-GFP (pOn-Off DSGCs), Hoxd10-GFP (On-DSGCs and
aOn-Off DSGCs)and TRHR-GFP (pOn-Off DSGCs) transgenic mice. Fifteen
morphological features of GFP expressing cells were calculated, and we
used machine learning techniques to classify the cells. We found that
dendritic area, density of branch points, fractal dimension, mean
terminal segment length and soma area were enough to create a
classifier that could correctly identify 83 % of the RGC types we
examined.  We therefore believe that standard morphological features
can serve as reliable classifiers of mouse RGCs.  As these features
are not specific to retinal neurons, we believe our classifier can
classify a wide range of neurononal morphologies.



\clearpage

# Introduction

How many types of mammalian retinal ganglion cell (RGC) are there? The
answer to this question depends partly on how you define a neuronal
type [@Cook1998], but it is commonly assumed that RGC types have
distinct morphologies and physiologies.  The pioneering work of
@Boycott1974-aa suggested that there were at least three morphological
sub-classes (alpha, beta and gamma) of RGC in cat, and these three
types mapped onto previously-defined physiological classes (X, Y and
W) [@Cleland1971-bo].  For example, alpha cells were defined as having
larger dendritic fields and somata compared to neighbouring beta
cells.  Since these early studies, subsequent work has primarily
focused on finer divisions of the gamma class which was thought to be
a mixed grouping (REF).  Furthermore, it is unclear whether individual
morphological features alone are unique predictors of cell type, as
demonstrated by the large overlap in RGC somata area
[Figure 6 of @Boycott1974-aa] among the alpha/beta/gamma cat RGCs, but
that multiple features should be considered simultaneously when
classifying neurons.  @Rodieck1983-nb formalised this notion,
proposing to use multiple features to define a multidimensional
"feature space" in which to define RGC types.  If cells form distinct
types, then the expectation is that cells of the same type should
cluster together in one part of this feature space, and that different
cell types occupy different parts of feature space.

Recent advances in imaging and genetics have led to a dramatic
increase in data available, especially from mice [@Badea2004] but also
other species, to test whether distinct types of RGCs form clusters in
multidimensional space.  Estimates for mouse RGCs vary from 12
[@Kong2005] to 22 [@Volgyi2009] types based either on manual
classification of cell types or unsupervised machine learning methods.
These techniques have also been applied to grouping of RGCs in other
species, including cat [@Jelinek2004-gp], newt [@Pushchin2009-ef5] and
lamprey [@Fletcher2014-mj].  These unsupervised approaches use
statistical methods to determine the optimal number of clusters in the
data [e.g. using the silhoutte widths technique, @Rousseeuw1987-xe].
However, these approaches have no ground-truth data to compare with
the predicted number of cell types.

In this study, we analyse the morphology of RGCs from several mutant
mice lines where typically one or a few types of RGC is labelled with
GFP.  We use supervised machine learning techniques to predict whether
the anatomical features can predict the "genetic type" of the mouse,
i.e. the mouse line from where the cell was labelled.  This provides
us with ground-truth data which we can use to evaluate our methods
againts.  From each RGC we measured fifteen features, from which we
found five that were highly predictive of cell type.  We compare our
findings with a recent study [@Sumbul2014-vm] where **near-perfect**
classification was achieved when information about stratification
depth is included.  We suggest that our anatomical measures can
provide a reliable basis for classification in the absence of
stratification depth information, and thus that the @Rodieck1983-nb
method of classification is robust when applied to mouse RGCs.

\clearpage

# Methods

Five different transgenic strains of mice were chosen for this
study. By utilizing genetic markers for CB2, Cdh3, DRD4, Hoxd10 and
TRHR, individual RGCs of specific types could be targeted (Table 1).
We refer to to the genetic markers as the "genetic type" of the RGCs.
We also follow the terminology proposed by @Cook1998 for
distinguishing between the notion of a "type" and "class" of a neuron.
In this context, when we refer to a class, it is in the predicted
group from the clustering/classification methods.

## Experimental procedure

All experimental procedures were approved by the Institutional Animal
Care and Use Committee (IACUC) at the University California, San
Diego. Table 1 lists the  BAC transgenic mouse lines used in this
study and the number of RGCs from each animal.
Intracellular cell filling and immunostaining of the retina were
performed using methods described in detail previously
[@Beier2013-mc; @Dhande2013-vp; @Cruz-Martin2014-sf; @Osterhout2014-ko]. Mice
were anesthetized with isoflurane and the eyes were removed.  Retinas
were dissected and kept in an oxygenated (95% O~2~/ 5% CO~2~) solution
of Ames’ medium (Sigma Cat# A1420), containing 23 mM NaHCO3.  Single
GFP+ RGCs were visualized under epifluorescence, and then targeted
under DIC with electrodes made with borosilicate glass (Sutter
instruments; 15-20 MΩ). Cells were filled with Alexa Fluor 555
hydrizide (Invitrogen Cat# A20501MP; 10 mM solution in 200 mM KCl),
with the application of hyperpolarizing current pulses ranging between
0.1-0.9 nA, for 1--5 minutes.




Retinas were then fixed for 1 hour in 4% paraformaldehyde (PFA), then washed with 1x phosphate buffered saline (PBS) and incubated for 1 hour at room temperature in a blocking solution consisting of 10% goat serum with 0.25 % Triton-X. The retinas were then incubated for 1 day at 4°C with the following primary antibodies diluted in blocking solution: rabbit anti-GFP (1:1000, Invitrogen Cat# A6455). Retinas were rinsed with PBS (3x, 30 minutes each), and incubated for 2 hours at room temperature with the following secondary antibodies:  Alexa Fluor 488 goat anti-rabbit (1:1000, Life Technologies Cat# A11034). Sections were rinsed with PBS (3x, 30 minutes each) and mounted onto glass slides and coverslipped with Prolong Gold containing DAPI (Invitrogen P36931).

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
[@Fernandez2001-ef]. The neuron was projected onto the XY plane and a
grid was placed over it (Figure 3B). This grid was then successively
refined. The magnification is defined as the maximal distance between
grid lines / current distance between grid lines. At each step, the
number of grid boxes that contains a piece of dendrite was
counted. The logarithm of the number of non-empty grid squares was
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
number of leaves n~L~ that each branch has. It is defined as
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
trees [@Kotsiantis2013-jc], Support Vector Machines [@Hastie2009-ws],
Random Subspace [@Ho1998-cp] and Naïve Bayes Classifiers [@Manning2008-dq].


We used the results from Matlab’s built in sequential feature
selection function to decide which classifier to use.  We also
confirmed the results by repeating the comparison using the features
picked by the exhaustive search (see below) for three of the methods:
Naïve Bayes, SVMs and Bagging.

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

### Classification and the confusion matrix

The confusion matrix summarizes the predictions of a classifier. Each
row represents one of the five genetic types, and each column lists
the predicted types. Correctly classified RGCs are counted on the
leading diagonal. For each RGC, we created a test set containing all
RGCs except that cell, trained the classifier, and then predicted the
type of the RGC that was held back. The classification of individual
cells was generated in the same way as for the confusion matrix, using
the leave one out method, and the results verified with
cross-validation.

### Feature Space Plot

We created two different feature space plots, the first only plotted
the RGCs on two of the features. The second used principal component
analysis (computed in Matlab, with variance normalization) to
visualize the feature space, and plotted the RGCs on the two first
principal components. These correspond to the two directions with the
largest variation of the data set. 


### Determining typical and atypical cells

To assess the confidence in the classification, we used the posterior
probability from the Naïve Bayes classifier.  To classify each neuron,
we withheld it from the training set, using the leave-one-out
technique. Following the methodology established by @Khan2001-71f we
plotted the most typical RGC of each type, which was defined as the
one with the highest posterior probability. We also plotted the most
atypical RGC of each type, which was defined as the RGC with the
highest posterior probability for another type other than its genetic
type.

# Results



We filled, reconstructed and analyzed 94 RGCs from five genetic mouse
lines: CB2, Cdh3, DRD4, Hoxd10 and TRHR (Table 1). In these mouse
lines GFP is usually expressed in just one RGC type.  This makes it
possible to reliably and selectively target the same types of RGCs in
different animals. We will refer to these five lines as “genetic
types” and we assume for the initial analysis that each of these
uniquely define one RGC type.  Our prior findings suggest however that
Hoxd10 may label 3--4 distinct RGC types.  In this work we initially
assume that Hoxd10 labels one type of RGCs, and then assess later in
detail whether it is likely to label multiple types.  Three example
RGCs of each genetic type are shown in Figure 1. The axons (red) and
dendrites (black) were manually traced, and the locations of the somas
were marked. Each RGC collects information about a small region in the
visual field; the shape and distribution of the dendritic tree differs
depending on the function the RGC performs. It is an open problem to
identify the RGC type based on morphological characteristics. Here we
are interested in using objective methods to assess this RGC
patterning.

## Quantifying RGC morphology

Our aim was to use machine learning tools to predict RGC type by
morphology. To do this, we translated each RGC morphology into a set
of numbers quantifying that RGC. Fifteen morphological features were
calculated (Table 2). Together they define a feature vector, which
captured both large-scale characteristics of the neuron such as
stratification depth, area of the dendritic arbor and number of
branches, and also finer aspects such as the mean angle and 
tortuosity of branches (Figure\ 2).

## Single features do not uniquely predict RGC type

We first investigated whether any one feature could predict the RGC
type. Previous studies
[@Kong2005; @Pushchin2009-ef5; @Volgyi2009; @Sumbul2014-vm]
highlighted that stratification depth, relative to the two VAChT bands
surrounding the inner plexiform layer, is a good predictor of RGC
type, but it could not uniquely determine RGC type. Our RGC z-stacks
included VAChT staining, however, due to the way the data was acquired
we were unable to reliably distinguish between the two VAChT
bands. Instead we calculated the stratification depth relative to the
soma centre.  However, we found that there was considerable overlap
between the different RGC types according to stratification depth
(Table 3).  There were also significant overlaps between the RGC types
based on other features. For example, Table 3 shows that Hoxd10
generally had a larger dendritic area than other RGC types but that
the standard deviation is so large that the range spans the whole
spectrum of values of other RGC types. To assess the predictive powers
of the individual features, we trained a Naïve Bayes classifier for
each individual feature.  The single-most discriminative feature for
our data was mean terminal segment length, which correctly
predicted 64.7 ± 1.7\ % of the cases.  We therefore confirm that
our individual features are not reliable classifiers of neuronal type.

## Selection of multiple feature vectors

Rodrieck and Brening (1983) described the need to base neuronal
classification on objectively measurable features, which if used to
form axes, would define a multidimensional feature space.  This is
demonstrated with three sets of synthetic data in Figure 3.  In Figure
3A, dendritic area on the y-axis can separate the red and green
clusters quite well, but does not separate the green and blue
groups. By introducing soma area as an additional feature, the
different types separate in feature space. With poor signals
(e.g. Figure 3B), the different types are intermingled; *a priori* we
might expect real data to look closer to the synthetic case shown in
Figure 3C, where there is both signal to separate the classes, but
also noise which blurs the boundaries between classes.

The task of a classification algorithm is to take this training data
to learn the boundaries between the different types of neuron.  After
training, the classifier is asked to predict the type of a neuron not
seen in training (e.g. black square in Figure 3C). In this
case the RGC is within the green region, so it is very likely that it
is of that type. If points belonging to the same RGC type cluster
together in space and each cluster is distinct (Figure 3A), then it is
possible to correctly predict all RGC types. If instead the classes
completely overlap in feature space (Figure 3B) then classification is
next to impossible. In the intermediate case there is some overlap
between individual RGC types in feature space (Figure 3C), then
classification is still possible but there will be some
miss-classifications.

Using this approach, we translated each neuron into a
fifteen-dimensional feature vector (Figure 2F).  *A priori* it is not
certain that all fifteen features should be used in classification.
With each additional feature, the dimensionality of the feature space
increases, causing the data points to be more spread out. Adding
features with little or no useful information increases the distance
between all cells in feature space. As more irrelevant features are
added, the difference between within-class distance and between-class
distance decreases, making the cells harder to classify. Another
potential complication is that some features capture similar
properties, leading to correlations between the features. The pairwise
correlations between all features are reported in Table 4.  For
example, mean segment length and mean terminal segment length are
highly correlated with each other, but strongly anti-correlated with
density of branch points


To assess which subset of features would give the best classification,
rather than select the features by trial and error, we did an
exhaustive search using all possible combinations of the fifteen
features. We choose the Naïve Bayes classifier, as initial tests
showed that it was fast and had reasonably good classification
performance. A bootstrap aggregation classifier and support vector
machine performed equally well. The performance of each set of
features was assessed using five-fold cross-validation. Because of
variations in ranking between individual runs, we repeated this
procedure 20 times to get robust results. The results from this
exploration are shown in Table 5, which shows the classification
performance and the feature subset for each given number of
features. Classification performance initially increases with the
number of features, however after eight features, additional features
inhibited performance.  In our dataset, stratification depth (relative
to soma position) and bistratification distance were poor predictors.
On the basis of these results, we selected a five-feature classifier,
as adding a sixth feature only marginally improved performance. The
features used were Dendritic Area, Density of Branch Points, Fractal
Dimension, Mean Terminal Segment Length and Soma Area, which gave an
average classification rate of 83%.  By contrast, performance without
training would be about 24%.

## Assessing the classification

To get a sense of what the different RGC types looked like we selected
a typical and an atypical RGC from each genetic type (Figure 4), based
upon the classification of these RGCs. Each row shows two neurons: the
left being the most typical in the class, and in the right a neuron that
was incorrectly classified. We see, for example, that the two Cdh3
RGCs shown look quite different. The more typical RGC (left) is more
compact while the atypical one (right) occupies a larger area with
diffuse dendrites similar to the Hoxd10 RGC.

As classification was good, but not error-free, we investigated
whether particular cell types were misclassified using a confusion
matrix. This matrix displays the different RGC types as rows, and the
predicted classes as columns. Perfect classification would result in
non-zero elements along only the leading diagonal. The confusion
matrix (Table 6) shows that Hoxd10 and TRHR were the two RGC types
that were most difficult to predict, with 21% (6/29) and 44% (4/9)
misclassification. We can compare this with the confusion matrix from
clustering using the k-means algorithm (Table 7, using the same five
features).  This clustering result shows us that each RGC type does
not neatly fall into its own cluster.  Only the TRHR type is
restricted to one cluster (cluster 4), but that cluster is shared with
three other RGC types.  At the other extreme, neurons from the Hoxd10
type are placed into all five clusters, although the primary split is
into two clusters (cluster 1 and 3).  Therefore, at least with our
data, unsupervised discovery of cell types correlates poorly with the
known genetic type.

To better understand why unsupervised clustering is not able to
separate the cell types, we need to examine the feature space.  We can
do this by generating scatterplots between each pair of featurs
e.g. one shown in Figure 5A, plotting soma area against density of
branch points.  We can observe from this that TRHR has a large overlap
with DRD4 and to some extent Cdh3. Likewise, Hoxd10 has large overlaps
with other genetic types.  Rather than repeat this procedure for each
pair of features (there are 10 scatterplots for a five dimensional
feature), we used Principal component analysis to reduce the
five-dimensional vectors to two dimensions. Figure 5B shows that the
majority of the Hoxd10 cells are grouped together into a cluster that
partially overlaps with DRD4. There are also a few outliers that
overlap with CB2 and TRHR.  This two-dimensional projection confirms
our *a priori* belief that there is likely to be a morphological
signal that can separate RGCs types, but that the boundaries overlap,
as outlined for synthetic data in Figure 3C.


### Confidence in classification

To assess the nature of the boundaries between cell types, we returned
to the classifer to assess its performance.  The Naïve Bayes
classifier calculates a confidence measure when classifying each
RGC. If there is only a small overlap between clusters, we expect the
classifier to be certain about most of its predictions. When the
clusters are harder to separate, we expect the classifier's confidence
in the predictions to be lower [@Khan2001-71f]. Figure 5C shows the
confidence of the classification for different RGCs, with a higher
score signifying a more confident classification. Triangles mark the
cells that were incorrectly classified. There are some misclassified
cells with confidences around 0.5, but perhaps more concerning are
misclassified RGCs with higher (> 0.8) confidence.  Each type had one
example of a RGC with high posterior probability for the wrong type,
except for Hoxd10, which had three.  One reason for this could be that
there is something abnormal about these cells, causing them to appear
in the wrong place in feature space. However, these cells were
visually inspected but nothing unusual was seen.


## Hoxd10 contain multiple subtypes

Out of the five RGC types, the Hoxd10 seems to perform poorest in both
classification and clustering results.  As noted at the start of the
Results, our recent work [@Dhande2013-vp] suggested that Hoxd10 labels
multiple RGC types, rather than just one type.  This mixing of
multiple types might account for why cells in the Hoxd10 class are
being misclassified at a relatively high rate.

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
containing one outlier (Figure 6). Example RGCs in the three 
Hoxd10 clusters are shown in Figure 6 and reflect the variability in
different types.  These statistical results therefore confirm our
ealier suggestion that Hoxd10 line labels at least three distinct
RGC types.


## Re-analysis of the Sümbül  et al (2014) data set

A recent study by Sümbül et al (2014) achieved **near-perfect**
classification for RGC types labelled by seven distinct genetic
markers.  One reason for their high performance was that their
classifier received a high-dimensional representation of the density
of the entire arbor, with a fine resolution in the depth dimension.
Accurate generation of dendritic depth information required reliable
information about the extent of the inner plexiform layer, gained
through reliable reconstruction of the two two VAChT bands.  This is
turn relied on complex image-warping of the image stacks to flatten
the dendritic trees.  Their dataset was made freely available and
therefore served as a useful control for our feature vector generation
and classification method.

We took the Sumbul et al. dataset (post image warping) and processed
it in the same manner as for our data, using exactly the same methods
to generate feature vectors and then to classify these feature
vectors.  The only difference in feature vectors was that soma area
(SA) was absent as no soma information was recorded in their data.
Table 8 shows the best feature sets found.  There are some notable
differences with Table 6 which shows the results from our current
data. Bistratification distance and stratification depth were more
often picked as classifiers of the Sümbül data, while dendritic area
and density of branch points were less informative.  The former is
understandable, as the pre-processing was done to enhance these two,
the latter two could perhaps be a consequence of the warping of the
dendritic tree. The classification performance (column 2 of Table 9)
is comparable with what we saw for our data, confirming that the data
in our current study, VAChT bands aside, is of a similar value to RGC
classification as the Sümbül approach, and that errors in classifier
are similar in both datasets. It is important to note though that the
Sümbül dataset contains seven RGC types, and ours has five RGC
types, although reducing their data to five types only mildy improved
performance (from 82 to 84%).


<!--- ## Summary --->

<!--- The dendritic stratification relative to the VAChT-bands was shown --->
<!--- previously to be a good predictor of RGC type. We used machine --->
<!--- learning techniques to see how well we could predict RGC type without --->
<!--- the VAChT-band information. We found that it was possible to get about --->
<!--- 84% correct classification using five morphological features derived --->
<!--- from the dendritic tree and soma. --->

# Discussion

In this study we have used five transgenic mouse lines (CB2-GFP,
Cdh3-GFP, DRD4-GFP, Hoxd10-GFP and TRHR-GFP) that each fluorescently
label a subpopulation of RGCs to selectively target these cells in our
experiments. It is an open question whether the type of an RGC can be
identified using morphological features alone. To address this we have
applied machine learning techniques to our data set to see if it is
possible to train a classifier to distinguish between different RGC
types.

## Key findings

By using our data set annotated with the genetic type of each RGC we
could train a classifier to predict the RGC type based on the
morphological features. We found that no single feature could alone
predict the type of a RGC. For each feature there was considerable
overlap between the different RGC types. This is in line with earlier
findings [@Sun2002-ae] that reported considerable overlap between soma
area and dendritic field for different RGC types in mouse. One
possible reason for this feature overlap is that the size and shape of
RGCs varies considerably across the retina [@Wassle2004-lt]. Neurons
in the center are more densely packed than those in the periphery and
as a consequence have a smaller dendritic area than peripheral neurons
of the same type [@Bleckert2014-hg].  Even though at a given
eccentricity cat beta RGCs are smaller than alpha RGCs, a peripheral
beta RGC might be confused for an alpha RGC from central retina
[@Boycott1974-aa].  Mouse has a shallower density gradient than cat
[@Jeon1998-df], but one possibility to explore would be to scale the
area with eccentricity, however we did not have the location for the
individual RGCs.

We tested supervised classification using the same three features that
@Kong2005 used in their study (Stratification Depth, Dendritic
Density and Dendritic Area) but only achieved 61.5±2.6% correct
predictions. The poor result is a combination of our stratification
depth being measured relative to soma, and possibly variation in
dendritic area with eccentricity.

To find the best feature set we searched the entire set of possible
features (2^15^-1 = 32767 possible feature combinations; results
summarised in Table 5). A classifier with five features predicted the
correct RGC type withan accuracy of 83% (row 5 of Table 5). This is lower
than **near-perfect** [@Sumbul2014-vm], but around three and a half
times above chance level which is around 24%. We discuss the
differences between our approach and Sümbül’s in the *Limits* section
below.

To verify our data we also tested the algorithm on a dataset from
@Sumbul2014-vm to see if they performed comparably. Their data
set had been pre-processed into a standard space based on the VAChT
band location We achieved 82% accuracy for the classification and
found that stratification depth and bistratification distance were
informative for the algorithm. This indicates that with the exception
of the VAChT bands, the data is of comparable value to RGC
classification as Sümbül et al presented. The VAChT bands are
discussed further under Limits below.


For our analysis we had initially assumed that each genetic mouse line
marked one RGC type, however, Cdh3 labels two types
[@Osterhout2011-9b9] and Hoxd10 marks four types
[@Dhande2013-vp; Osterhout2014-ko]. Our unsupervised clustering of the
Hoxd10 (Figure 6) was in agreement with this result, picking out
two clusters whose arbors looked distinct.


In our classification results TRHR was sometimes confused with
DRD4. Both genetic labels mark ON-OFF RGCs that are direction
selective for posterior motion with TRHR being more broadly tuned
[@Rivlin-Etzion2011-ji]. One difference mentioned in that study is
that the TRHR have a more symmetric arbor, while the soma of DRD4 is
**off centre (explain)** which is a distinction our morphological
features do not distinguish between.

### Limitations of clustering TODO

**A study by [@Coombs2006-pb] did unsupervised clustering
identifying 10 clusters of RGCs. They found that melanposin positive
cells clustered together in one group, while SMI-32 positive cells
spanned four different clusters. This is in line with our findings
(Table 7)
that some cell types span multiple clusters, the silhouette value for
the genetically labeled classes is 0.2 (using the five-feature set),
which indicates that there is considerable overlap.**



## Limits

The retina is a layered structure, and depending on where the RGC
dendrites arborize they will receive different types of input. By
marking the VAChT bands it is possible to see in which layer the RGCs
stratify.  @Kong2005 found that stratification depth was a
good feature for unsupervised clustering, and @Sumbul2014-vm showed
that it is a good, but not perfect, predictor of the RGC
type. The VAChT bands are not completely flat, and the distance
between them can vary across the retina. Therefore it is important
that the stratification depth is measured relative to the VAChT
bands. Sümbül et al modified their experimental procedure to take
special care not to compress the retina by the glass cover slip. For
reasons related to our initial data acquisition protocol we were
unable to reliably detect location of the inner (ON) and outer (OFF)
VAChT bands in our z-stacks. Often only one broad peak was visible in
the staining. In our study the stratification depth is therefore
measured from the soma, which admittedly was not as good an indicator
of class membership as the relative stratification depth.

Another limitation was the uneven sampling of the RGC types, out of
the 94 cells sampled 29 were Hoxd10 while 9 were TRHR. Having more
TRHR cells might have allowed the Naïve Bayes classifier to build a
better internal representation of the RGC type.

Two RGC types (XXX,YYY) are in both datasets. The difference in
the quality of the VAChT band data is probably due to differences in
experimental protocol, as the Sümbül experiments have been optimized
to retain the VAChT band information, as well as the non-linear
pre-processing that un-warps the arbors based on the VAChT-band.


**Andy: I think we end on too much of a downer, “whats wrong with our
  data” tone. We should emphasize the value of a classifier that
  doesn’t require Z information.**

## Future work

Aside from the technical result it is worth mentioning that Sümbül et
al have taken the lead on sharing their data and code which enabled us
and others to reanalysis and verify the results. It also facilitates
comparison between studies. @Sumbul2014-vm combined
genetically identified RGCs with unlabeled RGCs **If unlabelled, how
can we see them?**, and predicted the
existence of a new set of RGCs. One of our goals was to combine our
data set with their data set to see if we could identify one of the
unknown. Before combining the two sets we wanted to verify that they
were comparable. There were CB2 and Cdh3 RGCs in both sets, but when
we plotted the merged data set their features did not overlap. This
discrepancy is probably due to different acquisition methods, and
might have been alleviated to some extent if the raw data was
available. As it stands this meant we were unable to combine the two
data sets and instead investigated them separately. Also we did not
have the VAChT band information to directly incorporate our cells in
their analysis pipeline.

Stratification depth has proven to be a good predictor of the RGC
type, as it indicates what input the RGC receives. In a similar way
the RGC target might be an important feature. This could be acquired
by using retrograde tracing techniques to label the RGCs. Previous
studies have identified the targets of the five genetic types studied
here: CB2 projects to contralateral SC and dorsal lateral geniculate
nucleus [@Huberman2008-5a6]. Hoxd10 project to Accessory Optic
System (nucleus of the optic tract, medial terminal nucleus and dorsal
terminal nucleus) [@Dhande2013-vp]. Cdh3 innervate vLGN, IGL, OPN,
mdPPN [@Osterhout2011-9b9]. DRD4 project to dorsal lateral
geniculate nucleus, ventral lateral geniculate nucleus and the
superior colliculus [@Rivlin-Etzion2011-ji]. TRHR project to dorsal
lateral geniculate nucleus, zona incerta, ventral lateral geniculate
nucleus and the superior colliculus [@Rivlin-Etzion2011-ji].


**Highlight this as key aspect:** Given that our method does not rely
on VAChT band information, which is specific to the retina, our
technique should be applicable to use on other neurons; most of the
measures are planar, but the framework allows us to extend to
volumetric features of neuron.


In summary, we have developed a classifier that can predict the type
of a RGC using morphological features. Our method does not require
VAChT band information to be gathered. We can predict the RGC type of
CB2, Cdh3, DRD4, Hoxd10 and TRHR correctly with 83% accuracy.



## Acknowledgements

We thank Uygar Sümbül for sharing tracings of retinal ganglion cells,
and his code for classification of cell types. The authors were
supported by the Wellcome Trust (JJJH and SJE, grant number: 083205),
NIH (RNE-D and ADH). We thank  Ellese Cotterill for comments on the
manuscript.

\clearpage

# Figure legends

<!--ExampleMorphologies.eps   -->
**Figure 1:** Neurolucida tracings of RGC obtained from five 
transgenic mouse lines: CB2, Cdh3, DRD4, Hoxd10 and TRHR. Dendrites
and soma are drawn in black, and axons in red.


<!-- Feature Illustration.pdf -->
**Figure 2:** Conversion of an RGC morphology into a feature vector.
*A*: Example RGC outline to be converted into a feature vector.  The
Dendritic Area (DA) is calculated
as the convex hull (light grey) enclosing all dendrites (black); axon
in red.
*B*: Fractal dimension (FD) measures the
number of grid squares filled at different grid magnification.
*C*: Stratification depth (SD):  z-coordinate of the centre of
dendritic mass (for our data this is relative to the  soma centre; for
the @Sumbul2014-vm data it is 
normalized to the VAChT-bands, shown as dotted red
lines). Bistratification distance (BD): 
(normalized) distance Δz between the centres of two Gaussians fitted
to the dendritic histogram.
*D*: Branch angle, Number of
branch points, terminal segment length: elementary measures.
*E*: Dendritic tortuosity (DT): dendritic path length divided by shortest
distance between end points (a/b).
*F*: The feature vector is created by assembling fifteen measures,
such as those shown in panels A--E.  The RGC in panel A is then
represented by this feature vector.


<!-- Figure3 - Three Cases.pdf -->
**Figure 3:** Cartoon illustrating the different degrees of separation
of three types of neuron in feature space.  Each neuron is represented
as a point in a high dimensional feature space (here for simplicity we
showing just two of those dimensions). For good classification, cells
of the same type need to be close to each other and far from other
cells of other types.
*A*: The classes are clearly separable in feature space; cells can be
classified without error.
*B*: Classes overlap significantly in feature space, making it
difficult to classify cells.
*C*: There is moderate overlap between classes, leading to good, but
imperfect, classification.  When presented with a cell of unknown type
(black square), a classifier would predict this cell as type 1.


<!-- Classification-RGC-traces.pdf -->

**Figure 4:** Examples of correctly and incorrectly classified
  RGCs. Left, the most typical neuron of each type – the neuron of
  each type with the highest posterior probability. Right, the neuron
  that the classifier incorrectly ranked as most likely being of the
  specific type. Neurons are labeled with “predicted : actual” type
  description. For example, the RGC in the top right was predicted to
  be Hoxd10 but was CB2. Dendrites are marked as black, axons as
  red.

<!--  Figure5-feature-space-and-confidence.pdf -->
**Figure 5:**
Illustration of feature space and the classifier confidence for each
RGC. Each neuron is represented as a 5D-feature.
*A*: Two of the five features are shown for each RGC: Soma
Area and Density of Branch Points.  Each RGC is represented by a
filled circle, with the colour denoting its genetic type (see legend).
Cells incorrectly classified are enclosed in a triangle, with the
colour of the triangle denoting the predicted type.
*B*: Same as in A, but RGCs are plotted on the first two principal
components (which account for 80% of the variance).
*C*: Confidence in
classification for each cell in the dataset. The x-axis lists all
neurons grouped by their genetic type, the y-axis shows the
confidence in the classification (posterior probability from the Naïve
Bayes classifier). Correct classifications are marked with a filled
circle, triangles indicate incorrectly classified neurons and the
colour denotes predicted type. Chance level for the classifier is
marked with a dashed blue line.

<!-- Blind-Hoxd10-best-clustering.eps -->

**Figure 6:** Distribution of Hoxd10 RGCs in feature space.  The
projection of all X Hoxd10 RGCs onto the first two principal
components (accounting for 84% of the variance) is shown in the
top-left.  Unsupervised clustering into three clusters, here marked
with filled circles, triangles and crosses.  Two large clusters are
observed, with a third cluster with just own member (top-right). Three
representative RGCs from each of the three clusters (numbered 1, 2 and
3) are shown.


<!-- PCA variances
1.

For figure 5B, the PCA variances are:

    3.1046
    0.8910
    0.4945
    0.3273
    0.1827

62.1 % for first component, 17.8% for second component.


For figure 6 the PCA variances are

    2.6549
    0.9485
    0.3848
    0.1822
    0.1038

62.1% for first component, 22.2% for second component

-->
 <!--
![This is the caption](Figures/Figure2/Feature-Illustration.pdf)

\clearpage

\includepdf[pages=-]{allfigs.pdf}
\includepdf[pages=-]{allTables.pdf}

-->

\clearpage

# References
\setlength{\parindent}{-0.2in}
\setlength{\leftskip}{0.2in}
\setlength{\parskip}{8pt}
\vspace*{-0.2in}
\noindent




<!-- (setq reftex-cite-format '((?\C-m . "[@%l]"))
	       reftex-default-bibliography '("rgcmorph.bib"))
 -->

