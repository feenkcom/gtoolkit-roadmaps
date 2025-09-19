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

{ #category : #roadmap }
TMFieldNode >> breadcrumb [
	^ self parents first breadcrumb , String cr , '- ', self nodeLabel
]

{ #category : #accessing }
TMFieldNode >> children [
	^ self
		nodesFor: (self topics collect: [ :each | TMTopicNode for: each in: self topicMap ])
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
	^ "'Field: ' ," self field
]

{ #category : #navigation }
TMFieldNode >> pages [
	^ (self children flatCollect: #pages) copyWithoutDuplicates
]

{ #category : #accessing }
TMFieldNode >> parents [
	^ self nodesFor: {self databaseNode}
]

{ #category : #mondrian }
TMFieldNode >> roadmapNodes [
	| root |
	root := self databaseNode.
	^ root roadmapNodes , self children
]

{ #category : #navigation }
TMFieldNode >> topics [
	^ self topicMap topic4Field: self field
]
