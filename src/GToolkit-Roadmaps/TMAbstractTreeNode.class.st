"
I am an abstract parent for trees of Topic Map nodes representing pages, topics, fields, and styles.

I support navigation via dedicated views of page groups.
"
Class {
	#name : #TMAbstractTreeNode,
	#superclass : #TMAbstractEntity,
	#instVars : [
		'topicMap'
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

{ #category : #roadmap }
TMAbstractTreeNode >> allTreeChildren [
	| allChildren |
	allChildren := OrderedCollection withAll: self treeChildren.
	self children do: [ :each | allChildren addAll: each allTreeChildren ].
	^ allChildren copyWithoutDuplicates
]

{ #category : #roadmap }
TMAbstractTreeNode >> breadcrumb [
	^ self nodeLabel
]

{ #category : #roadmap }
TMAbstractTreeNode >> breadcrumbTooltip [
	^ [ BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude new;
		padding: (BlInsets all: 2);
		text: self breadcrumb;
		yourself ] asStencil
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
]

{ #category : #treemaps }
TMAbstractTreeNode >> defaultNodeColor [
	"Can be used for treemaps, mondrian graphs, sceneries etc."

	^ Color gray
]

{ #category : #navigation }
TMAbstractTreeNode >> fieldNodes [
	^ self
		nodesFor: (self fields collect: [ :aField | TMFieldNode for: aField in: self topicMap ])
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
TMAbstractTreeNode >> gtRoadmapFor: aView [
	<gtView>
	^ aView forward
		title: 'Roadmap';
		priority: 35;
		object: [ self roadmap ];
		view: #gtLiveFor:;
		actionUpdateButton
]

{ #category : #views }
TMAbstractTreeNode >> gtRoadmapWithKindFor: aView [
	<gtView>
	^ aView forward
		title: 'Roadmap 2';
		priority: 36;
		object: [ self roadmapWithKind ];
		view: #gtLiveFor:;
		actionUpdateButton
]

{ #category : #actions }
TMAbstractTreeNode >> gtSpawnTopicMapActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Topic map';
		priority: 35;
		icon: TopicMap topicMapIcon;
		action: [ :aButton | aButton phlow spawnObject: self topicMap ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: self topicMap ]
			mouseCursor: BlCopyCursor new
]

{ #category : #views }
TMAbstractTreeNode >> gtSummaryFor: aView [
	<gtView>
	"self summary ifEmpty: [ ^ aView empty ]."
	^ aView columnedList
		title: 'Summary';
		priority: 20;
		items: [ self summary ];
		actionUpdateButtonTooltip: 'Update item list';
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Key'
			text: #first
			width: 100;
		column: 'Value' text: #second;
		send: #last
]

{ #category : #views }
TMAbstractTreeNode >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Topic Map';
		priority: 10;
		items: [ self children ];
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
		column: '# Kinds'
			text: [ :each | each kinds size ]
			width: 100;
		column: 'Info'
			text: [ :each | each relatedInfo ]
			width: 300;
		send: [ :each | each ];
		actionUpdateButton
]

{ #category : #views }
TMAbstractTreeNode >> gtTreeMapFor: aView [
	<gtView>
	^ aView forward
		title: 'Tree Map';
		priority: 30;
		object: [ self treeMap ];
		view: #gtLiveFor:;
		actionUpdateButton
]

{ #category : #comparing }
TMAbstractTreeNode >> hash [
	^ self nodeLabel hash
]

{ #category : #testing }
TMAbstractTreeNode >> isAbstract [
	^ self == TMAbstractTreeNode
]

{ #category : #testing }
TMAbstractTreeNode >> isTMTreeNode [
	^ true
]

{ #category : #navigation }
TMAbstractTreeNode >> kindNodes [
	^ self
		nodesFor: (self kinds
				collect: [ :aKind | 
					TMKindNode
						for: aKind
						in: self topicMap
						within: self pageGroup ])
]

{ #category : #treemaps }
TMAbstractTreeNode >> kindPalette [
	^ {'Introduction' -> Color red muchLighter.
		'Media' -> Color green lighter.
		'Tutorial' -> Color blue muchLighter.
		'Case study' -> Color purple muchLighter.
		'Pattern' -> Color orange.
		'FAQ' -> Color paleYellow.
		'Examples' -> Color lightRed.
		'Documentation' -> Color paleBlue.
		'Definition' -> Color veryLightGray.
		'Index' -> Color lightGray.
		'Tag' -> Color gray} asDictionary
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
	nodes := self withAllTreeChildren.
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

{ #category : #navigation }
TMAbstractTreeNode >> pages [
	self subclassResponsibility
]

{ #category : #navigation }
TMAbstractTreeNode >> parents [
	self subclassResponsibility
]

{ #category : #navigation }
TMAbstractTreeNode >> parentsWithKind [
	^ self parents
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
	| mondrian |
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :aTmNode | aTmNode roadmapNodeElement ];
		with: self roadmapNodes.
	mondrian edges connectFromAll: #parents.
	mondrian layout
		custom: (GtGradHorizontalTreeLayout new
				levelDistance: 50;
				nodeDistance: 20).
	^ mondrian
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapNodeBorderColor [
	^ Color black
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
		border: self roadmapNodeBorderColor;
		background: self roadmapNodeColor;
		padding: (BlInsets all: 5);
		geometry: (BlRoundedRectangleGeometry cornerRadius: 8);
		aptitude: (BrGlamorousWithExplicitTooltipAptitude content: self breadcrumbTooltip)
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapNodeSize [
	^ 10 @ 10
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapNodes [
	"Should return a kind of TMNodeGroup"

	^ self subclassResponsibility
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapSimpleNodeElement [
	"Only a small circle for a simple graph view."

	^ BlElement new
		size: self roadmapNodeSize;
		border: self roadmapNodeBorderColor;
		background: self roadmapNodeColor;
		aptitude: (BrGlamorousWithExplicitTooltipAptitude content: self breadcrumbTooltip)
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapWithKind [
	"Experimental -- variant in which we also show kinds as nodes."

	| mondrian |
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :aTmNode | aTmNode roadmapNodeElement ];
		with: self roadmapWithKindNodes.
	mondrian edges connectFromAll: #parentsWithKind.
	mondrian layout
		custom: (GtGradHorizontalTreeLayout new
				levelDistance: 50;
				nodeDistance: 20).
	^ mondrian
]

{ #category : #roadmap }
TMAbstractTreeNode >> roadmapWithKindNodes [
	"Should return a kind of TMNodeGroup"

	^ self roadmapNodes
]

{ #category : #utility }
TMAbstractTreeNode >> sizeAndFirstIfAlone: aCollection [
	^ aCollection size printString
		, (aCollection size = 1 ifTrue: [ ' — ' , aCollection first ] ifFalse: [ '' ])
]

{ #category : #views }
TMAbstractTreeNode >> summary [
	^ {{'Database'.
			self database.
			self databaseNode}.
		{'#Fields'.
			self sizeAndFirstIfAlone: self fields.
			self fieldNodes}.
		{'#Topics'.
			self sizeAndFirstIfAlone: self topics.
			self topicNodes}.
		{'#kinds'.
			self sizeAndFirstIfAlone: self kinds.
			self kindNodes}.
		{'#Pages'.
			self sizeAndFirstIfAlone: (self pages collect: #title).
			self pageGroup}}
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
TMAbstractTreeNode >> topicNodes [
	^ self
		nodesFor: (self topics collect: [ :aTopic | TMTopicNode for: aTopic in: self topicMap ])
]

{ #category : #navigation }
TMAbstractTreeNode >> treeChildren [
	"Like children, but when we get to pages, set the viaTopic field
	so the same page can appear as a leaf for each topic."

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
					aptitude: (BrGlamorousWithExplicitTooltipAptitude content: [ pageNode breadcrumbTooltip ]) ];
			containerElement: [ :anElement :aNodeContext | 
				| node |
				node := aNodeContext model.
				aNodeContext level = 2
					ifTrue: [ anElement
							addChild: (BrLabel new
									text: node nodeLabel;
									aptitude: (BrGlamorousLabelAptitude new
											fontSize: 10;
											foreground: Color blue);
									background: Color white;
									constraintsDo: [ :c | c ignoreByLayout ]) ].

				anElement border: (BlBorder paint: node defaultNodeColor width: 2).
				anElement padding: (BlInsets top: 12  bottom: 2 left: 2 right: 2) ].
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

{ #category : #roadmap }
TMAbstractTreeNode >> withAllTreeChildren [
	^ {self} , self allTreeChildren
]
