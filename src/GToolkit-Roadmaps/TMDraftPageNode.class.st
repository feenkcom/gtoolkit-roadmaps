Class {
	#name : #TMDraftPageNode,
	#superclass : #TMPageNode,
	#instVars : [
		'kind',
		'topics'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #accessing }
TMDraftPageNode >> kind [
	^ kind
]

{ #category : #accessing }
TMDraftPageNode >> kind: anObject [
	kind := anObject
]

{ #category : #'as yet unclassified' }
TMDraftPageNode >> kinds [
	^ self kind = nil
		ifTrue: [ {} ]
		ifFalse: [ {self kind} ]
]

{ #category : #'as yet unclassified' }
TMDraftPageNode >> relatedInfo [
	self kind ifNil: [ ^ '(draft page)' ].
	^ super relatedInfo
]

{ #category : #updating }
TMDraftPageNode >> toggleTopic: aTopicString [
	self topics: (self topicsToggling: aTopicString)
]

{ #category : #accessing }
TMDraftPageNode >> topics [
	^ topics ifNil: [ topics := Array new ]
]

{ #category : #accessing }
TMDraftPageNode >> topics: anObject [
	topics := anObject
]

{ #category : #updating }
TMDraftPageNode >> updateKindTo: aKindString [
	self kind: aKindString
]
