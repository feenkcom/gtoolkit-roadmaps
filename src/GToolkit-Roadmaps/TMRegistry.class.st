"
I provide a registry of topic maps for Lepiter databases.

The actual registry is a a Dictionary that maps the names of databases to the path (String) of the topicMap file relative to `FileLocator gtResource``.

By default there is just a topic map for the GT book. More entries can be added by accessing the `registry` slot.

To enable views and actions, evaluate:
```
TMRegistry uniqueInstance enableActions
```

"
Class {
	#name : #TMRegistry,
	#superclass : #Object,
	#traits : 'TGtEnableExtensions',
	#classTraits : 'TGtEnableExtensions classTrait',
	#instVars : [
		'registry',
		'extensionsEnabled'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #initialization }
TMRegistry >> defaultRegistry [
	^ {'Glamorous Toolkit Book' -> 'feenkcom/gtoolkit-roadmaps/data/gtbookTopicMap.json'}
		asDictionary
]

{ #category : #views }
TMRegistry >> gtRegistryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Topic Map Registry';
		priority: 20;
		items: [ [ self registry ] value associations ];
		column: 'Database' text: [ :each | each key gtDisplayString ];
		column: 'Topic Map File' text: [ :each | each value gtDisplayString ];
		send: [ :each | FileLocator gtResource / each value ];
		actionUpdateButton
]

{ #category : #testing }
TMRegistry >> hasTopicMapFor: aDatabaseName [
	^ self registry includesKey: aDatabaseName
]

{ #category : #initialization }
TMRegistry >> initialize [
	super initialize.
	registry := self defaultRegistry.
	self disableExtensions
]

{ #category : #accessing }
TMRegistry >> jsonFileFor: aDatabaseName [
	^ FileLocator gtResource / (self jsonFilePathFor: aDatabaseName)
]

{ #category : #accessing }
TMRegistry >> jsonFilePathFor: aDatabaseName [
	^ self registry at: aDatabaseName
]

{ #category : #accessing }
TMRegistry >> registry [
	^ registry
]

{ #category : #accessing }
TMRegistry >> topicMapFor: aDatabaseName [
	^ TopicMap forJson: (self jsonFileFor: aDatabaseName)
]
