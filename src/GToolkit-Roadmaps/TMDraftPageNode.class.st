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
TMDraftPageNode >> addToTopic [
	^ self topicMap addDraftPage: self
]

{ #category : #accessing }
TMDraftPageNode >> addToTopicMap [
	"| topicMapPages |
	topicMapPages := self topicMap json at: 'pages'.
	self
		assert: (topicMapPages select: [ :d | (d at: 'page') = self page title ]) isEmpty.
	self topicMap json at: 'pages' put: (topicMapPages copyWith: self json).
	self topicMap clearCaches.
	^ self topicMap pageNodeWithTitle: self page title"

	^ self topicMap addDraftPage: self
]

{ #category : #accessing }
TMDraftPageNode >> json [
	"Generate JSON from draft to add to topicMap"

	^ {'page' -> self page title.
		'kind' -> self kind.
		'topics' -> self topics} asDictionary
]

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
TMDraftPageNode >> topics: aTopicArray [
	topics := aTopicArray
]

{ #category : #updating }
TMDraftPageNode >> updateKindTo: aKindString [
	self kind: aKindString
]
