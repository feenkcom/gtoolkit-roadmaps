Class {
	#name : #TMPageForTopicGroup,
	#superclass : #TMPageGroup,
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #initialization }
TMPageForTopicGroup >> pages: aPageCollection [
	"Wrap the pages as nodes."

	^ self
		nodes: (aPageCollection collect: [ :aPage | TMPageNode for: aPage in: self topicMap ])
]
