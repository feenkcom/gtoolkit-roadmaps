Class {
	#name : #TMBreadcrumb,
	#superclass : #Object,
	#instVars : [
		'nodes'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMBreadcrumb class >> for: aTopicMap [
	^ self new
		nodes: {aTopicMap databaseNode} asOrderedCollection;
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

{ #category : #accessing }
TMBreadcrumb >> nodes [
	^ nodes
]

{ #category : #accessing }
TMBreadcrumb >> nodes: anObject [
	nodes := anObject
]

{ #category : #accessing }
TMBreadcrumb >> size [
	^ nodes size
]
