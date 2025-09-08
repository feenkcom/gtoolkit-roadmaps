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

{ #category : #accessing }
TMTopicNode >> relatedInfo [
	^ 'Field: ' , self field
]

{ #category : #mondrian }
TMTopicNode >> roadmapChildren [
	"For mondrian my children are pages, not styles.
	Sort them by the standard style order."

	^ self stylesStandardOrder
		flatCollect: [ :aStyle | 
			(self pageGroup select: [ :p | p style = aStyle ])
				collect: [ :n | 
					n
						treeMapParent: self;
						yourself ] ]
]

{ #category : #mondrian }
TMTopicNode >> roadmapNodes [
	"Want parents, parent peers, and own peers."

	| parent |
	parent := self fieldNodes first	.
	
	self treeMapParent: parent.
	^ parent roadmapNodes , self roadmapChildren
	
	"| root parent |
	root := self databaseNode.
	parent := self databaseNode roadmapNodes
			detect: [ :n | n isTMFieldNode and: [ n field = self field ] ].
	self treeMapParent: parent.
	^ root roadmapNodes , {self} , self roadmapChildren"
]

{ #category : #mondrian }
TMTopicNode >> roadmapTreeChildren [
	"For mondrian my children are pages, not styles."

	^ (TMPageForTopicGroup for: self pages in: self topicMap)
		collect: [ :n | 
			n
				treeMapParent: self;
				yourself ]
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

{ #category : #treemaps }
TMTopicNode >> treeMapChildren [
	^ self styleNodes
		collect: [ :n | 
			n
				treeMapParent: self;
				yourself ]
]
