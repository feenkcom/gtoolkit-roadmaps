Class {
	#name : #TMDraftPageGroup,
	#superclass : #TMPageGroup,
	#category : #'GToolkit-Roadmaps'
}

{ #category : #views }
TMDraftPageGroup >> gtTreeMapFor: aView [
	<gtView>
	^ aView empty
]

{ #category : #initialization }
TMDraftPageGroup >> pages: aPageCollection [
	"Wrap the pages as nodes."

	^ self
		nodes: (aPageCollection collect: [ :aPage | TMDraftPageNode for: aPage in: self topicMap ])
]
