"
I hold as my children a collection of other nodes.
I am useful for generating ad hoc views of collections of pages, topics, etc.
"
Class {
	#name : #TMNodeGroup,
	#superclass : #TMAbstractTreeNode,
	#traits : 'TGtGroup',
	#classTraits : 'TGtGroup classTrait',
	#instVars : [
		'nodes'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMNodeGroup class >> for: aNodeCollection in: aTopicMap [
	^ self new
		nodes: aNodeCollection;
		topicMap: aTopicMap;
		yourself
]

{ #category : #navigation }
TMNodeGroup >> , otherCollection [
	^ self nodesFor: self nodes , otherCollection
]

{ #category : #comparing }
TMNodeGroup >> = other [
	self == other ifTrue: [ ^ true ].
	self class = other class ifFalse: [^ false ].
	^ self nodes asSet = other nodes asSet
]

{ #category : #breadcrumbs }
TMNodeGroup >> breadcrumb [
	^ TMBreadcrumb for: {}
]

{ #category : #navigation }
TMNodeGroup >> children [
	"Or just return self?"
	"^ self nodesFor: self nodes"
	^ self
]

{ #category : #breadcrumbs }
TMNodeGroup >> defaultPathContext [
	^ TMBreadcrumb for: {}
]

{ #category : #navigation }
TMNodeGroup >> fields [
	^ (self children flatCollect: #fields) copyWithoutDuplicates
]

{ #category : #comparing }
TMNodeGroup >> hash [
	"Bad hack? Should we combine all the hashes?"

	^ self nodes first hash
]

{ #category : #help }
TMNodeGroup >> helpPageName [
	^ 'Topic Group'
]

{ #category : #testing }
TMNodeGroup >> isTMNodeGroup [
	^ true
]

{ #category : #accessing }
TMNodeGroup >> items [
	^ nodes
]

{ #category : #navigation }
TMNodeGroup >> kinds [
	^ (self children flatCollect: #kinds) copyWithoutDuplicates
]

{ #category : #accessing }
TMNodeGroup >> nodeLabel [
	^ 'Node collection'
]

{ #category : #accessing }
TMNodeGroup >> nodeType [
	^ 'Node collection'
]

{ #category : #accessing }
TMNodeGroup >> nodes [
	^ nodes
]

{ #category : #accessing }
TMNodeGroup >> nodes: aNodeCollection [
	nodes := aNodeCollection
]

{ #category : #accessing }
TMNodeGroup >> pages [
	^ (self children flatCollect: #pages) copyWithoutDuplicates
]

{ #category : #navigation }
TMNodeGroup >> parents [
	"Not sure we need this. Perhaps we need a different definition ..."

	^ self nodesFor: (self nodes flatCollect: #parents) copyWithoutDuplicates
]

{ #category : #printing }
TMNodeGroup >> printOn: aStream [
super printOn: aStream.
	aStream
		nextPut: $(;
		print: self items size;
		nextPutAll: ' nodes';
		nextPut: $)
]

{ #category : #'as yet unclassified' }
TMNodeGroup >> roadmapNodes [
	"node / page group: nodes + all parents"

	| root roadmapNodes |
	root := self databaseNode.
	roadmapNodes := self nodes , self allParents.
	self breadcrumb isEmpty
		ifTrue: [ self nodes do: #highlightOn ]
		ifFalse: [ self highlightBreadcrumbsIn: roadmapNodes ].
	^ roadmapNodes
]

{ #category : #navigation }
TMNodeGroup >> topics [
	^ (self children flatCollect: #topics) copyWithoutDuplicates
]
