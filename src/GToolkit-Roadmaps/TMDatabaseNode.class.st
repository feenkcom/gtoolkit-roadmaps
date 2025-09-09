Class {
	#name : #TMDatabaseNode,
	#superclass : #TMAbstractTreeNode,
	#instVars : [
		'database'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMDatabaseNode class >> for: aDatabase [
	^ self new
		topicMap: aDatabase topicMap;
		yourself
]

{ #category : #'instance creation' }
TMDatabaseNode class >> for: aDatabase in: aTopicMap [
	^ self new
		topicMap: aTopicMap;
		yourself
]

{ #category : #navigation }
TMDatabaseNode >> children [
	^ self
		nodesFor: (self fields collect: [ :aField | TMFieldNode for: aField in: self topicMap ])
]

{ #category : #mondrian }
TMDatabaseNode >> defaultNodeColor [
	^ Color lightCyan
]

{ #category : #navigation }
TMDatabaseNode >> fields [
	^ self topicMap fields
]

{ #category : #actions }
TMDatabaseNode >> gtDatabaseActionFor: anAction [
	<gtAction>
	self database ifNil: [ ^ anAction noAction ].
	self database isDatabase ifFalse: [ ^ anAction noAction ].

	^ anAction button
		tooltip: 'Inspect the database';
		priority: 40;
		icon: LeIcons lepiterDatabase;
		id: LePageDatabaseActionId;
		action: [ :aButton | aButton phlow spawnObject: self database ]
]

{ #category : #navigation }
TMDatabaseNode >> kinds [
	^ self topicMap kind
]

{ #category : #accessing }
TMDatabaseNode >> nodeLabel [
	^ self database databaseName
]

{ #category : #navigation }
TMDatabaseNode >> pages [
	^ self database pages
]

{ #category : #navigation }
TMDatabaseNode >> parents [
	^ self emptyNodes
]

{ #category : #mondrian }
TMDatabaseNode >> roadmapNodeSize [
	^ 20 @ 20
]

{ #category : #mondrian }
TMDatabaseNode >> roadmapNodes [
	^ self nodesFor: {self} , self children
]

{ #category : #navigation }
TMDatabaseNode >> topics [
	^ self topicMap topics sorted
]
