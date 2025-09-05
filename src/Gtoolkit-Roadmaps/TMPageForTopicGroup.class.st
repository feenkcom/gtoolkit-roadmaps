Class {
	#name : #TMPageForTopicGroup,
	#superclass : #TMPageGroup,
	#category : #'Gtoolkit-Roadmaps-Model'
}

{ #category : #initialization }
TMPageForTopicGroup >> pages: aPageCollection [
	"Wrap the pages as nodes."

	^ self
		nodes: (aPageCollection collect: [ :aPage | TMPageForTopicNode for: aPage in: self topicMap ])
]
