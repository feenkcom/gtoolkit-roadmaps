"
I am an abstract parent for trees of Topic Map nodes representing pages, topics, fields, and styles.

I support navigation via dedicated views of page groups.
"
Class {
	#name : #TMAbstractTreeNode,
	#superclass : #TMAbstractEntity,
	#instVars : [
		'topicMap',
		'isHighlighted',
		'pathContext'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMAbstractTreeNode class >> for: anObject in: aTopicMap [
	"All subclasses implement at least this API, and possibly others."

	self subclassResponsibility
]

{ #category : #comparing }
TMAbstractTreeNode >> = other [
	self == other ifTrue: [ ^ true ].
	self class = other class ifFalse: [^ false ].
	^ self nodeLabel = other nodeLabel
]

{ #category : #roadmap }
TMAbstractTreeNode >> allChildren [
	| allChildren |
	allChildren := OrderedCollection withAll: self children.
	self children do: [ :each | allChildren addAll: each allChildren ].
	^ allChildren copyWithoutDuplicates
]

{ #category : #roadmap }
TMAbstractTreeNode >> allParents [
	| allParents |
	allParents := OrderedCollection withAll: self parents.
	self parents do: [ :each | allParents addAll: each allParents ].
	^ allParents copyWithoutDuplicates
]

{ #category : #breadcrumbs }
TMAbstractTreeNode >> breadcrumb [
	self subclassResponsibility
]

{ #category : #navigation }
TMAbstractTreeNode >> children [
	self subclassResponsibility
]

{ #category : #navigation }
TMAbstractTreeNode >> database [
	^ self topicMap database
]

{ #category : #navigation }
TMAbstractTreeNode >> databaseNode [
	^ self topicMap databaseNode
		"pathContext: self breadcrumb;"
		yourself
]

{ #category : #breadcrumbs }
TMAbstractTreeNode >> defaultBreadcrumb [
	^ self topicMap defaultBreadcrumb
]

{ #category : #treemaps }
TMAbstractTreeNode >> defaultNodeColor [
	"Can be used for treemaps, mondrian graphs, sceneries etc."

	^ Color gray
]

{ #category : #breadcrumbs }
TMAbstractTreeNode >> defaultPathContext [
	^ self defaultBreadcrumb
]

{ #category : #actions }
TMAbstractTreeNode >> gtPageGroupActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Inspect pages';
		priority: 30;
		icon: BrGlamorousVectorIcons changes;
		action: [ :aButton | aButton phlow spawnObject: self pageGroup ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: self pageGroup ]
			mouseCursor: BlCopyCursor new
]

{ #category : #views }
TMAbstractTreeNode >> gtRoadmap: aView [
	<gtView>
	^ aView forward
		title: 'Roadmap';
		priority: 10;
		object: [ self roadmap ];
		view: #gtLiveFor:;
		actionButtonIcon: BrGlamorousVectorIcons changes
			tooltip: 'Inspect  pages'
			action: [ :aButton :aTab | aButton phlow spawnObject: self roadmapNodes ];
		actionUpdateButton
]

{ #category : #actions }
TMAbstractTreeNode >> gtSpawnTopicMapActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Topic roadmap';
		priority: 35;
		icon: BrGlamorousVectorIcons roadmap;
		action: [ :aButton | aButton phlow spawnObject: self topicMap ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: self topicMap ]
			mouseCursor: BlCopyCursor new
]

{ #category : #views }
TMAbstractTreeNode >> gtTopicTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Topic Tree';
		priority: 25;
		items: [ self topicTreeChildren ];
		children: #topicTreeChildren;
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Node'
			text: [ :each | each nodeLabel ]
			width: 300;
		column: 'Node type'
			text: [ :each | each nodeType ]
			width: 80;
		column: '# Children'
			text: [ :each | each children size ]
			width: 80;
		column: '# Topics'
			text: [ :each | each topics size ]
			width: 80;
		column: '# Pages'
			text: [ :each | each pages size ]
			width: 80;
		column: '# Kinds'
			text: [ :each | each kinds size ]
			width: 80;
		column: 'Info'
			text: [ :each | each relatedInfo ]
			width: 300;
		send: [ :each | each ];
		actionButtonIcon: BrGlamorousVectorIcons changes
			tooltip: 'Inspect  pages'
			action: [ :aButton :aTab | aButton phlow spawnObject: self children ];
		actionUpdateButton
]

{ #category : #views }
TMAbstractTreeNode >> gtTreeMapFor: aView [
	<gtView>
	^ aView forward
		title: 'Tree Map';
		priority: 15;
		object: [ self treeMap ];
		view: #gtLiveFor:;
		actionUpdateButton
]

{ #category : #actions }
TMAbstractTreeNode >> gtTreeNodeMenuFor: anAction [
	<gtAction>
	^ anAction dropdown
		icon: BrGlamorousVectorIcons hamburger;
		priority: 40;
		tooltip: 'Tree Node Menu';
		content: [ :aButton | 
			| ifSlow |
			ifSlow := self nodeType = 'Database'
					ifTrue: [ ' (NB: slow)' ]
					ifFalse: [ '' ].
			BrGlamorousSimpleContextMenuContent new
				items: {('Inspect Mondrian tree' , ifSlow)
							-> [ aButton phlow spawnObject: self mondrianTree ].
						('Inspect Mondrian graph' , ifSlow)
							-> [ aButton phlow spawnObject: self mondrianGraph ].
						'Inspect JSON object'
							-> [ aButton phlow spawnObject: self topicMap json ].
						'Inspect JSON file'
							-> [ aButton phlow spawnObject: self topicMap jsonFile ]};
				yourself ]
]

{ #category : #comparing }
TMAbstractTreeNode >> hash [
	^ self nodeLabel hash
]

{ #category : #help }
TMAbstractTreeNode >> helpPageNameDefault [
	^ super helpPageNameDefault
]

{ #category : #accessing }
TMAbstractTreeNode >> highlightBreadcrumbsIn: aNodes [
	^ aNodes
		do: [ :n | (self breadcrumb nodes includes: n) ifTrue: [ n highlightOn ] ]
]

{ #category : #initialization }
TMAbstractTreeNode >> highlightOff [
	isHighlighted := false
]

{ #category : #initialization }
TMAbstractTreeNode >> highlightOn [
	isHighlighted := true
]

{ #category : #initialization }
TMAbstractTreeNode >> initialize [
	super initialize.
	self highlightOff
]

{ #category : #testing }
TMAbstractTreeNode >> isAbstract [
	^ self == TMAbstractTreeNode
]

{ #category : #testing }
TMAbstractTreeNode >> isHighlighted [
	^ isHighlighted
]

{ #category : #testing }
TMAbstractTreeNode >> isTMTreeNode [
	^ true
]

{ #category : #roadmap }
TMAbstractTreeNode >> mondrianGraph [
	"Experimental -- show a graph view starting from this node.
	NB: slow from the database node."

	| nodes mondrian |
	nodes := self withAllChildren.
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :node | node roadmapSimpleNodeElement ];
		with: nodes.
	mondrian edges connectToAll: #parents.
	mondrian layout
		custom: (GtGraphForceBasedLayout new
				charge: -200;
				length: 30).
	^ mondrian
]

{ #category : #roadmap }
TMAbstractTreeNode >> mondrianTree [
	"Experimental -- show a tree view starting from this node.
	NB: slow from the database node."

	| nodes mondrian |
	nodes := self withAllChildren.
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :node | node roadmapSimpleNodeElement ];
		with: nodes.
	mondrian edges connectToAll: #parents.
	mondrian layout
		custom: (GtGraphForceBasedLayout new
				charge: -100;
				length: 20).
	^ mondrian
]

{ #category : #accessing }
TMAbstractTreeNode >> nodeLabel [
	self subclassResponsibility
]

{ #category : #accessing }
TMAbstractTreeNode >> nodeType [
	self subclassResponsibility
]

{ #category : #navigation }
TMAbstractTreeNode >> parents [
	self subclassResponsibility
]

{ #category : #breadcrumbs }
TMAbstractTreeNode >> pathContext [
	"The path context is the breadcrumb of the previous roadmap (if any) from which this one is spawned.
	This information can be used to select the nodes to include in the roadmap, or the new breadcrumb to highlight."

	^ pathContext ifNil: [ pathContext := self defaultPathContext ]
]

{ #category : #breadcrumbs }
TMAbstractTreeNode >> pathContext: anObject [
	pathContext := anObject
]

{ #category : #printing }
TMAbstractTreeNode >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self nodeLabel;
		nextPut: $)
]

{ #category : #accessing }
TMAbstractTreeNode >> relatedInfo [
	"Related information to display."

	^ '-'
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmap [
	"A mondrian roadmap showing: database > fields > topics > kinds > pages."

	| mondrian |
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :aTmNode | aTmNode roadmapNodeElement ];
		with: self roadmapNodesWithPathContext.
	mondrian edges connectFromAll: #roadmapParents.
	mondrian layout
		custom: (GtGradHorizontalTreeLayout new
				levelDistance: 50;
				nodeDistance: 20).
	^ mondrian
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapNodeBorder [
	^ self isHighlighted
		ifTrue: [ BlBorder paint: Color red width: 2 ]
		ifFalse: [ BlBorder paint: Color black width: 1 ]
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapNodeColor [
	"Can override the default in subclasses if needed."

	^ self defaultNodeColor
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapNodeElement [
	"A mindmap-like element containing the node's name."

	^ BlTextElement new
		text: self nodeLabel asRopedText;
		border: self roadmapNodeBorder;
		background: self roadmapNodeColor;
		padding: (BlInsets all: 5);
		geometry: (BlRoundedRectangleGeometry cornerRadius: 8);
		aptitude: (BrGlamorousWithExplicitTooltipAptitude content: self roadmapTooltip)
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapNodeSize [
	^ 10 @ 10
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapNodes [
	"Returns all the nodes for the roadmap for this kind of node as a kind of TMNodeGroup"

	^ self subclassResponsibility
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapNodesWithPathContext [
	"Add the current node's breadcrumb as a path context.
	Used mainly for building the roadmap, but can also be used by examples
	to query the nodes and simulate clicking on a node in the roadmap.
	See senders."

	^ self roadmapNodes
		collect: [ :n | 
			n
				pathContext: self breadcrumb;
				yourself ]
]

{ #category : #navigation }
TMAbstractTreeNode >> roadmapParents [
	"For the mondrian roadmap, same as parents, except for page nodes."

	^ self parents
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapSimpleNodeElement [
	"Only a small circle for a simple graph view."

	^ BlElement new
		size: self roadmapNodeSize;
		border: self roadmapNodeBorder;
		background: self roadmapNodeColor;
		aptitude: (BrGlamorousWithExplicitTooltipAptitude content: self roadmapTooltip)
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapTooltip [
	"Previously was a simple form of breadcrumb ..."

	^ [ BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude new;
		padding: (BlInsets all: 2);
		text: self nodeLabel;
		yourself ] asStencil
]

{ #category : #accessing }
TMAbstractTreeNode >> topicInContext [
	^ self pathContext topicNode notNil
		and: [ self topicNodes includes: self pathContext topicNode ]
]

{ #category : #navigation }
TMAbstractTreeNode >> topicMap [
	^ topicMap
]

{ #category : #navigation }
TMAbstractTreeNode >> topicMap: anObject [
	topicMap := anObject
]

{ #category : #navigation }
TMAbstractTreeNode >> topicTreeChildren [
	^ self children
]

{ #category : #treemaps }
TMAbstractTreeNode >> treeMap [
	| kindPalette treemap |
	kindPalette := self kindPalette.
	treemap := GtNestedRectangleTreeMap new
			roots: self treeMapRoots;
			leaves: [ :aNode | aNode treeMapLeaves ];
			deep: [ :aNode | aNode treeMapChildren ];
			leavesSize: [ :aPageNode | aPageNode page asMarkdownString size max: 1000 ];
			leafElement: [ :anElement :aLeafContext | 
				| page pageNode |
				pageNode := aLeafContext model.
				page := pageNode page.
				anElement
					background: (kindPalette at: pageNode kind ifAbsent: Color veryLightGray).
				anElement
					when: BlClickEvent
					do: [ :e | e target phlow spawnObject: pageNode ].
				anElement
					aptitude: (BrGlamorousWithExplicitTooltipAptitude content: [ pageNode roadmapTooltip ]) ];
			containerElement: [ :anElement :aNodeContext | 
				| node |
				node := aNodeContext model.
				aNodeContext level = 2
					ifTrue: [ anElement
							padding: (BlInsets
									top: 12
									bottom: 2
									left: 2
									right: 2);
							addChild: (BrLabel new
									text: node nodeLabel;
									aptitude: (BrGlamorousLabelAptitude new
											fontSize: 10;
											foreground: Color blue);
									background: Color white;
									constraintsDo: [ :c | c ignoreByLayout ]) ].

				anElement
					border: (BlBorder
							paint: (node defaultNodeColor alpha: 0.7 / aNodeContext level)
							width: 2) ].
	^ treemap
]

{ #category : #treemaps }
TMAbstractTreeNode >> treeMapChildren [
	"NB: The children hierarchy for treemaps distinguishes leaves from recursive nodes."
	^ self children
]

{ #category : #treemaps }
TMAbstractTreeNode >> treeMapLeaves [
	^ {}
]

{ #category : #treemaps }
TMAbstractTreeNode >> treeMapNodeLabel [
	^ self nodeLabel
]

{ #category : #treemaps }
TMAbstractTreeNode >> treeMapRoots [
	^ {self}
]

{ #category : #roadmap }
TMAbstractTreeNode >> withAllChildren [
	^ {self} , self allChildren
]
