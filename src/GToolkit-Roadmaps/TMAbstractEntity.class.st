"
I am a common superclass for TopicMaps and TopicMap nodes to enable sharing of common behavior, such as spotter searches.
"
Class {
	#name : #TMAbstractEntity,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #abstract }
TMAbstractEntity >> database [
	self subclassResponsibility
]

{ #category : #abstract }
TMAbstractEntity >> databaseNode [
	self subclassResponsibility
]

{ #category : #utility }
TMAbstractEntity >> emptyNodes [
	^ self nodesFor: {}
]

{ #category : #abstract }
TMAbstractEntity >> fields [
	self subclassResponsibility
]

{ #category : #searching }
TMAbstractEntity >> gtSpotterForPageContent: aSearch [
	<gtSearch>
	^ aSearch list
		title: 'Page content';
		priority: 25;
		items: [ self pages ];
		itemsLimit: Float infinity;
		itemName: #asMarkdownPage;
		sendCategory: [ :aCategory :aStep :thisSearch | 
			(self pageGroupFor: aCategory items contents)
				queryString: aStep searchQuery;
				yourself ];
		filterBySubstring
]

{ #category : #searching }
TMAbstractEntity >> gtSpotterForPageTitles: aSearch [
	<gtSearch>
	^ aSearch list
		title: 'Page titles';
		priority: 20;
		items: [ self pages ];
		itemsLimit: Float infinity;
		itemName: #title;
		sendCategory: [ :aCategory :aStep :thisSearch | 
			(self pageGroupFor: aCategory items contents)
				queryString: aStep searchQuery;
				yourself ];
		filterBySubstring
]

{ #category : #testing }
TMAbstractEntity >> isAbstract [
	^ self == TMAbstractEntity
]

{ #category : #utility }
TMAbstractEntity >> nodesFor: aNodeCollection [
	^ TMNodeGroup for: aNodeCollection in: self topicMap
]

{ #category : #navigation }
TMAbstractEntity >> pageGroup [
	^ self pageGroupFor: self pages
]

{ #category : #utility }
TMAbstractEntity >> pageGroupFor: aPageCollection [
	^ TMPageGroup for: aPageCollection in: self topicMap
]

{ #category : #abstract }
TMAbstractEntity >> pages [
	self subclassResponsibility
]

{ #category : #abstract }
TMAbstractEntity >> styles [
	self subclassResponsibility
]

{ #category : #querying }
TMAbstractEntity >> stylesStandardOrder [
	^ self topicMap stylesStandardOrder
]

{ #category : #abstract }
TMAbstractEntity >> topicMap [
	self subclassResponsibility
]

{ #category : #navigation }
TMAbstractEntity >> topics [
	self subclassResponsibility
]
