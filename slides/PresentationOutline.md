# Learning to detect and track cell in microscopic imaging

## Introduction (get 'em motivated) and Data (understand the difficulty of the problem)

(Tell fake story of Leo asking to annotated datasets)

- 4 months ago I randomly met a man called Dr. Leo, who told me his story:
- His obscure hobby was to look at the inner working of mice
- He had a microscope and he learned everything about how mice work
- When he got bored of mice, he decided to look deeper into the mice... he started looking
  at some of the cells and became interested in how they move
- So at night he stole the laser scanner from the lab, and started taking pictures of these cells.

Since he loves his mice, he didn't want to kill them just to satisfy his curiosity.
So he came up with a complicated setup:
- breed the mice with florescent cells
- Anesthetize the mouse
- open it up, and put a mechanical ventilor to compensate for the dorming lungs
- <...>

- And he took pictures likes this:
	- (some some random picture sequences)
- So he started analyzing how the cells move. 
	- (image with him measuring cell position and filling in a notebook)
- But there were many images... (show pile of images)
- And he gave up... he turned to ask Google for help
- See Google search with 'cell tracker FREE download'
- When he tried it on the images he got messed up trajectories
- What happened? Let's look at the images again
	- Show the problems of disappearing cells, obscuring of them, etc
- So he gave up again... and started looking for someone to delegate his work on...
- and he found me. We are back at the meeting. And he told me his story
- ...since I was a masters' student and since students have nothing to do he
asked me to do the measurements for him. So he gave me some images and his notebooks
('fill it in')
- But I knew this was a trap: if I agree to measure some of his images, he would
come back again in a few weeks, asking for some more.
(Like "friends" want you to fix their computer because it's slow because it full of malware...)

- Since I don't like saying No, I said, I will think about it.

So, I thought about it and decided that it wasn't worth it. But it might be worth
creating some software to solve the tracking problem for everyone in the world
at the same time!!!

- <what were the objectives of the project>

That's how I started reading papers about cell tracking, and I found that Dr Leo
wasn't the only one with the problem. In fact, many people had the same problem,
even if their interests varied:

- some (like Dr. Leo) were obsessed by mice. It seems to be a popular hobby between biologists.
	- some looked at dead mice, some at live ones (like Dr. Leo)
- some were obsessed with knowing how the cells behave in a scratch wound healing assay
- some wanted to know how the cell migrate, how they reproduce (mitosis)
- etc
- Basically, they wanted to further the understanding of mice, and test how different drugs work.


## Related work (why these methods?)

Now, people were solving it in many different ways. Let's split the problem to 2 parts.

First comes the detection of cells:
<...>

Then the tracking:
<...>


Some of these methods tend to work well with very specific types of images.
But might fail in new images. The free software that Dr. Leo found was designed
with a specific type of images in mind -- thats why it didnt work
What I wanted was a combination of algorithms that would work good on many
different types of images, so that everyone in the world would be able to use it.

So, I chose:
<Conditions -> choice>
detector: learning approach by Arteta <why>
tracker: global data association + learning approach <why>

## Detection of cells (robust: learning approach)

Let's look at the detection phase in more detail.

The idea is to train a classifier to detect whether a patch in the image is a cell or not.

So which patches do we evaluate?

- MSER detector to get dozens of candidate patches, configured such that it gets
all of the cells, and a number of background elements
- we are only interested in location, not precise segmentation

- the we train a classifier that votes
- the classifier takes as input a feature vector of the region <add few examples>
- We don't detect overlapping cells. <why>
	- less data required to train the detector <explain>
	- short overlaps can be treated by the tracker
- prefer high recall, over high precision
- benefits: only dot annotation
- testing speed
- show some examples of detected cells (good and bad)
- Show precision and recall values of detector for each dataset
- aside: I build a tool to annotated image sequences

## Tracking of cells (cool: global + learning)

After running the detector on the images we get:
- the locations of the cells
- a feature vector for each cell

- Show 3d example of detections

Now we need a way to combine this detection in sensible cell trajectories

(Skip all the details about the MAP formulation of the problem)

The process we chose consists of two steps:

- Generate short, robust tracklets
- Connect these short, robust tracklets into trajectories

What are short robust tracklets?

- Short tracklets that are very likely to be correct
- we look compare cells that are very close, that have a very similar feature vector.
	- basically we use a classifier to say 'these 2 cell (in consecutive images)'
	  are very similar.
		- symmetric matches
		- very high threshold
		- we use a simple Naive Bayes classifier

- show example of robust tracklet

- then we have to link these robust tracklets into longer trajectories:
- we take into account that some of these robust tracklets could be false positive detection
- we take into account missed detections

- For each tracklet we compute:
	Pinit
	Pterm
	Pfp
- For each candidate tracklet pair we compute the linking likelihood

A trajectory can be:

- fp
- pinit + pterm (short)
- prinit + plink
- plink + pterm
- plink + plink

each of the probabilities has a specific value, which is given by a classifier

Using these constraints, we solve the problems of selecting the optimal subset
of hypothesis using linear programming. 

How do we define the hypothesis likelihoods?

- fpt: in terms of the length
- plink: the value from the classifier
- pinit: 1 - max value from classifier to link to any of the previous 
- pterm: 1 - max value from classifier to link to any future tracklets

How is the classifier for plink trained?

- we use spatio-temporal feautures <expand with few examples>

Limitations:

- Pinit/pterm independend on the status of any of the previous tracklets
- elimintaing this limitation could make the search space very large

Show a brief overiew of tracklets:
- annotations, mapped detections, robust tracklets, trajectories

- Show examples of generated trajectories
- Show examples where it performed great (bad examples as well)

## Conclusion and future work

<return to Dr. Leos story>
1 slides:

- have we achieved our objectives?
- can the results be improved?
- is the method promising?