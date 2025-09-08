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
	^ self parents first breadcrumb , String cr , '-- ', self name
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

{ #category : #accessing }
TMTopicNode >> name [
	^ 'Topic: ' , self topic
]

{ #category : #querying }
TMTopicNode >> pages [
	^ self topicMap topic2Pages at: self topic
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

	| parent |
	parent := self fieldNodes first.
	^ parent roadmapNodes
		, (self children sortedByStyles collect: [ :pn | pn viaTopic: self ])
]

{ #category : #navigation }
TMTopicNode >> styles [
	^ self topicMap styles4Topic: self topic
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
	"For a treeMap we group the pages by styles, so we need an intermediate node."

	^ self styleNodes
]
