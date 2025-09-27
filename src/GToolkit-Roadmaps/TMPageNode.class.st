Class {
	#name : #TMPageNode,
	#superclass : #TMAbstractTreeNode,
	#instVars : [
		'page',
		'viaTopic'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMPageNode class >> for: aPage [
	"This version forces the registered topic map associated
	with the page to be used, rather than a test example."

	^ self new
		page: aPage;
		topicMap: aPage topicMap;
		yourself
]

{ #category : #'instance creation' }
TMPageNode class >> for: aPage in: aTopicMap [
	"Use this for testing if the topic map to use is not necessarily
	the default one, but a special test map."

	^ self new
		page: aPage;
		topicMap: aTopicMap;
		yourself
]

{ #category : #comparing }
TMPageNode >> = other [
	^ super = other and: [ self viaTopic = other viaTopic ]
]

{ #category : #mondrian }
TMPageNode >> breadcrumb [
	"NB: This will show only *one* of the paths!
	If there are multiple topics, only the last one will be shown."

	"^ self treeMapPath"

	^ (String cr join: (self parents collect: #breadcrumb)) , String cr
		, self kindNodes first nodeLabel , String cr , self nodeLabel
]

{ #category : #navigation }
TMPageNode >> children [
	^ self emptyNodes
]

{ #category : #mondrian }
TMPageNode >> defaultNodeColor [
	^ Color paleOrange
]

{ #category : #navigation }
TMPageNode >> fields [
	^ (self topicNodes nodes flatCollect: #fields) copyWithoutDuplicates
]

{ #category : #views }
TMPageNode >> gtEditKindFor: aView [
	"NB: This view will be updated, but the others will need to be explicitly refreshed."

	<gtView>
	^ aView columnedList
		title: 'Edit kind';
		priority: 50;
		items: [ self kindsStandardOrder ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Kind'
			text: [ :each | each gtDisplayString ]
			width: 200;
		column: ''
			stencil: [ :each | 
				| checkbox |
				checkbox := BrCheckbox new aptitude: BrGlamorousCheckboxAptitude.
				self kind = each ifTrue: [ checkbox check ].
				checkbox
					action: [ :aButton :aTab | 
						self topicMap updateKindForPage: self to: each.	"checkbox phlow fireToolUpdateWish."
						checkbox phlow fireViewUpdateWish ].
				checkbox ];
		send: [ :each | self kindNodeFor: each ];
		actionUpdateButton
]

{ #category : #views }
TMPageNode >> gtEditTopicsFor: aView [
	"NB: This view will be updated, but the others will need to be explicitly refreshed."

	<gtView>
	^ aView columnedList
		title: 'Edit topics';
		priority: 52;
		items: [ self topicMap topics sorted ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Kind'
			text: [ :each | each gtDisplayString ]
			width: 300;
		column: ''
			stencil: [ :each | 
				| checkbox |
				checkbox := BrCheckbox new aptitude: BrGlamorousCheckboxAptitude.
				(self topics includes: each) ifTrue: [ checkbox check ].
				checkbox
					action: [ :aButton :aTab | 
						self topicMap updateTopicsForPage: self to: (self topicsToggling: each).
						checkbox phlow fireViewUpdateWish ].
				checkbox ];
		send: [ :each | self topicNodeFor: each ];
		actionUpdateButton
]

{ #category : #views }
TMPageNode >> gtLivePageFor: aView [
	<gtView>
	^ aView forward
		title: 'Page';
		priority: 30;
		object: [ self page ];
		view: #gtLiveFor:
]

{ #category : #actions }
TMPageNode >> gtSpawnPageActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Spawn page';
		priority: 20;
		icon: LeIcons lepiterIcon;
		action: [ :aButton | aButton phlow spawnObject: self page ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: self page ]
			mouseCursor: BlCopyCursor new
]

{ #category : #views }
TMPageNode >> gtTreeMapFor: aView [
	<gtView>
	^ aView empty
]

{ #category : #comparing }
TMPageNode >> hash [
	^ super hash bitXor: self viaTopic hash
]

{ #category : #help }
TMPageNode >> helpPageName [
	^ 'TopicMap Page'
]

{ #category : #testing }
TMPageNode >> isTMPageNode [
	^ true
]

{ #category : #accessing }
TMPageNode >> kind [
	^ self topicMap kind4Page: self page
]

{ #category : #updating }
TMPageNode >> kindUpdateElement [
	"Experimental -- need a way to change the kind.
	Perhaps better would be a view listing the kinds with a checkbox for the selected kind."

	| menu kindLabel kindValueLabel |
	kindLabel := BrLabel new
			text: 'Kind:';
			aptitude: BrGlamorousLabelAptitude new italic;
			yourself.
	kindValueLabel := BrLabel new
			text: self kind;
			aptitude: BrGlamorousLabelAptitude new;
			yourself.
	menu := BrMenuItems new.
	self kindsStandardOrder
		do: [ :aKind | 
			menu
				addItemLabel: aKind
				action: [ self topicMap updateKindForPage: self to: aKind.
					kindValueLabel text: self kind ] ].
	kindValueLabel
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude new
				stencil: [ :aContext | BrMenuExplicitHandle new menu: menu ]).
	^ BrHorizontalPane new
		fitContent;
		cellSpacing: 5;
		addChildren: {kindLabel.
				kindValueLabel};
		yourself
]

{ #category : #navigation }
TMPageNode >> kinds [
	^ {self kind}
]

{ #category : #accessing }
TMPageNode >> nodeLabel [
	^ self title
]

{ #category : #accessing }
TMPageNode >> nodeType [
	^ 'Page'
]

{ #category : #accessing }
TMPageNode >> page [
	^ page
]

{ #category : #accessing }
TMPageNode >> page: aPage [
	page := aPage
]

{ #category : #navigation }
TMPageNode >> pages [
	^ {self page}
]

{ #category : #navigation }
TMPageNode >> parents [
	^ self viaTopic
		ifNil: [ self topicNodes ]
		ifNotNil: [ self nodesFor: {self viaTopic} ]
]

{ #category : #navigation }
TMPageNode >> parentsWithKind [
	^ self kindNodes
]

{ #category : #accessing }
TMPageNode >> relatedInfo [
	^ 'Kind: ' , self kind
]

{ #category : #accessing }
TMPageNode >> relatedTitle [
	^ 'Kind'
]

{ #category : #mondrian }
TMPageNode >> roadmapNodeColor [
	^ self kindPalette at: self kind ifAbsent: self defaultNodeColor
]

{ #category : #roadmap }
TMPageNode >> roadmapNodeElement [
	"Add a hover previewing the page."

	| elt |
	elt := super roadmapNodeElement.
	elt aptitude: (self page hoverPage: self page forNodeElement: elt).
	elt geometry: (BlRoundedRectangleGeometry cornerRadius: 0).
	^ elt
]

{ #category : #roadmap }
TMPageNode >> roadmapNodes [
	"page in topic (or unique t): db -> fields -> p.t.f.topics -> p.t.pages
	page (multiple topics): db -> fields -> p.topics -> p"

	self topicNodes size = 1 ifTrue: [ self viaTopic: self topicNodes first ].
	^ self viaTopic
		ifNil: [ self roadmapNodesWithAllTopics ]
		ifNotNil: [ self roadmapNodesViaParentTopic ]
]

{ #category : #roadmap }
TMPageNode >> roadmapNodesViaParentTopic [
	"page in topic (or unique t): db -> fields -> p.t.f.topics -> p.t.pages"

	| roadmapNodes |
	self assert: self viaTopic isNotNil.
	roadmapNodes := self viaTopic roadmapNodes.
	roadmapNodes
		do: [ :n | 
			n = self ifTrue: [ n highlightOn ].
			n = self kindNodes first ifTrue: [ n highlightOn ] ].
	^ roadmapNodes
]

{ #category : #roadmap }
TMPageNode >> roadmapNodesWithAllTopics [
	"page (multiple topics): db -> fields -> p.topics -> p"

	| roadmapNodes |
	self assert: self viaTopic isNil.
	self highlightOn.
	roadmapNodes := self databaseNode roadmapNodes , self parents , self kindNodes
			, {self}.
	^ roadmapNodes
]

{ #category : #roadmap }
TMPageNode >> roadmapSimpleNodeElement [
	^ super roadmapSimpleNodeElement
		geometry: BlCircleGeometry new;
		yourself
]

{ #category : #accessing }
TMPageNode >> title [
	^ self page title
]

{ #category : #navigation }
TMPageNode >> topicTreeChildren [
	^ self topicNodes
]

{ #category : #querying }
TMPageNode >> topics [
	^ self topicMap topics4Page: self page
]

{ #category : #upd }
TMPageNode >> topicsToggling: aTopic [
	^ (self topics includes: aTopic)
		ifTrue: [ self topics copyWithout: aTopic ]
		ifFalse: [ self topics copyWith: aTopic ]
]

{ #category : #accessing }
TMPageNode >> viaTopic [
	"NB: can be nil or a specific topic."

	^ viaTopic
]

{ #category : #accessing }
TMPageNode >> viaTopic: anObject [
	viaTopic := anObject
]

{ #category : #accessing }
TMPageNode >> withoutViaTopic [
	^ self class for: self page in: self topicMap
]
