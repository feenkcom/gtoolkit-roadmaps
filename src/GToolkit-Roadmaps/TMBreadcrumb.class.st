Class {
	#name : #TMBreadcrumb,
	#superclass : #Object,
	#instVars : [
		'nodes'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMBreadcrumb class >> for: aTMNodeCollection [
	^ self new
		nodes: aTMNodeCollection;
		yourself
]

{ #category : #comparing }
TMBreadcrumb >> = other [
	^ self class = other class and: [ self nodes = other nodes ]
]

{ #category : #accessing }
TMBreadcrumb >> addNode: aNode [
	^ self nodes addLast: aNode
]

{ #category : #accessing }
TMBreadcrumb >> databaseNode [
	^ self nodes size < 1 ifTrue: [ nil ] ifFalse: [ self nodes first ]
]

{ #category : #accessing }
TMBreadcrumb >> fieldNode [
	^ self nodes size < 2 ifTrue: [ nil ] ifFalse: [ self nodes second ]
]

{ #category : #views }
TMBreadcrumb >> gtNodesFor: aView [
	<gtView>
	nodes ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Nodes';
		items: [ nodes ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Node' text: [ :each | each gtDisplayString ];
		actionUpdateButton
]

{ #category : #comparing }
TMBreadcrumb >> hash [
	^super hash bitXor: self nodes hash
]

{ #category : #initialization }
TMBreadcrumb >> initialize [
	super initialize.
	nodes := OrderedCollection new
]

{ #category : #testing }
TMBreadcrumb >> isEmpty [
	^ self nodes isEmpty
]

{ #category : #accessing }
TMBreadcrumb >> kindNode [
	^ self nodes size < 4 ifTrue: [ nil ] ifFalse: [ self nodes fourth ]
]

{ #category : #accessing }
TMBreadcrumb >> nodes [
	^ nodes
]

{ #category : #accessing }
TMBreadcrumb >> nodes: anObject [
	nodes := anObject
]

{ #category : #accessing }
TMBreadcrumb >> pageNode [
	^ self nodes size < 5 ifTrue: [ nil ] ifFalse: [ self nodes fifth ]
]

{ #category : #accessing }
TMBreadcrumb >> size [
	^ nodes size
]

{ #category : #accessing }
TMBreadcrumb >> topicNode [
	^ self nodes size < 3 ifTrue: [ nil ] ifFalse: [ self nodes third ]
]
