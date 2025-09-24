Class {
	#name : #TMTopicNode,
	#superclass : #TMAbstractTreeNode,
	#instVars : [
		'topic'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMTopicNode class >> for: aTopic in: aTopicMap [
^ self new
	topic: aTopic;
	topicMap: aTopicMap;
	yourself 
]

{ #category : #roadmap }
TMTopicNode >> breadcrumb [
	^ self parents first breadcrumb , String cr , '-- ', self nodeLabel
]

{ #category : #navigation }
TMTopicNode >> children [
	^ self pageGroup
]

{ #category : #mondrian }
TMTopicNode >> defaultNodeColor [
	^ Color paleGreen
]

{ #category : #accessing }
TMTopicNode >> field [
	^ self topicMap field4Topic: self topic
]

{ #category : #navigation }
TMTopicNode >> fields [
	^ {self field}
]

{ #category : #views }
TMTopicNode >> gtEditFieldFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Edit Field';
		priority: 50;
		items: [ self topicMap fields ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Field' text: [ :aField | aField gtDisplayString ];	column: ''
			stencil: [ :aField | 
				| checkbox |
				checkbox := BrCheckbox new aptitude: BrGlamorousCheckboxAptitude.
				self field = aField ifTrue: [ checkbox check ].
				checkbox
					action: [ :aButton :aTab | 
						self topicMap updateFieldForTopic: self to: aField.
						checkbox phlow fireViewUpdateWish ].
				checkbox ];
		send: [ :aField | self fieldNodeFor: aField ];
		actionUpdateButton
]

{ #category : #help }
TMTopicNode >> helpPageName [
	^ 'Topic'
]

{ #category : #navigation }
TMTopicNode >> kinds [
	^ self topicMap kinds4Topic: self topic
]

{ #category : #accessing }
TMTopicNode >> nodeLabel [
	^ "'Topic: ' ," self topic
]

{ #category : #accessing }
TMTopicNode >> nodeType [
	^ 'Topic'
]

{ #category : #querying }
TMTopicNode >> pages [
	^ self topicMap topic2Pages at: self topic ifAbsent: {}
]

{ #category : #navigation }
TMTopicNode >> parents [
	^ self fieldNodes
]

{ #category : #accessing }
TMTopicNode >> relatedInfo [
	^ 'Field: ' , self field
]

{ #category : #mondrian }
TMTopicNode >> roadmapNodes [
	"Want parents, parent peers, and own peers."

	| parent children |
	parent := self fieldNodes first.
	children := self children sortedByKinds collect: [ :pn | pn viaTopic: self ].
	^ parent roadmapNodes , children
]

{ #category : #mondrian }
TMTopicNode >> roadmapWithKindNodes [
	"Want parents, parent peers, and own peers."

	| parent children kinds |
	parent := self fieldNodes first.
	children := self children sortedByKinds collect: [ :pn | pn viaTopic: self ].
	kinds := (children flatCollect: #kindNodes) copyWithoutDuplicates.
	^ parent roadmapWithKindNodes , kinds, children
]

{ #category : #accessing }
TMTopicNode >> topic [
	^ topic
]

{ #category : #accessing }
TMTopicNode >> topic: aString [
	topic := aString
]

{ #category : #navigation }
TMTopicNode >> topics [
	^ {self topic}
]

{ #category : #navigation }
TMTopicNode >> treeChildren [
	"Set the viaTopic field so pages can appear multiple times, once for each topic."

	^ self children
		collect: [ :n | 
			n
				viaTopic: self;
				yourself ]
]

{ #category : #treemaps }
TMTopicNode >> treeMapChildren [
	"For a treeMap we group the pages by kinds, so we need an intermediate node."

	^ self kindNodes
]
