Class {
	#name : #TMPageForTopicGroup,
	#superclass : #TMPageGroup,
	#category : #'GToolkit-RoadmapsTEMP-Model'
}

{ #category : #initialization }
TMPageForTopicGroup >> pages: aPageCollection [
	"Wrap the pages as nodes."

	^ self
		nodes: (aPageCollection collect: [ :aPage | TMPageForTopicNode for: aPage in: self topicMap ])
]
