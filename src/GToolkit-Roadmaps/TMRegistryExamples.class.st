Class {
	#name : #TMRegistryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #examples }
TMRegistryExamples >> gtBookJsonFile [
	<gtExample>
	| fileReference |
	fileReference := self tmRegistrySingelton jsonFileFor: LeDatabase gtBookName.
	self assert: fileReference exists.
	^ fileReference
]

{ #category : #examples }
TMRegistryExamples >> gtBookJsonFilePath [
	<gtExample>
	| filePath |
	filePath := self tmRegistrySingelton jsonFilePathFor: LeDatabase gtBookName.
	self assert: (filePath endsWith: '.json').
	^ filePath
]

{ #category : #examples }
TMRegistryExamples >> gtBookTopicMap [
	"TopicMap for all pages from the test file."

	<gtExample>
	| gtBookTopicMap |
	gtBookTopicMap := self tmRegistrySingelton topicMapFor: LeDatabase gtBookName.
	^ gtBookTopicMap
]

{ #category : #examples }
TMRegistryExamples >> tmRegistrySingelton [
	<gtExample>
	| tmRegistry |
	tmRegistry := TMRegistry uniqueInstance.
	self assert: tmRegistry registry size equals: 1.
	self assert: (tmRegistry hasTopicMapFor: LeDatabase gtBookName).
	^ tmRegistry
]
