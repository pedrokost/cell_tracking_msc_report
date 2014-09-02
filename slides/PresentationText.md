TODO: after each part, summarize what you just said!!!

Hello everybody!

My name is Pedro Kostelec and in this presentation I am going to present you the work I've been working on in the past 4 months. Throughout the project I have been supervised by professor Ben Glocker, and working in collaboration with Dr. Leo Carlin.

Let me start by telling you a fictional story.

4 months ago I met a scientist called Dr. Leo. Today, he's a researcher at the National Lung and Hurt Institute, but this wasn't always the case. 

NEXT SLIDE -- rat curiosity

When he was a child, Dr. Leo had an obscure hobby: he was obsessed with the study of mice. He spent many nights awake observing the rodents, watching them run, and drawing sketches of their limbs, head and body. As the years went by, he started studying their internal organs, observing for example how food was progressing from the mouth, through the stomach, the intenstine as forth.

As more years went by, Dr. Leo became an expert on mice. He knew everything about their behavior, the working of their internal organs, etc. When he started becoming bored of all that, his curiosity drew him deeper, and he started observing the cells moving through the blood? network.

NEXT SLIDE -- sneaking into lab

One night, he sneaked into the lab and stole a laser scanner (TODO) and started taking pictures of the cells, especially those near the lung and liver. You might be wondering by now, how many of these rodents had been sacrificed to satisfy his curiosity. When I asked him this question, he smiled and showed me the process he uses to acquire the images.

First of all, certain cells in his mice were marked with a fluorescent reporter that the mouse had been genetically modified to produce just in specific type of immune cells. Before starting the procedure, the mouse is anesthetized. A mechanical ventilator is used to compensate for the dorming lungs and the surface of the lung is exposed surgically. Then a specialized “vacuum chamber” is used to stably hold a glass coverslip against the surface of the lung. The alveoli, capillaries and cells can then be visualized by laser scanning confocal microscopy.

The same apparatus can be used to interrogate other organs without mechanical
ventilation, e.g. the liver.

This complicated system, put in place to facilitate the "reuse" of mice, is able to produce images that look like this:

NEXT SLIDE -- brief images

- show 2 short sequences of cells


NEXT SLIDE -- manual meausurments

Dr. Leo wanted to know how these cells move and why the mouse needs them in the first place. Somewhere he learned that these specific cells, called neutrophils, are part of the immuno-defensive system, and reduce inflammation. A reduction in their number could dangerously harm or even kill the mice. Since they appeared to be so important, he started quantifying their behavior by manually measuring their displacement.

NEXT SLIDE -- google

As you can imagine, this became very boring very quickly as the number of images never seemed to lower. So, he turned to Google for help and he found some software too help him do the tracking of cells.

NEXT SLIDE -- bad results

But the results he got were unsatisfying. Why? Let us look at the image sequences again.

NEXT SLIDE -- difficult image sequences

- TODO: show a few difficulties with the image sequences

Briefly, the software wasn't designed to track cells in images with these kind of artefacts.

So Dr. Leo gave up on the software, and started looking for a postgraduate student to delegate the boring, manual work of measuring how the cells move, while he could focus on more important parts of his research.

By now you should understand the problem I tried to solve and what are some difficulties we need to overcome.

NEXT SLIDE -- meeting

Unlucky me, I was the first student he came across. So we are back to the day we first met and he just finished telling me his story. Because I was a postgraduate student (and since students have nothing better to do) he asked me to the the manual work for him.

NEXT SLIDE -- world saviour

I knew this was a trap. If I agreed to analyze some of his images, sooner or later he would come back and ask me for more. But I didn't want to say "No", and so I got an idea. What if I developed some software that would solve the problem of cell tracking for every cell researcher in the world?

NEXT SLIDE -- many people looking at rats

So, I started reading a lot about cell tracking, and discovered that large industries would greatly benefit from a good, reliable cell tracking method. The amount of humans obsessed with observing mice is staggering. Some are watching dead mice, some mice that were alive. Some are interested in testing how different drugs affect their growth, others how drugs can speed up the healing of wounds, and then there are some, like our Dr. Leo, who observe rats to satisfy their cursiosity.

NEXT SLIDE -- goals

So I setup some goals for the project. I would aim to create a cell tracking method that would be able to track cells in low quality microscopic images like the ones we saw before. 

Now, people were trying to solve the problem of cell tracking in many different ways. Let us split the the problem into 2 parts: cell detections, and tracking.
HALF TIME

NEXT SLIDE -- detection methods

A simple approach to cell segmentation consists of thresholding an image, and segmenting it using a Watershed algorithm. 

The level set/active contour approach is to segment cells by minimizing an energy function incorporating factors such as image gradient and intensity homogeneity within the cell.

The model learning approach attempts to learn the signature of a cell by analyzing a broad set of computed appearance features. This method requires learning the model from annotated examples. We have utilized this method in our system for its ability to adapt to different types of cells. We will discuss it in more detail soon.

NEXT SLIDE -- tracking methods

Once we identify the cells, we are interested in connecting the detections into coherent trajectories. We can also find many different approaches to this problem.

First, after using a level set (or active contour) method we could evolve the model to match the cells in the next frame. This process is likely to perform poorly in our example where some frames are out of focus.

