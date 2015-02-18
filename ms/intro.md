---
title: Dendritic branching and somal characteristics reliably classify mouse retinal ganglion cell types
author:
- name: J J Johannes Hjorth
  affiliation: Department of Applied Mathematics, University of Cambridge, UK
- name: Rana N El-Danaf
  affiliation: Department of Neurosciences, University of California, San Diego, USA
- name: Andrew D Huberman
  affiliation: Department of Neurosciences, University of California, San Diego, USA
- name: Stephen J Eglen
  affiliation: Department of Applied Mathematics, University of Cambridge, UK
  email: S.J.Eglen@damtp.cam.ac.uk
nocite: |
  @Huberman2009-xf, @Osterhout2011-9b9, @Huberman2008-5a6,
  @Dhande2013-vp, @Rivlin-Etzion2011-ji
date: 2015-02-17 <!-- TODO update by hand. -->
...

<!-- nocite above to ensure we cite all the refs from Table 1. -->
---


### Abbreviated title

Classification of mouse retinal ganglion cells

### Contributions

Conceived and designed the project: ADH, SJE;  Collected experimental
data: RNE-D; Analysed and interpreted data: JJJH, RNE-D, ADH, SJE;
Wrote the paper: JJJH, RNE-D, ADH, SJE.


\clearpage



\clearpage

# Abstract

\linenumbers
\modulolinenumbers[2]
\renewcommand\linenumberfont{\normalfont\tiny\sffamily\color{lightgray}}

There are estimated to be around 20 different types of retinal
ganglion cells (RGCs) in mouse retina. Recently-developed genetic
markers allow for the identification and targeting of specific RGC
types, which have different functional and morphological features. The
purpose of this study was to develop computational tools to identify
RGC types based on the most common available sources of information
about their morphology: soma size and dendritic branching pattern. We
used five different transgenic mouse lines, in each of which 1--2 RGCs
types selectively express green fluorescent protein (GFP). Cell
tracings of 94 RGCs were acquired from retinas of CB2-GFP, Cdh3-GFP,
DRD4-GFP, Hoxd10-GFP and TRHR-GFP transgenic mice. Fifteen
morphological features of GFP expressing RGCs were calculated, and
supervised machine learning techniques were used to classify the
neurons. We found that just five features (dendritic area, density of
branch points, fractal dimension, mean terminal segment length and
soma area) were enough to correctly classify 83% of the RGCs into the
five types that we examined.  We therefore believe that standard
morphological features can serve as reliable classifiers of mouse
RGCs.  As these features are not specific to retinal neurons, we
suggest our approach can be used on a wide range of neuronal
morphologies.

### Keywords
cell types, retinal ganglion cells, clustering, classification.



\clearpage

# Introduction

The retina processes the visual scene and sends this information in
parallel channels to the brain via retinal ganglion cells (RGCs)
[@Wassle2004-lt; @Dhande2014-ek].  To determine the number of parallel
channels, we first need to determine the number of RGC types.  The
pioneering work of @Boycott1974-aa suggested that there were at least
three morphological sub-classes (alpha, beta and gamma) of RGC in cat,
and these three types mapped onto previously-defined physiological
classes [X, Y and W; @Cleland1971-bo].  For example, alpha cells were
defined as having larger dendritic fields and somata compared to
neighbouring beta cells.  However, individual morphological features
cannot uniquely predict cell type, as demonstrated by the large
overlap in RGC somata area [Figure 6 of @Boycott1974-aa] among
alpha/beta/gamma cat RGCs.  Instead, multiple features should be
considered simultaneously when classifying neurons.  @Rodieck1983-nb
formalised this notion, proposing to use multiple features to define a
multidimensional "feature space" in which to define RGC types.  If
cells form distinct types, then cells of the same type should cluster
together in one part of this feature space, and that different cell
types occupy different parts of feature space.

Recent advances in imaging and genetics have led to a dramatic
increase in data, especially from mice [@Badea2004], to test whether
distinct types of RGCs form clusters in multidimensional space.
Estimates for the number of mouse RGCs types vary from 12 [@Kong2005]
to 22 [@Volgyi2009] based either on manual classification of cell
types or unsupervised machine learning methods.  These techniques have
also been applied to grouping of RGCs in other species, including cat
[@Jelinek2004-gp], newt [@Pushchin2009-ef5] and lamprey
[@Fletcher2014-mj].  These unsupervised approaches use statistical
methods to determine the optimal number of clusters in the data
[e.g. using the silhouette widths technique, @Rousseeuw1987-xe].
However, these previous studies had no independent indicator of cell
type to compare with the predicted cell types.

