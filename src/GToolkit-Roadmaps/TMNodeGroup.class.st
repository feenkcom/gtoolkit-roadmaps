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

{ #category : #updating }
TMNodeGroup >> addAll: aNodesCollection [
	self
		nodes: (self nodes
				addAll: aNodesCollection;
				yourself) copyWithoutDuplicates
]

{ #category : #updating }
TMNodeGroup >> addDatabaseNode [
	self nodes add: self topicMap databaseNode
]

{ #category : #updating }
TMNodeGroup >> addDraftPageNodeWithTitle: aTitle [
	self nodes add: (self topicMap databaseNode pageNodeWithTitle: aTitle) asDraftPageNode
]

{ #category : #updating }
TMNodeGroup >> addFieldNodeNamed: aField [
	self nodes add: (self topicMap fieldNodeNamed: aField)
]

{ #category : #updating }
TMNodeGroup >> addKindNodeNamed: aKind [
	self nodes add: (self topicMap kindNodeNamed: aKind)
]

{ #category : #updating }
TMNodeGroup >> addNodeGroup: aNodeGroup [
	self addAll: aNodeGroup nodes
]

{ #category : #updating }
TMNodeGroup >> addPageNodeWithTitle: aTitle [
	"NB: Here we ask the databaseNode instead of the topic map for matching pages,
	because the pages in question might be unmapped.
	See TopicMapExamples>>#smaccQuery"

	self nodes add: (self topicMap databaseNode pageNodeWithTitle: aTitle)
]

{ #category : #updating }
TMNodeGroup >> addTopicNodeNamed: aTopic [
	self nodes add: (self topicMap topicNodeNamed: aTopic)
]

{ #category : #navigation }
TMNodeGroup >> children [
	"Or just return self?"
	"^ self nodesFor: self nodes"
	^ self
]

{ #category : #breadcrumbs }
TMNodeGroup >> defaultBreadcrumb [
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

{ #category : #printing }
TMNodeGroup >> newNodeGroupSelector [
	^ #newNodeGroup
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
	nodes := aNodeCollection asOrderedCollection
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

{ #category : #roadmap }
TMNodeGroup >> roadmapNodes [
	"node / page group: nodes + all parents"

	| root roadmapNodes |
	root := self databaseNode.
	roadmapNodes := (self nodes , self allParents) copyWithoutDuplicates asOrderedCollection.
	self breadcrumb isEmpty
		ifTrue: [ self nodes do: #highlightOn ]
		ifFalse: [ self highlightBreadcrumbsIn: roadmapNodes ].
	^ roadmapNodes
]

{ #category : #printing }
TMNodeGroup >> storeOn: aStream [
	<todo: 'Handle case with breadcrumb in pathContext'>
	aStream
		nextPutAll: '((';
		storeObject: self topicMap;
		nextPut: Character space;
		nextPutAll: self newNodeGroupSelector asString;
		nextPutAll: ') yourself '.
	self nodes
		do: [ :n | 
			aStream nextPutAll: '; '.
			n storeOnNodeGroup: aStream ].
	aStream nextPutAll: ') yourself'
]

{ #category : #printing }
TMNodeGroup >> storeOnNodeGroup: aStream [
	self shouldNotImplement
]

{ #category : #navigation }
TMNodeGroup >> topics [
	^ (self children flatCollect: #topics) copyWithoutDuplicates
]
