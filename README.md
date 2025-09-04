# README

The repo provides a set of roadmaps through the GT Book, breaking the pages into a number of topic areas, in several fields or domains of discourse (eg GT basics, Working with External Systems etc). 
Furthermore, each page is categorized into one of several styles of content (Introduction, Tutorial, FAQ etc).
Newly added pages can be categorized with the help of a generative AI assistant.
## Installation

```st
Metacello new
	repository: 'github://feenkcom/gtoolkit-roadmaps:main/src';
	baseline: 'GtoolkitRoadmaps';
	load.
#BaselineOfGtoolkitRoadmaps asClass loadLepiter
```
