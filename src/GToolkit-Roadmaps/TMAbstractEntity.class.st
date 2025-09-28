"
I am a common superclass for TopicMaps and TopicMap nodes to enable sharing of common behavior, such as spotter searches.
"
Class {
	#name : #TMAbstractEntity,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #converting }
TMAbstractEntity >> asElement [
	^ self roadmap
]

{ #category : #querying }
TMAbstractEntity >> contentIncludes: query [
	^ (self
		pageGroupFor: (self pages select: [ :p | p asMarkdownPage includesSubstring: query ]))
		queryString: query;
		yourself
]

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

{ #category : #utility }
TMAbstractEntity >> fieldNodeFor: aField [
	^ TMFieldNode for: aField in: self topicMap
]

{ #category : #navigation }
TMAbstractEntity >> fieldNodes [
	^ self nodesFor: (self fields collect: [ :aField | self fieldNodeFor: aField ])
]

{ #category : #abstract }
TMAbstractEntity >> fields [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
TMAbstractEntity >> gtHelpPageActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Help';
		priority: 45;
		icon: BrGlamorousVectorIcons help;
		action: [ :aButton | aButton phlow spawnObject: self helpPage ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: self helpPage ]
			mouseCursor: BlCopyCursor new
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
		sendCategory: [ :aCategory :aStep :thisSearch | self contentIncludes: aStep searchQuery ];
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
		sendCategory: [ :aCategory :aStep :thisSearch | self titleIncludes: aStep searchQuery ];
		filterBySubstring
]

{ #category : #help }
TMAbstractEntity >> helpDatabase [
	^ TMHelpDatabase database
]

{ #category : #help }
TMAbstractEntity >> helpPage [
	^ self helpDatabase pageNamed: self helpPageName
]

{ #category : #help }
TMAbstractEntity >> helpPageName [
	"Override in subclasses"

	^ self helpPageNameDefault
]

{ #category : #help }
TMAbstractEntity >> helpPageNameDefault [
	^ 'Topic Roadmap'
]

{ #category : #testing }
TMAbstractEntity >> isAbstract [
	^ self == TMAbstractEntity
]

{ #category : #utility }
TMAbstractEntity >> kindNodeFor: aKind [
	^ TMKindNode for: aKind in: self topicMap
]

{ #category : #navigation }
TMAbstractEntity >> kindNodes [
	^ self
		nodesFor: (self kinds
				collect: [ :aKind | 
					TMKindNode
						for: aKind
						in: self topicMap
						within: self pageGroup ])
]

{ #category : #treemaps }
TMAbstractEntity >> kindPalette [
	^ {'Introduction' -> Color red muchLighter.
		'Media' -> Color green lighter.
		'Tutorial' -> Color blue muchLighter.
		'Case study' -> Color purple muchLighter.
		'Pattern' -> Color orange.
		'FAQ' -> Color paleYellow.
		'Examples' -> Color lightRed.
		'Documentation' -> Color paleBlue.
		'Definition' -> Color veryVeryLightGray.
		'Index' -> Color veryLightGray.
		'Tag' -> Color lightGray} asDictionary
]

{ #category : #abstract }
TMAbstractEntity >> kinds [
	self subclassResponsibility
]

{ #category : #querying }
TMAbstractEntity >> kindsStandardOrder [
	^ self topicMap kindsStandardOrder
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

{ #category : #navigation }
TMAbstractEntity >> pageNodes [
	"Alias for convenience."

	^ self pageGroup
]

{ #category : #abstract }
TMAbstractEntity >> pages [
	"NB: These are the actual LePage instances, not TMPageNode instances."

	self subclassResponsibility
]

{ #category : #abstract }
TMAbstractEntity >> roadmap [
	self subclassResponsibility
]

{ #category : #querying }
TMAbstractEntity >> titleIncludes: query [
	^ (self
		pageGroupFor: (self pages select: [ :p | p title includesSubstring: query ]))
		queryString: query;
		yourself
]

{ #category : #abstract }
TMAbstractEntity >> topicMap [
	self subclassResponsibility
]

{ #category : #utility }
TMAbstractEntity >> topicNodeFor: aTopic [
	^ TMTopicNode for: aTopic in: self topicMap
]

{ #category : #navigation }
TMAbstractEntity >> topicNodes [
	^ self nodesFor: (self topics collect: [ :aTopic | self topicNodeFor: aTopic ])
]

{ #category : #navigation }
TMAbstractEntity >> topics [
	self subclassResponsibility
]