In this study, we analyse the morphology of RGCs from five mutant mice
lines where typically one or a few types of RGCs are labelled with GFP.
We use supervised machine learning techniques to predict whether the
anatomical features can predict the "genetic type" of the mouse,
i.e. the mouse line from where the cell was labelled.  This provides
us with ground-truth data which we can use to evaluate our methods
against.  From each individual RGC we measured fifteen features, from which we
found five that were highly predictive of cell type.  We compare our
findings with a recent study [@Sumbul2014-vm] where perfect
classification was achieved when detailed information about the entire
dendritic stratification relative to reliable retinal landmarks (VAChT
bands) was included.  We suggest that our simple anatomical measures
can provide a reliable basis for classification in the absence of
stratification depth information, and thus that the @Rodieck1983-nb
method of classification is robust when applied to mouse RGCs.

# Materials and Methods

Five different transgenic lines of mice were chosen for this study. By
utilizing genetic markers for CB2, Cdh3, DRD4, Hoxd10 and TRHR,
individual RGCs of specific types could be targeted and fluorescently
labelled (details of each line are given in Table 1).  We refer to the
genetic markers as the "genetic type" of the RGCs, and follow the
terminology proposed by @Cook1998 for distinguishing between the
notion of a "type" and "class" of a neuron. When we refer to a class
of a neuron, it usually indicates the predicted group from the
clustering/classification methods. Some neurons included in this study
were illustrated and analysed in earlier publications
[@Beier2013-mc; @Cruz-Martin2014-sf; @Osterhout2014-ko; @El-Danaf2015-pk].


## Experimental procedure

