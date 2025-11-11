Class {
	#name : #TMFieldNode,
	#superclass : #TMAbstractTreeNode,
	#instVars : [
		'field'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMFieldNode class >> for: aField in: aTopicMap [
^ self new
	field: aField;
	topicMap: aTopicMap;
	yourself 
]

{ #category : #accessing }
TMFieldNode >> children [
	^ self nodesFor: (self topics collect: [ :aTopic | self topicNodeFor: aTopic ])
]

{ #category : #breadcrumbs }
TMFieldNode >> defaultBreadcrumb [
	^ TMBreadcrumb
		for: {self databaseNode.
				self}
]

{ #category : #mondrian }
TMFieldNode >> defaultNodeColor [
	^ Color paleRed
]

{ #category : #accessing }
TMFieldNode >> field [
	^ field
]

{ #category : #accessing }
TMFieldNode >> field: anObject [
	field := anObject
]

{ #category : #navigation }
TMFieldNode >> fields [
	^ {field}
]

{ #category : #views }
TMFieldNode >> gtMondrianTreeFor: aView [
	"For Fields only -- too slow for the whole db, and not interesting for topics."

	<gtView>
	^ aView forward
		title: 'Mondrian tree';
		priority: 40;
		object: [ self mondrianTree ];
		view: #gtLiveFor:
]

{ #category : #help }
TMFieldNode >> helpPageName [
	^ 'Topic Field'
]

{ #category : #testing }
TMFieldNode >> isTMFieldNode [
	^ true
]

{ #category : #testing }
TMFieldNode >> isTMTreeNode [
	^ true
]

{ #category : #navigation }
TMFieldNode >> kinds [
	| topicKinds |
	topicKinds := (self children flatCollect: #kinds) copyWithoutDuplicates.
	^ self topicMap kinds select: [ :aKind | topicKinds includes: aKind ]
]

{ #category : #accessing }
TMFieldNode >> nodeLabel [
	^ self field
]

{ #category : #accessing }
TMFieldNode >> nodeType [
	^ 'Field'
]

{ #category : #navigation }
TMFieldNode >> pages [
	^ (self children flatCollect: #pages) copyWithoutDuplicates
]

{ #category : #accessing }
TMFieldNode >> parents [
	^ self nodesFor: {self databaseNode}
]

{ #category : #roadmap }
TMFieldNode >> roadmapNodes [
	"database -> fields -> f.topics"

	| root nodes |
	root := self databaseNode.
	nodes := root roadmapNodes , self children.
	self highlightBreadcrumbsIn: nodes.
	^ nodes
]

{ #category : #printing }
TMFieldNode >> storeOn: aStream [
	aStream
		nextPut: $(;
		storeObject: self topicMap;
		nextPutAll: ' fieldNodeNamed: ';
		nextPutAll: self field printString;
		nextPut: $)
]

{ #category : #printing }
TMFieldNode >> storeOnNodeGroup: aStream [
	aStream
		nextPutAll: ' addFieldNodeNamed: ';
		nextPutAll: self field printString
]

{ #category : #navigation }
TMFieldNode >> topics [
	^ self topicMap topic4Field: self field
]
