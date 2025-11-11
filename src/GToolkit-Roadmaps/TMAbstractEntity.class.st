"
I am a common superclass for TopicMaps and TopicMap nodes to enable sharing of common behavior, such as spotter searches.
"
Class {
	#name : #TMAbstractEntity,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #testing }
TMAbstractEntity class >> storeOnIsAbstract [
	^ self
		classAndMethodFor: #storeOn:
		do: [ :c :m | m isSubclassResponsibility ]
		ifAbsent: [ true ]
]

{ #category : #'as yet unclassified' }
TMAbstractEntity >> === other [
	"We want === to also work for topic maps"

	^ self = other
]

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

{ #category : #factory }
TMAbstractEntity >> draftPageGroupFor: aPageCollection [
	^ TMDraftPageGroup for: aPageCollection in: self topicMap
]

{ #category : #factory }
TMAbstractEntity >> emptyNodes [
	^ self nodesFor: {}
]

{ #category : #factory }
TMAbstractEntity >> fieldNodeFor: aField [
	^ TMFieldNode for: aField in: self topicMap
]

{ #category : #accessing }
TMAbstractEntity >> fieldNodeNamed: aField [
	^ self fieldNodes detect: [ :n | n field = aField ]
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

{ #category : #'as yet unclassified' }
TMAbstractEntity >> gtStoreStringFor: aView [
	"Work in progress"

	<gtView>
	self storeOnIsAbstract ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Store on';
		priority: 70;
		stencil: [ (GtPharoSnippetCoder new
				forSource: self storeString;
				format;
				subscribeToSystem;
				asExpandedOnlyElement) vFitContentLimited ];
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Do it and go'
			action: [ :button | 
				button phlow
					spawnObject: (Smalltalk compiler evaluate: (String streamContents: [ :s | self storeOn: s ])) ];
		actionUpdateButton
]

{ #category : #views }
TMAbstractEntity >> gtSummaryFor: aView [
	<gtView>
	"self summary ifEmpty: [ ^ aView empty ]."
	^ aView columnedList
		title: 'Summary';
		priority: 20;
		items: [ self summary ];
		actionUpdateButtonTooltip: 'Update item list';
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 60;
		column: 'Key'
			text: #first
			width: 140;
		column: 'Value' text: #second;
		send: #last
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

{ #category : #testing }
TMAbstractEntity >> isTopicMapEntity [
	^ true
]

{ #category : #factory }
TMAbstractEntity >> kindNodeFor: aKind [
	^ TMKindNode for: aKind in: self topicMap
]

{ #category : #querying }
TMAbstractEntity >> kindNodeNamed: aKind [
	^ self kindNodes detect: [ :n | n kind = aKind ]
]

{ #category : #navigation }
TMAbstractEntity >> kindNodes [
	^ self
		nodesFor: (self sortedKinds
				collect: [ :aKind | 
					(self kindNodeFor: aKind)
						pageContext: self pageGroup;
						yourself ])
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

{ #category : #factory }
TMAbstractEntity >> newDraftPageGroup [
	^ TMDraftPageGroup for: {} in: self topicMap
]

{ #category : #factory }
TMAbstractEntity >> newNodeGroup [
	^ TMNodeGroup for: {} in: self topicMap
]

{ #category : #factory }
TMAbstractEntity >> newPageGroup [
	^ TMPageGroup for: {} in: self topicMap
]

{ #category : #factory }
TMAbstractEntity >> nodesFor: aNodeCollection [
	^ TMNodeGroup for: aNodeCollection in: self topicMap
]

{ #category : #navigation }
TMAbstractEntity >> pageGroup [
	^ self pageGroupFor: self pages
]

{ #category : #factory }
TMAbstractEntity >> pageGroupFor: aPageCollection [
	^ TMPageGroup for: aPageCollection in: self topicMap
]

{ #category : #querying }
TMAbstractEntity >> pageNodeWithTitle: aTitle [
	^ self pageNodes detect: [ :pn | pn page title = aTitle ]
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

{ #category : #printing }
TMAbstractEntity >> sizeAndFirstIfAlone: aCollection [
	^ aCollection size printString
		, (aCollection size = 1 ifTrue: [ ' — ' , aCollection first ] ifFalse: [ '' ])
]

{ #category : #accessing }
TMAbstractEntity >> sortedKinds [
	^ self kindsStandardOrder select: [ :k | self kinds includes: k ]
]

{ #category : #printing }
TMAbstractEntity >> storeOn: aStream [
	self subclassResponsibility
]

{ #category : #testing }
TMAbstractEntity >> storeOnIsAbstract [
	^ self class storeOnIsAbstract
]

{ #category : #converting }
TMAbstractEntity >> storeStringValue [
	^ Smalltalk compiler evaluate: self storeString
]

{ #category : #views }
TMAbstractEntity >> summary [
	^ {{'Database'.
			self database.
			self databaseNode}.
		{'#Fields'.
			self sizeAndFirstIfAlone: self fields.
			self fieldNodes}.
		{'#Topics'.
			self sizeAndFirstIfAlone: self topics.
			self topicNodes}.
		{'#Kinds'.
			self sizeAndFirstIfAlone: self kinds.
			self kindNodes}.
		{'#Pages'.
			self sizeAndFirstIfAlone: (self pages collect: #title).
			self pageGroup}}
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

{ #category : #factory }
TMAbstractEntity >> topicNodeFor: aTopic [
	^ TMTopicNode for: aTopic in: self topicMap
]

{ #category : #querying }
TMAbstractEntity >> topicNodeNamed: aTopic [
	^ self topicNodes detect: [ :n | n topic = aTopic ]
]

{ #category : #navigation }
TMAbstractEntity >> topicNodes [
	^ self nodesFor: (self topics collect: [ :aTopic | self topicNodeFor: aTopic ])
]

{ #category : #navigation }
TMAbstractEntity >> topics [
	self subclassResponsibility
]