Another, basic technique is frame-by-frame data association. In this approach we compare cells between two consecutive frames and connect pairs of matching cells based on their appearance. 

An upgraded method would also take into account some spatial and temporal characteristics of the trajectories, for example by using a Particle or Kalman filter.

While this approach is great, we have instead opted for a global data association approach. Briefly, this approach consists of aggregating the results of all the frames, and using a global optimization method that maximizes the correctness of linking cells. We will look at this method in depth a bit later.

We finished reviewing previous work, and now we will present in more detail the developed system.

NEXT SLIDE -- detection system

OK, so let me now explain in detail the system developed to track cells. First let's look at the cell detection module. The idea is to train a classifier to detect whether a patch in the image is a cell or not.

The method works on each image individually. First, we extract a set of candidate regions using a Maximally Stable Extremal Region detector. This extracts all the regions that contain cells as well as a good number of regions that contain noise. 
Second, a classifier scores each candidate region with respect to the similarity that the region looks like a cell.
And third, we select on optimal subset of non-overlapping regions.

Why non-overlapping regions? In short, detecting cells in overlapping regions would require training the model with a much larger set of annotated images. Furthermore, brief overlaps can be treated by the cell tracker method.

The method only requires dot annotation on cells to train the image. A single dot needs to be placed within the cell region.

NEXT SLIDE -- detection results

The system is able to detect cell in images of dimensions about 400-by-400 between 0.5 and 1.5 and achieves good recall and precision values.

To conclude, the cell detector first extracts a set of candidate regions, and then selects the ones that are most similar to a cell.

NEXT SLIDE -- tracking system overiew

So now we need to link these cells detections into trajectories. The process is two step. First, we use frame-by-frame data association to connect cells that can be linked with high confidence. Second, these robust tracklets are linked together to form trajectories.

16
NEXT SLIDE -- robust tracklets

How do we obtain the robust tracklets? We trained a classifier that scores the similarity of each pair of tracklets between consecutive frames. In this classifier we reuse the feature vector computed by the detection module. Then, we select only pairs of cells that symmetrically match. This means that a cell from frame A is most similar to cell from frame B, and the cell from frame B is also most similar to cell A in the previous frame. Additionally, we only select matches if the match score is above a high threshold.

NEXT SLIDE -- linking hypothesis

The next step consists of linking these robust tracklets to form trajectories.

We observe that for each tracklet and tracklet pair we have four possible scenarios to consider:
- the tracklet might be a false positive, and needs to be discarded
- a tracklet can be connected to some other tracklet before or after
- a tracklet can be the first part of a long trajectory
- or it can be the last part of a long trajectory

So we define these possible scenarios as constraints, and compute a score that determine how likely each scenario is.

NEXT SLIDE -- linking classifier

The likelihood of linking a pair of tracklets is based on another classifier that learns to link tracks that can be several number of frames apart. This classifier is trained based on appearance, spatial and temporal features such as the euclidean distance between the tail of the first tracklet and the head of a following tracklet, the directional difference, the difference in displacement speed, and more...

NEXT SLIDE -- hypothesis likelihood

The initialization and termination likelihoods are based on the linking likelihoods.

Specifically, the initializzation likihoods are equal to 1-max( likelihoods of linking the tracklet to any of the previous tracklets )  and the termination likelihood to 1 - max( of the likelihoods of linking this tracklet to any of the future tracklets ).

After computing all the likelihoods, we use linear programming to select a subset of hypothesis that maximizes tthe complete log likelihood, subject to the constraint that we cannot select conflicting hypothesis (for example, we cannot say that a tracklet is both false positive and linked to another tracklet).

So this was a brief overiew of the the cell tracker module. First we generate robust tracklets, and the we link these robust tracklets into trajectories.

NEXT SLIDE -- will it work?

Let's return to our initial fictional story. Our character, Dr. Leo, is probably wondering wheter all this science will help him at all. Let's look at some examples. 

NEXT SLIDE -- results

The first plot contains the manual annotations that were used to evaluate the tracker. The middle plot contains the robust tracklets that were identified from the detection results. Finally, the third plot contains the genrated trajectories.

TODO: point out some interesting parts

Here is another example

TODO: show some interesting parts...

The system works quite well on the tested datasets that were provided by Dr. Leo. The method has shown that is is indeed quite promising. However, before I can say that I saved the problem of cell tracking for all the cell scientist in the world I would like to point out that the system could be improved in several ways. 

First, a broader range of spatio-temporal features could be implementated and tested.

Second, a pre-processing step that would stabilize the images, especially in the datasets affected by the motion of the mechanical ventilator would likely improve the results by simplifying the spatio-temporal feature computation process and result in smoother cell trajectories.

Finally, some additional research should be put in the treatment of very short robust tracklets. The number of robust tracklets of length 1 is significant. In our measurments, we have observed slightly improved results when we discarded these tracklets. However, these short tracklets could be used in several ways to improve the quality of the generated trajectories.

With this, I would like to finish presentation, and give my thanks to all of you who cared enough to come listen to me today, especially to my supervisor Ben Glocker for the continuous feedback throughout these past months.

I am now open for question.