Class {
	#name : #TMPageGroupExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #examples }
TMPageGroupExamples >> gtBookTestPageGroup [
	"PageGroup for all pages from the test file."

	<gtExample>
	| pageGroup topicMap |
	topicMap := self gtBookTestTopicMap.
	pageGroup := topicMap pageGroup.
	self assert: pageGroup pages size equals: topicMap pages size.
	^ pageGroup
]

{ #category : #examples }
TMPageGroupExamples >> gtBookTestTopicMap [
	"TopicMap for all pages from the test file."

	<gtExample>
	^ TopicMapExamples new topicMap
]

{ #category : #examples }
TMPageGroupExamples >> pageGroup [
	<gtExample>
	| pageNodes |
	pageNodes := self gtBookTestPageGroup pageGroup.
	self assert: pageNodes size equals: self gtBookTestPageGroup pages size.
	^ pageNodes
]

{ #category : #examples }
TMPageGroupExamples >> projectDiaryPageNode [
	<gtExample>
	| projectDiaryPageNode |
	projectDiaryPageNode := self pageGroup pageNodeWithTitle: 'Project Diary' .
	self assert: projectDiaryPageNode page title equals: 'Project Diary'.
	self assert: projectDiaryPageNode kind equals: 'Pattern'.
	self
		assert: projectDiaryPageNode topics asSet
		equals: #('Using Lepiter' 'Live Documentation' 'Moldable Development Practices' 'Examples and Documentation')
				asSet.
	^ projectDiaryPageNode
]
