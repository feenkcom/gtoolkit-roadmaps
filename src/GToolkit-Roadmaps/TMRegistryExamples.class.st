Class {
	#name : #TMRegistryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #'as yet unclassified' }
TMRegistryExamples >> gtBookTopicMap [
	"TopicMap for all pages from the test file."

	<gtExample>
	| gtBookTopicMap |
	gtBookTopicMap := TMRegistry uniqueInstance topicMapFor: LeDatabase gtBookName.
	^ gtBookTopicMap
]

{ #category : #'as yet unclassified' }
TMRegistryExamples >> tmRegistrySingelton [
	<gtExample>
	| tmRegistry |
	tmRegistry := TMRegistry uniqueInstance.
	self assert: tmRegistry registry size equals: 1.
	self assert: (tmRegistry hasTopicMapFor: LeDatabase gtBookName).
	^ tmRegistry
]
