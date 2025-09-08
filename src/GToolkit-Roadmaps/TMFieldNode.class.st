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

{ #category : #testing }
TMFieldNode >> isTMFieldNode [
	^ true
]

{ #category : #testing }
TMFieldNode >> isTMTreeNode [
	^ true
]

{ #category : #accessing }
TMFieldNode >> name [
	^ 'Field: ' , self field
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
	self treeMapParent: root.
	^ root roadmapNodes , self roadmapChildren
]

{ #category : #navigation }
TMFieldNode >> styles [
	| topicStyles |
	topicStyles := (self children flatCollect: #styles) copyWithoutDuplicates.
	^ self topicMap styles select: [ :aStyle | topicStyles includes: aStyle ]
]

{ #category : #navigation }
TMFieldNode >> topics [
	^ self topicMap topic4Field: self field
]