All experimental procedures were approved by the Institutional Animal
Care and Use Committee (IACUC) at the University California, San
Diego. Table 1 lists the BAC transgenic mouse lines used in this study
and the number of RGCs from each animal.  Intracellular cell filling,
immunostaining of the retina and imaging of RGCs were performed using
methods described in detail previously
[@Beier2013-mc; @Dhande2013-vp; @Cruz-Martin2014-sf; @Osterhout2014-ko; @El-Danaf2015-pk]. Mice
were anesthetized with isoflurane vapors.  The eyes were removed and
the retinas were dissected and kept in an oxygenated (95% O~2~/ 5%
CO~2~) solution of Ames’ medium (Sigma Cat# A1420), containing 23 mM
NaHCO3.  Single GFP+ RGCs were visualized under epifluorescence, and
then targeted with borosilicate glass electrodes (Sutter instruments;
15-20 MΩ) under DIC. Cells were filled with Alexa Fluor 555 hydrizide
(Invitrogen Cat# A20501MP; 10 mM solution in 200 mM KCl) with the
application of hyperpolarizing current pulses ranging between 0.1-0.9
nA for 1--5 minutes.




Retinas were then fixed for 1 hour in 4% paraformaldehyde (PFA), then
washed with 1x phosphate buffered saline (PBS) and incubated for 1
hour at room temperature in a blocking solution consisting of 10% goat
serum with 0.25 % Triton-X. The retinas were then incubated for 1 day
at 4°C with the following primary antibodies diluted in blocking
solution: rabbit anti-GFP (1:1000, Invitrogen Cat# A6455); guinea pig
anti-VAChT (1:1000, Millipore Cat# AB1588). Retinas were rinsed with
PBS (3x, 30 minutes each), and incubated for 2 hours at room
temperature with the following secondary antibodies: Alexa Fluor 488
goat anti-rabbit (1:1000, Life Technologies Cat# A11034); Alexa Fluor 647
goat anti-guinea pig (1:1000, Invitrogen Cat# A21550). Sections
were rinsed with PBS (3x, 30 minutes each) and mounted onto glass
slides and coverslipped with Prolong Gold containing DAPI (Invitrogen
P36931).

RGCs were imaged with a laser scanning confocal microscope (Zeiss LSM
710 or 780), using a LD C-Apochromat 40X/1.1 water immersion objective
lens (Z-step = 0.48-0.5 Z-step µm; scanning resolution = 1024x1024
pixels, Kalman averaging = 2-4). Complete 3D morphological
reconstructions were obtained manually using Neurolucida software
(10.42.1, MBF Bioscience) and exported to our custom-written Matlab
scripts for analysis.  All relevant data and code relating to this
project are available from
[https://github.com/Hjorthmedh/RGCmorphology](https://github.com/Hjorthmedh/RGCmorphology).

## Analysis of RGC morphology

@Rodieck1983-nb proposed measuring multiple features to define a
feature space, within which different RGC types could be
identified. Our analysis calculated 15 morphological features to
quantify the characteristics of individual RGCs (Table 2). From these
features, we defined a feature vector, which specified a point in the
15 dimensional feature space. The individual features are:

### Dendritic Area and Soma Area

The dendritic area is the convex hull enclosing all the dendrites
(Figure 2A), and the soma area is calculated similarly. All
areas are measured in the XY-plane.

### Fractal Dimension

Fractal dimension measures the neuron’s coverage of the retina at
different length scales. Here we used the box counting method
[@Fernandez2001-ef]. The neuron was projected onto the XY-plane and a
grid was placed over it (Figure 2B). This grid was then successively
refined. The magnification is defined as the maximal distance between
grid lines / current distance between grid lines. At each step, the
number of grid boxes that contains a piece of dendrite was
counted. The logarithm of the number of non-empty grid squares was
plotted against the logarithm of the magnification. A line was fitted
to these points using the least squares method, and the resulting
slope is an estimate of the fractal dimension.

### Stratification Depth and Bistratification distance

Commonly, stratification depth is defined as the center of mass of the
dendritic tree relative to the two VAChT bands
[@Kong2005; @Sumbul2014-vm] that mark the locations of the starburst
amacrine cells. Due to unreliable labelling the locations of the two
VAChT bands are unknown in our study; instead the depth is measured
relative to the soma.

Bistratification distance is the distance between the upper and lower
parts of the dendritic tree (Figure 2C). Two Gaussians are fitted to a
histogram (along the z-axis) of the dendritic tree, and the (scaled)
bistratification distance is calculated by

$$ d_{BS}=(d_{A}-d_{B} )/ \max(\sigma_{A},\sigma_{B}) $$

where d~A,B~ are the centres of the Gaussians, and σ~A,B~ are the
standard deviations. This is calculated for both bistratified and
monostratified cells, but for bistratified neurons this distance will
be larger.

### Branch Asymmetry and Angle

For any branch point *i* (Figure 2D), there are typically two, but
sometimes three, branches.  We denote the number of terminals
underneath each of the two or three branches at point *i* by A~i~, B~i~,
C~i~.  The branch asymmetry at branch point *i* is given by
$$ \max(A_i, B_i, C_i) / (A_i + B_i + C_i).$$  These ratios are averaged over all
branch points to give the branch asymmetry for a neuron. The
branch angle is calculated as the angle between the two branches in 3D
space.

### Length measures and Branch Points

The dendritic tree is divided into segments, split by the branch
points. From these segments, measures such as mean segment length,
mean terminal segment length, number of branch points, total dendritic
length and dendritic diameter are derived.  Mean segment tortuosity
(Figure 2E) is the ratio of the path length from the soma to the
dendritic end point divided by the Euclidean distance between
them. The dendritic density is the total dendritic length divided by
the total dendritic area, the density of branch points is defined
analogously.

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
unsupervised k-means clustering using the Matlab `kmeans` function.  The
rational was that the features chosen for the classifier would be
those that were informative for separating the RGC types, and we
wanted to see if there was a natural grouping in feature space.

### Classification method

The primary classifier used in this study was the Naïve Bayes method
[@Manning2008-dq].  We explored a range of other classification
methods including Decision trees [@Kotsiantis2013-jc] with various
forms of boosting or bagging [@Breiman1996-ji; @Ho1998-cp] and Support
Vector Machines [@Hastie2009-ws].  We found that these classifiers had
similar performance and so here we present only the results from the
Naïve Bayes classifier.

### Classification features

The features for the classifier were selected using an exhaustive
search of all combinations of the 15 features using Naïve Bayes. We
partitioned the 94 RGCs into five folds, and used four of them for
training and the remaining one for testing. This was repeated five
times, one for each of the five folds, to perform a five-fold cross
validation. This procedure was then repeated 20 times using different
folds, for a total of 100 classification tests. We then plotted the
number of features against the performance, and picked a feature set
where adding additional features only improved the performance
marginally.

### Feature space plot

We created two different feature space plots, the first only plotted
the RGCs on two of the features. The second used principal component
analysis (computed in Matlab, with variance normalization) to
visualize the feature space, and plotted the RGCs on the two first
principal components.  These correspond to the two orthogonal
directions that account for the largest variation of the data set. 

### Classification and the confusion matrix

The confusion matrix summarizes the predictions of a classifier. Each
row represents one of the five genetic types, and each column lists
the predicted types. Correctly classified RGCs are counted on the
leading diagonal. For each RGC, we created a test set containing all
RGCs except that cell, trained the classifier, and then predicted the
type of the RGC that was held back. The classification of individual
cells was generated in the same way as for the confusion matrix, using
the leave-one-out method, and the robustness of the results verified with
cross-validation.



### Determining typical and atypical cells

We used the maximal posterior probability from the Naïve Bayes
classifier as a measure of "confidence" in classifications.  To
classify each neuron, we withheld it from the training set, using the
leave-one-out technique. Following the methodology established by
@Khan2001-71f we plotted the most typical RGC of each type, which was
defined as the one with the highest posterior probability. We also
plotted the most atypical RGC of each type, which was defined as the
RGC with the highest posterior probability for another type other than
its genetic type.

# Results



We filled, reconstructed and analyzed 94 RGCs from five genetic mouse
lines: CB2, Cdh3, DRD4, Hoxd10 and TRHR (Table 1). In these mouse
lines GFP is usually expressed in just one or a few RGC types.  This
makes it possible to reliably and selectively target the same types of
RGCs across animals.  We will refer to these five lines as “genetic
types” and we assume for the initial analysis that each of these
uniquely define one RGC type.  Our prior findings suggest however that
Hoxd10 may label 3--4 distinct RGC types.  In this work we initially
assume that Hoxd10 labels one type of RGCs, and then assess later in
detail whether it is likely to label multiple types.  Three example
RGCs of each genetic type are shown in Figure 1. The axons (not shown
in Figure 1) and dendrites (black lines) were manually traced, and the
locations of the somas were marked. Each RGC collects information
about a small region in the visual field; the shape and distribution
of the dendritic tree differs depending on the function the RGC
performs. It is an open problem to identify the RGC type based on
morphological characteristics. Here we are interested in using
objective methods to assess morphological patterns distinct to each
type.

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
type. Most, but not of all, of our RGC z-stacks included VAChT
staining.  However, as we were unable to reliably observe two separate
VAChT bands, we could not use the bands to determine stratification
depth.  We instead calculated the stratification depth relative to the
soma centre.  We found that there was considerable
overlap between the different RGC types according to stratification
depth (Table 3).  There were also significant overlaps between the RGC
types based on other features. For example, Table 3 shows that Hoxd10
generally had a larger dendritic area than other RGC types but that
the standard deviation is so large that the range spans the whole
spectrum of values of other RGC types. To assess the predictive powers
of the individual features, we trained a Naïve Bayes classifier for
each individual feature.  The single-most discriminative feature for
our data was mean terminal segment length, which correctly predicted
64.7 ± 1.7\ % of the cases.  We therefore confirm that our individual
features are not reliable classifiers of neuronal type.

## Selection of multiple feature vectors

Rodrieck and Brening (1983) described the need to base neuronal
classification on objectively measurable features which, if used to
form axes, define a multidimensional feature space.  This is
demonstrated with three sets of synthetic data in Figure 3.  In Figure
3A, dendritic area on the y-axis can separate the red and green
clusters quite well, but does not separate the green and blue
groups. By introducing soma area as an additional feature, the
different types separate in feature space. With a larger spread of the
groups (e.g. Figure 3B), the different types become intermingled; *a
priori* we might expect real data to look closer to the synthetic case
shown in Figure 3C, where there is both signal to separate the
classes, but also noise which blurs the boundaries between classes.

The task of a classification algorithm is to take this training data
to learn the boundaries between the different types of neuron.  After
training, the classifier is asked to predict the type of a neuron not
seen in training (e.g. black disk in Figure 3C). In this
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
distance decreases, making the cells harder to classify. A potential
complication is that some features capture similar properties, leading
to correlations between the features. The pairwise correlations
between all features are reported in Table 4.  For example, mean
segment length and mean terminal segment length are highly correlated
with each other (r=0.97), but strongly anti-correlated with density of
branch points (r=-0.85 and r=-0.78).


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
whether particular cell types were misclassified more often using a
confusion matrix. This matrix displays the different RGC types as
rows, and the predicted classes as columns. Perfect classification
would result in non-zero elements along only the leading diagonal. The
confusion matrix (Table 6) shows that Hoxd10 and TRHR were the two RGC
types that were most difficult to predict, with 21% (6/29) and 44%
(4/9) misclassification. We can compare this with the confusion matrix
from clustering using the k-means algorithm (Table 7, using the same
five features).  This clustering occurs without knowledge of the
genetic types; the result shows us that each RGC type does not neatly
fall into its own cluster.  Only the TRHR type is restricted to one
cluster (cluster 4), but that cluster is shared with three other RGC
types.  At the other extreme, neurons from the Hoxd10 type are placed
into all five clusters, although the primary split is into two
clusters (cluster 1 and 3).  Therefore, at least with our data,
unsupervised discovery of cell types correlates poorly with the known
genetic type.

To better understand why unsupervised clustering is not able to
separate the cell types, we need to examine the feature space.  We can
do this by generating scatter plots between each pair of features
e.g. one shown in Figure 5A, plotting soma area against density of
branch points.  We can observe from this that TRHR has a large overlap
with DRD4 and to some extent Cdh3. Likewise, Hoxd10 has large overlaps
with other genetic types.  Rather than repeat this procedure for each
pair of features (there are ten scatter plots for a five dimensional
feature), we used Principal component analysis to reduce the
five-dimensional vectors to two dimensions. Figure 5B shows that the
majority of the Hoxd10 cells are grouped together into a cluster that
partially overlaps with DRD4. There are also a few outliers that
overlap with CB2 and TRHR.  This two-dimensional projection confirms
our *a priori* belief that there is likely to be a morphological
signal that can separate RGCs types, but that the boundaries overlap,
as outlined for synthetic data in Figure 3C.


### Confidence in classification

To assess the nature of the boundaries in feature space between cell
types, we returned to the classifier to assess its performance. If
there is only a small overlap between clusters, we expect the
classifier to be confident (i.e. high maximal posterior probability)
about most of its predictions. When the clusters are harder to
separate, we expect the classifier's confidence in the predictions to
be lower [@Khan2001-71f]. Figure 5C shows the confidence of the
classification for different RGCs, with a higher score signifying a
more confident classification. Triangles mark the cells that were
incorrectly classified. There are some misclassified cells with
confidences around 0.5, but perhaps more concerning are misclassified
RGCs with higher (> 0.8) confidence.  Each type had one example of a
RGC with high posterior probability for the wrong type, except for
Hoxd10, which had three.  One reason for this could be that there is
something abnormal about these cells, causing them to appear in the
wrong place in feature space. However, these cells were visually
inspected but nothing unusual was seen.


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
data, we found that the mean silhouette width [@Rousseeuw1987-xe] was
maximal (0.62) when k=3. This corresponds to two major clusters, and
the third cluster containing one outlier (Figure 6). Example RGCs in
the three Hoxd10 clusters are shown in Figure 6 and reflect the
variability in different types.  These statistical results therefore
confirm our earlier suggestion that Hoxd10 line labels at least three
distinct RGC types.


## Re-analysis of the Sümbül  et al. (2014) data set

A recent study by Sümbül et al. (2014) achieved perfect classification
for RGC types labelled by seven distinct genetic markers.  One reason
for their high performance was that their classifier received a
high-dimensional representation of the density of the entire arbor,
with a fine resolution in the depth dimension.  Accurate generation of
dendritic depth information required reliable information about the
extent of the inner plexiform layer, gained through reconstruction of
the two VAChT bands.  This in turn relied on complex non-linear
image-warping of the image stacks to flatten the dendritic trees and
fine z-resolution in the image stack.  Their dataset was made freely
available and therefore served as a useful control for our feature
vector generation and classification method.

We took the Sümbül et al. dataset (post image warping) and processed
it in the same manner as for our data, using exactly the same methods
to generate feature vectors and then to classify these feature
vectors.  The only difference in feature vectors was that soma area
(SA) was absent as no soma information was recorded in their data.
Table 8 shows the best feature sets found through our exhaustive
feature search.  There are some notable differences with Table 6 which
shows the results from our current data. Bistratification distance and
stratification depth were more often picked as classifiers of the
Sümbül data, while dendritic area and density of branch points were
less informative.  Classification performance (column 2 of Table
8) is comparable with what we saw for our data, confirming that the
data in our current study, VAChT bands aside, is of a similar value to
RGC classification as the Sümbül approach, and that errors in
classifier are similar in both datasets. It is important to note
though that the Sümbül dataset contains seven RGC types, and ours has
five RGC types, although reducing their data to five types only mildly
improved performance (from 82 to 84%).


<!--- ## Summary --->

<!--- The dendritic stratification relative to the VAChT-bands was shown --->
<!--- previously to be a good predictor of RGC type. We used machine --->
<!--- learning techniques to see how well we could predict RGC type without --->
<!--- the VAChT-band information. We found that it was possible to get about --->
<!--- 84% correct classification using five morphological features derived --->
<!--- from the dendritic tree and soma. --->

\clearpage 

# Discussion

In this study we have analysed the fluorescently labelled RGCs of five
transgenic mouse lines (CB2-GFP, Cdh3-GFP, DRD4-GFP, Hoxd10-GFP and
TRHR-GFP) to assess whether morphology can predict cell type.  We
built supervised classifiers to learn the association between
morphological features of each RGC and its genetic type.  From a list
of fifteen quantitative features for each RGC morphology, a subset of
five features (dendritic area, density of branch points, fractal
dimension, mean terminal segment length and soma area) classified the
genetic type of each cell with 83% accuracy.  From the remaining RGCs
that were misclassified, one cell type, Hoxd10, had a particularly high
error rate.  We therefore investigated the Hoxd10 cell type further.  Using
unsupervised clustering of these RGCs, we believe this genetic type is
probably composed of three distinct types of neuron.


## Unsupervised versus supervised approaches

Machine learning techniques have been used by many groups to
investigate morphological classification of RGC types in a variety of
species [@Costa1999-fh; @Coombs2006-pb; @Pushchin2009-ef5].  These
methods all relied on unsupervised techniques, as there was no "ground
truth" against which to compare the results.  Such unsupervised
methods are more objective and consistent than human observers.
However, the results from unsupervised clustering can sometimes be in
conflict with independent measures of cell type.  For example,
@Coombs2006-pb used unsupervised clustering to identify ten clusters
of RGCs. They found that melanopsin positive cells clustered together
in one group, while SMI-32 positive cells spanned four different
clusters. This is in line with our findings (Table 7) that
unsupervised methods predict some cell types span multiple clusters.
Another limitation of unsupervised methods is that often the ideal
number of clusters (or cell types) must be determined by trial and
error, or by optimising some measure of the "purity" of each cluster,
such as silhouette widths [@Rousseeuw1987-xe] or similarity profile
analysis [@Clarke2008-ex].

The recent study by @Sumbul2014-vm was the first to use genetic type
information to classify neurons after they had been grouped using
unsupervised clustering techniques. However, the genetic information
was used after the groups had been created to label the groups.  By
contrast, in our study, we have used the genetic information to
supervise the construction of groupings.  We believe that this is the
first time that supervised classification methods have been used to
classify neurons based on their morphology.

## Choice of features

In line with earlier studies, we have chosen a range of morphological
features that encompass various properties about the neuron.  A key
limitation of our study is that stratification depth information was
measured relative to soma centre, rather than relative to the processes of
cholinergic amacrine cells that delimit both sides of the inner
plexiform layer.  In line with previous studies
[e.g. @Kong2005; @Pushchin2009-ef5; @Fletcher2014-mj] many of our morphological
features are highly correlated or anti-correlated with each other
(Table 4).  Previously, one approach to reducing the number of
features to represent a neuron was simply to remove features if
correlations exceeded some threshold [@Fletcher2014-mj].  We have taken a
simple, yet objective and systematic, approach by instead exhaustively
searching over all feature subsets to assess how classification
varies.  Using this approach, we found five features that were highly
predictive of cell type.

Although our feature classifier gives good performance, it does not
match the perfect performance reported recently for seven genetic
types of mouse RGC [@Sumbul2014-vm].  We believe the key difference is
due to the detailed nature of the representation of the dendritic arbor
in that study: each neuron was represented by a 20x20x120 volume, with
each voxel measuring the local dendritic density with very fine
resolution in the z-dimension.  This generates a large (48,000)
dimensional vector.  Advanced image processing techniques
[@Sumbul2014-pr] are required to flatten the RGC dendrites into a
standard space, normalised by the two cholinergic bands.  This
approach is clearly optimal for classifying RGCs (and possibly other
classes of retinal neuron, such as bipolar cells) where stratification
depth is a strong predictor of cell type, and where there is a
reliably spatial reference frame.  However, our approach uses much
simpler, standard methods to measure features which are likely to
apply to a whole range of neuronal types, including those where there
is no reliable spatial reference.


## Limitations and future work

By using our data set annotated with the genetic type of each RGC we
could train a classifier to predict the RGC type based on the
morphological features. We found that no single feature could alone
predict the type of a RGC. For each feature there was considerable
overlap between the different RGC types. This is in line with earlier
findings [@Sun2002-ae] that reported considerable overlap between soma
area and dendritic field for different RGC types in mouse.  It is
likely that the classification results that we present here can be
improved if other factors can be taken into account.  For example, it
has long been known from other species such as cat that the overall
size and shape of RGCs varies considerably across the retina
[@Boycott1974-aa; @Wassle2004-lt].  Neurons in the center are more
densely packed than those in the periphery and as a consequence have a
smaller dendritic area than peripheral neurons of the same type.  Even
though at a given eccentricity cat beta RGCs are smaller than alpha
RGCs, a peripheral beta RGC might be confused for an alpha RGC from
central retina when viewed in isolation [@Boycott1974-aa].  Mouse has
a shallower density gradient than cat [@Jeon1998-df], although
dendritic diameter of an alpha-like mouse RGC increases
strikingly from nasal to temporal retina [@Bleckert2014-hg].  In our study,
most RGCs were taken from the middle third of the retina, which should
have minimized any eccentricity-variations.  However, for future work,
another feature to include (or control for) would be retinal
location.

Addtionally, in our classification results TRHR was sometimes confused
with DRD4 (bottom row of Table 6; three of nine cases). Both genetic
labels mark ON-OFF RGCs that are direction selective for posterior
motion with TRHR being more broadly tuned [@Rivlin-Etzion2011-ji]. One
difference mentioned in that study is that TRHR RGCs have a more
symmetric arbor compared to DRD4 RGCs.  It is possible that adding
features that characterize arbor symmetry could distinguish between
these two types.

Given that many laboratories are now generating morphological data of
mice in RGCs, it would be interesting to analyse these collections
together to conduct meta-analyses.  We attempted this as the data from
@Sumbul2014-vm is freely available.  @Sumbul2014-vm combined
genetically identified RGCs with RGCs from three heterogeneous lines
where a broad range of RGCs were labelled.  Using these heterogeneous
lines, they predicted the existence of six new types of RGCs. One of
our goals was to combine our data set with theirs to see if we could
identify one of their unknown six types. As a control, as both
datasets included samples of CB2 and Cdh3 RGCs, we first checked
whether features were consistent between the two laboratories.
However, we found significant between-laboratory differences in the
magnitudes and distributions of key features for the same genetic
type.  This discrepancy prevented us from further comparing the two
datasets together.

Finally, in this work we have predicted RGC identity based solely upon
the morphological features of the soma and dendrites; further
predictive information could be obtained by examining the destination
brain region for axons.  Our earlier work has identified targets of the
five genetic types studied here. For example, CB2 RGCs projects to
contralateral superior colliculus and dorsal lateral geniculate
nucleus [@Huberman2008-5a6] whereas Hoxd10 RGCs project to the accessory
optic system [@Dhande2013-vp].

In summary, we have shown the utility of building a classifier for
neuronal morphologies based upon correlating simple dendritic features
with genetic information.  In the case of the RGCs studied here, this
has helped to confirm the morphological uniqueness of some types (such
as CB2) and the variability of other types (particularly Hoxd10).  By
using simple features that are not specific to retinal neurons and easy
to extract from neuronal reconstructions, we believe that our method
can be applied to a wide range of cells found throughout the nervous
system.  To help other groups build upon our results, all of our
computer code and data relating to this project are freely available online.

## Acknowledgements

We thank Uygar Sümbül for sharing tracings of retinal ganglion cells,
and his code for classification of cell types. The authors were
supported by the Wellcome Trust (JJJH and SJE, grant number: 083205),
NIH RO1 (ADH, grant number: EY022157-01), and a grant from the
Glaucoma Research Foundation Catalyst for a Cure (RNE-D and ADH). We
thank Julian Budd and Ellese Cotterill for comments on the manuscript.

\clearpage

# Figure legends

<!--ExampleMorphologies.eps   -->
**Figure 1:** Neurolucida tracings of RGCs obtained from five
transgenic mouse lines: CB2-GFP, Cdh3-GFP, DRD4-GFP, Hoxd10-GFP and
TRHR-GFP. Dendrites and soma are drawn in black, and axons in red.


<!-- Feature Illustration.pdf --> **Figure 2:** Conversion of an RGC
morphology into a feature vector.  *A*: Example RGC to be converted
into a feature vector.  The Dendritic Area (DA) is calculated as the
convex hull (light grey) enclosing all dendrites (black).  *B*:
Fractal dimension (FD) measures the number of grid squares filled at
different grid magnification.  *C*: Stratification depth (SD):
z-coordinate of the centre of dendritic mass (for our data this is
relative to the soma centre; for the @Sumbul2014-vm data it is
normalized to the VAChT-bands, shown as dotted red
lines). Bistratification distance (BD): (normalized) distance Δz
between the centres of two Gaussians fitted to the dendritic
histogram.  *D*: Branch angle (BA), Number of branch points (NBP), terminal
segment length (TSL): elementary measures.  *E*: Dendritic tortuosity (DT):
dendritic path length divided by shortest distance between end points
(a/b).  *F*: The feature vector is created by assembling fifteen
measures, such as those shown in panels A--E, e.g. x~1~ could be the
value of the dendritic area for this neuron.  The RGC in panel A is
then represented by this feature vector.


<!-- Figure3 - Three Cases.pdf -->
**Figure 3:** Cartoon illustrating the different degrees of separation
of three types of neurons in feature space.  Each neuron is represented
as a point in a high dimensional feature space (here for simplicity we
are showing just two of those dimensions). For good classification, cells
of the same type need to be close to each other and far from cells of other types.
*A*: The classes are clearly separable in feature space; cells can be
classified without error.
*B*: Classes overlap significantly in feature space, making it
difficult to classify cells.
*C*: There is moderate overlap between classes, leading to good, but
imperfect, classification.  When presented with a cell of unknown type
(black disk), a classifier would predict this cell as type 1.


<!-- Classification-RGC-traces.pdf -->

**Figure 4:** Examples of correctly and incorrectly classified
  RGCs. Left, the most typical neuron of each type – the neuron of
  each type with the highest posterior probability. Right, the neuron
  that the classifier incorrectly ranked as most likely being of the
  specific type. Neurons are labeled with “predicted : actual” type
  description. For example, the RGC in the top right was predicted to
  be Hoxd10 but was CB2.

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
projection of all Hoxd10 RGCs onto the first two principal components
(accounting for 84% of the variance) is shown in the top-left.
Unsupervised clustering into three clusters, here marked with filled
circles, triangles and crosses.  Two large clusters are observed, with
a third cluster with just one member (top-right). Three representative
RGCs from each of the three clusters (numbered 1, 2 and 3) are shown.





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


<!--  LocalWords:  RGC RGCs dendritic morphologies somata GFP VAChT dataset
 -->
<!--  LocalWords:  soma starburst bistratification monostratified
 -->
<!--  LocalWords:  bistratified misclassified melanopsin arbor voxel
 -->
<!--  LocalWords:  Addtionally contralateral colliculus geniculate
 -->
<!--  LocalWords:  Hoxd10 Sümbül
 -->
