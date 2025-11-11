Class {
	#name : #TMDraftPageGroup,
	#superclass : #TMPageGroup,
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #accessing }
TMDraftPageGroup >> addPagesToTopicMap [
	self validPages isEmpty
		ifTrue: [ self inform: 'There were no valid pages (with kind and topics) to add.'.
			^ false ].
	self validPages
		do: [ :n | 
			n addToTopicMap.
			self removeDraftPageWithTitle: n page title ].
	^ true
]

{ #category : #views }
TMDraftPageGroup >> gtTreeMapFor: aView [
	<gtView>
	^ aView empty
]

{ #category : #printing }
TMDraftPageGroup >> newNodeGroupSelector [
	^ #newDraftPageGroup
]

{ #category : #initialization }
TMDraftPageGroup >> pages: aPageCollection [
	"Wrap the pages as nodes."

	^ self
		nodes: (aPageCollection collect: [ :aPage | TMDraftPageNode for: aPage in: self topicMap ])
]

{ #category : #updating }
TMDraftPageGroup >> removeDraftPageWithTitle: aPageTitle [
	^ self nodes removeAllSuchThat: [ :n | n page title = aPageTitle ]
]

{ #category : #querying }
TMDraftPageGroup >> validPages [
	^ self select: [ :pn | pn kind isNotNil and: [ pn topics isNotEmpty ] ]
]
