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

{ #category : #views }
TMTopicNode >> changeFieldTo: aField [
	self topicMap updateFieldForTopic: self to: aField
]

{ #category : #navigation }
TMTopicNode >> children [
	^ self pageGroup
]

{ #category : #breadcrumbs }
TMTopicNode >> defaultBreadcrumb [
	^ TMBreadcrumb
		for: {self databaseNode.
				self fieldNode.
				self}
]

{ #category : #mondrian }
TMTopicNode >> defaultNodeColor [
	^ Color paleGreen
]

{ #category : #accessing }
TMTopicNode >> field [
	^ self topicMap field4Topic: self topic
]

{ #category : #accessing }
TMTopicNode >> fieldNode [
	self assert: self fieldNodes size equals: 1.
	^ self fieldNodes first
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
		column: 'Field' text: [ :aField | aField gtDisplayString ];
		column: ''
			stencil: [ :aField | 
				| checkbox |
				checkbox := BrCheckbox new aptitude: BrGlamorousCheckboxAptitude.
				self field = aField ifTrue: [ checkbox check ].
				checkbox
					action: [ :aButton :aTab | 
						self changeFieldTo: aField.
						checkbox phlow fireViewUpdateWish ].
				checkbox ];
		send: [ :aField | self fieldNodeFor: aField ];
		actionUpdateButton
]

{ #category : #help }
TMTopicNode >> helpPageName [
	^ 'TopicMap Topic'
]

{ #category : #navigation }
TMTopicNode >> kinds [
	^ self topicMap kinds4Topic: self topic
]

{ #category : #accessing }
TMTopicNode >> nodeLabel [
	^ self topic
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

{ #category : #roadmap }
TMTopicNode >> roadmapNodes [
	"database -> fields -> topic -> t.kinds -> t.pages
	NB: Don't show peer topics to avoid clutter."

	| pages kinds nodes root |
	root := self databaseNode.
	kinds := self kindNodes.
	pages := self children sortedByKinds.
	nodes := root roadmapNodes , {self} , kinds , pages.
	self highlightBreadcrumbsIn: nodes.
	^ nodes
]

{ #category : #printing }
TMTopicNode >> storeOn: aStream [
	aStream
		nextPut: $(;
		storeObject: self topicMap;
		nextPutAll: ' topicNodeNamed: ';
		nextPutAll: self topic printString;
		nextPut: $)
]

{ #category : #printing }
TMTopicNode >> storeOnNodeGroup: aStream [
	aStream
		nextPutAll: ' addTopicNodeNamed: ';
		nextPutAll: self topic printString
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
	"For a treeMap we group the pages by kinds, so we need an intermediate node."

	^ self kindNodes
]
