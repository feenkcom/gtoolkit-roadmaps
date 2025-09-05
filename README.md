# README

NB: This is *work in progress*.

The repo provides a set of roadmaps through the GT Book, breaking the pages into a number of topic areas, in several fields or domains of discourse (eg GT basics, Working with External Systems etc). 
Furthermore, each page is categorized into one of several styles of content (Introduction, Tutorial, FAQ etc).
Newly added pages can be categorized with the help of a generative AI assistant.

To explore the current state of the topic maps and roadmaps, inspect:

```st
LeDatabase gtBook topicMap
```

## Installation

This repo is installed in GT by default. The following is not needed in a standard image:

```st
Metacello new
	repository: 'github://feenkcom/gtoolkit-roadmaps:main/src';
	baseline: 'GtoolkitRoadmaps';
	load.
```

To load the Lepiter database documenting experiments and the current implementation state, evaluate:

```st
#BaselineOfGtoolkitRoadmaps asClass loadLepiter
```
