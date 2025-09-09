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
		, self styleNodes first nodeLabel , String cr , self nodeLabel
]

{ #category : #navigation }
TMPageNode >> children [
	^ self emptyNodes
]

{ #category : #mondrian }
TMPageNode >> defaultNodeColor [
	^ self stylePalette at: self style
]

{ #category : #navigation }
TMPageNode >> fields [
	^ (self topicNodes nodes flatCollect: #fields) copyWithoutDuplicates
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
TMPageNode >> gtTreeFor: aView [
	"For a page we want to dive into the topics associated with that page."

	<gtView>
	^ aView columnedTree
		title: 'Topic Map';
		priority: 10;
		items: [ self topicNodes ];
		children: #children;
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Node'
			text: [ :each | each nodeLabel ]
			width: 300;
		column: '# Children'
			text: [ :each | each children size ]
			width: 100;
		column: '# Pages'
			text: [ :each | each pages size ]
			width: 100;
		column: '# Styles'
			text: [ :each | each styles size ]
			width: 100;
		column: 'Info'
			text: [ :each | each relatedInfo ]
			width: 300;
		send: [ :each | each ];
		actionUpdateButton
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

{ #category : #accessing }
TMPageNode >> nodeLabel [
	^ 'Page: ', self page title
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
TMPageNode >> parentsWithStyle [
	^ self styleNodes
]

{ #category : #accessing }
TMPageNode >> relatedInfo [
	^ 'Style:', self style
]

{ #category : #accessing }
TMPageNode >> relatedTitle [
	^ 'Style'
]

{ #category : #roadmap }
TMPageNode >> roadmapNodeElement [
	"Add a hover previewing the page."

	| elt |
	elt := super roadmapNodeElement.
	elt aptitude: (self page hoverPage: self page forNodeElement: elt).
	^ elt
]

{ #category : #roadmap }
TMPageNode >> roadmapNodes [
	| pageNodeWithAllTopics |
	pageNodeWithAllTopics := self withoutViaTopic.
	^ self databaseNode roadmapNodes , pageNodeWithAllTopics parents
		, {pageNodeWithAllTopics}
]

{ #category : #roadmap }
TMPageNode >> roadmapSimpleNodeElement [
	^ super roadmapSimpleNodeElement
		geometry: BlCircleGeometry new;
		yourself
]

{ #category : #roadmap }
TMPageNode >> roadmapWithStyleNodes [
	| pageNodeWithAllTopics |
	pageNodeWithAllTopics := self withoutViaTopic.
	^ self databaseNode roadmapWithStyleNodes , pageNodeWithAllTopics parents
		, pageNodeWithAllTopics styleNodes , {pageNodeWithAllTopics}
]

{ #category : #accessing }
TMPageNode >> style [
	^ self topicMap style4Page: self page
]

{ #category : #navigation }
TMPageNode >> styles [
	^ {self style}
]

{ #category : #querying }
TMPageNode >> topics [
	^ self topicMap topics4Page: self page
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
