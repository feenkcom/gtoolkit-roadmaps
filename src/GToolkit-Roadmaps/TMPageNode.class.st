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

{ #category : #breadcrumbs }
TMPageNode >> breadcrumb [
	"Only if the topic of the previous roadmap's breadcrumb matches this page,
	do we have a context for building a new breadcrumb."

	^ (self pathContext topicNode notNil
		and: [ self topicNodes includes: self pathContext topicNode ])
		ifTrue: [ TMBreadcrumb
				for: {self pathContext databaseNode.
						self pathContext fieldNode.
						self pathContext topicNode.
						self kindNode.
						self} ]
		ifFalse: [ TMBreadcrumb for: {} ]
]

{ #category : #navigation }
TMPageNode >> children [
	^ self emptyNodes
]

{ #category : #mondrian }
TMPageNode >> defaultNodeColor [
	^ Color paleOrange
]

{ #category : #breadcrumbs }
TMPageNode >> defaultPathContext [
	"If a context is not explicitly provided, we can assume nothing for page nodes."

	^ TMBreadcrumb for: {}
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
						self updateKindTo: each.
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
						self toggleTopic: each.
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

{ #category : #accessing }
TMPageNode >> kindNode [
	self assert: self kindNodes size equals: 1.
	^ self kindNodes first
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
	^ self kind = self topicMap defaultValue
		ifTrue: [ {} ]
		ifFalse: [ {self kind} ]
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

{ #category : #navigation }
TMPageNode >> roadmapParents [
	"In the case of page nodes, for the mondrian roadmap,
	we want to connect to the kind nodes, not the topic nodes."

	^ self kindNodes
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

{ #category : #views }
TMPageNode >> toggleTopic: aTopicString [
	self topicMap updateTopicsForPage: self to: (self topicsToggling: aTopicString)
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
TMPageNode >> topicsToggling: aTopicString [
	^ (self topics includes: aTopicString)
		ifTrue: [ self topics copyWithout: aTopicString ]
		ifFalse: [ self topics copyWith: aTopicString ]
]

{ #category : #updating }
TMPageNode >> updateKindTo: aKindString [
	self topicMap updateKindForPage: self to: aKindString
]

{ #category : #accessing }
TMPageNode >> viaTopic [
	"NB: can be nil or a specific topic."

	^ viaTopic
]

{ #category : #accessing }
TMPageNode >> viaTopic: aTopicNode [
	viaTopic := aTopicNode
]

{ #category : #accessing }
TMPageNode >> withoutViaTopic [
	^ self class for: self page in: self topicMap
]
