Class {
	#name : #TMDraftPageGroup,
	#superclass : #TMPageGroup,
	#category : #'GToolkit-Roadmaps'
}

{ #category : #accessing }
TMDraftPageGroup >> addPagesToTopicMap [
	^ self nodes
		do: [ :n | 
			n addToTopicMap.
			self removeDraftPageWithTitle: n page title ]
]

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

{ #category : #updating }
TMDraftPageGroup >> removeDraftPageWithTitle: aPageTitle [
	^ self nodes removeAllSuchThat: [ :n | n page title = aPageTitle ]
]
