Class {
	#name : #TMKindNode,
	#superclass : #TMAbstractTreeNode,
	#instVars : [
		'kind',
		'context'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMKindNode class >> for: aString in: aTopicMap [
	"When the context is all of the pages of the topic map."

	^ self new
		kind: aString;
		topicMap: aTopicMap;
		context: aTopicMap pageGroup;
		yourself
]

{ #category : #'instance creation' }
TMKindNode class >> for: aString in: aTopicMap within: aPageGroup [
	"When the context is provided by some parent, eg a specific topic and its pages."

	^ self new
		kind: aString;
		topicMap: aTopicMap;
		context: aPageGroup;
		yourself
]

{ #category : #navigation }
TMKindNode >> children [
	^ self pageGroupFor: self pages	"^ self
		pageGroupFor: (self pages collect: [ :aPage | TMPageNode for: aPage in: self topicMap ])"
]

{ #category : #accessing }
TMKindNode >> context [
	^ context
]

{ #category : #accessing }
TMKindNode >> context: aPageGroup [
	context := aPageGroup
]

{ #category : #querying }
TMKindNode >> fields [
	^ (self topicNodes nodes flatCollect: #fields) copyWithoutDuplicates
]

{ #category : #accessing }
TMKindNode >> kind [
	^ kind
]

{ #category : #accessing }
TMKindNode >> kind: anObject [
	kind := anObject
]

{ #category : #navigation }
TMKindNode >> kinds [
	^ {kind}
]

{ #category : #accessing }
TMKindNode >> nodeLabel [
	^ "'Kind '," self kind
]

{ #category : #querying }
TMKindNode >> pages [
	"NB: We only want the pages in *this* page group with this kind."

	^ self context pages
		select: [ :aPage | (self topicMap kind4Page: aPage) = self kind ]
]

{ #category : #accessing }
TMKindNode >> parents [
	^ self nodesFor: (self context flatCollect: #parents) copyWithoutDuplicates
]

{ #category : #roadmap }
TMKindNode >> roadmapNodeColor [
	^ self kindPalette at: self kind ifAbsent: Color veryLightGray
]

{ #category : #roadmap }
TMKindNode >> roadmapNodes [
	"Show the roadmap for the context pages with this kind."

	^ self pageGroup roadmapNodes
]

{ #category : #roadmap }
TMKindNode >> roadmapWithKindNodes [

	^ self pageGroup roadmapWithKindNodes, { self }
]

{ #category : #querying }
TMKindNode >> topics [
	^ (self pageGroup flatCollect: #topics) copyWithoutDuplicates
]

{ #category : #treemaps }
TMKindNode >> treeMapChildren [
	"My children are leaves."

	^ self emptyNodes
]

{ #category : #treemaps }
TMKindNode >> treeMapLeaves [
	^ self pageGroup
]
