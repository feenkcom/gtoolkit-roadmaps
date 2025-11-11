"
These examples illustrate how we can edit a topic map and its underlying JSON.

Use cases:
- pages: change kind or topic
- topics: change field, rename; add or delete topics
- fields: rename field; split field; add or delete fields

"
Class {
	#name : #TMEditingExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #examples }
TMEditingExamples >> changeFieldOfLiveDocumentationTopicNode [
	<gtExample>
	| topicNode newField topic oldField |
	topic := 'Live Documentation'.
	topicNode := self topicMap topicNodeNamed: topic.
	oldField := topicNode field.
	newField := 'Moldable Development topics'.

	self assert: oldField equals: 'Glamorous Toolkit Basics'.

	topicNode changeFieldTo: newField.

	self assert: topicNode field equals: newField.
	self
		assert: (self updatedTopicMap topicNodeNamed: topic) field
		equals: newField.
		
	topicNode changeFieldTo: oldField.

	self assert: topicNode field equals: oldField.
	self
		assert: (self updatedTopicMap topicNodeNamed: topic) field
		equals: oldField.

	^ topicNode
]

{ #category : #examples }
TMEditingExamples >> clonedTestJsonFile [
	"A clone of the current gtBook Json topic map.
	After each edit, we can check if the json file has been updated."

	<gtExample>
	| sourceJsonFile testJsonFile |
	sourceJsonFile := self sourceJsonFile.
	testJsonFile := self testJsonFile.
	testJsonFile ensureDelete.
	sourceJsonFile copyTo: testJsonFile.
	self assert: testJsonFile exists.
	^ testJsonFile
]

{ #category : #examples }
TMEditingExamples >> deleteMissingPage [
	<gtExample>
	| missingPageTitle topicMap missingPageCount updatedTopicMap |
	topicMap := self topicMap.
	missingPageTitle := self missingPage.
	missingPageCount := topicMap missingPages size.

	self assert: (topicMap missingPages includes: missingPageTitle).

	topicMap deleteMissingPageWithTitle: missingPageTitle.

	self assert: (topicMap missingPages includes: missingPageTitle) not.
	self assert: topicMap missingPages size equals: missingPageCount - 1.
	updatedTopicMap := self updatedTopicMap.
	self assert: (updatedTopicMap missingPages includes: missingPageTitle) not.
	self assert: updatedTopicMap missingPages size equals: missingPageCount - 1.

	^ updatedTopicMap
]

{ #category : #examples }
TMEditingExamples >> deletedTestJsonFile [
	<gtExample>
	| testJsonFile |
	testJsonFile := self testJsonFile.
	testJsonFile ensureDelete.
	self assert: testJsonFile exists not.
	^ testJsonFile
]

{ #category : #examples }
TMEditingExamples >> feenkPageNode [
	<gtExample>
	| pageNode |
	pageNode := self topicMap pageNodeWithTitle: 'feenk'.
	self assert: pageNode title equals: 'feenk'.
	self assert: pageNode kind equals: 'Introduction'.
	self assert: pageNode topicNodes size equals: 3.
	^ pageNode
]

{ #category : #examples }
TMEditingExamples >> missingPage [
	<gtExample>
	| missingPageTitle |
	missingPageTitle := self topicMap missingPages first.
	self assert: missingPageTitle equals: 'Adding custom tools to assistants'.
	^ missingPageTitle
]

{ #category : #examples }
TMEditingExamples >> sourceJsonFile [
	"As a source we use not the current GT book topic map json, but rather the older snapshot
	that contains some entries that need to be edited."

	^ TopicMapExamples new topicMapTestFile
]

{ #category : #examples }
TMEditingExamples >> testJsonFile [
	"A clone of the current gtBook Json topic map.
	After each edit, we can check if the json file has been updated."

	<gtExample>
	| testJsonFile |
	testJsonFile := FileLocator imageDirectory / 'test.json'.
	^ testJsonFile
]

{ #category : #examples }
TMEditingExamples >> toggleTopicsOfFeenkPageNode [
	<gtExample>
	| pageNode topicToAdd topicToDelete updatedTopicMap topic2ToAdd |
	pageNode := self feenkPageNode.
	topicToAdd := 'Code Analysis'.
	topic2ToAdd := 'Building Custom Tools'.
	topicToDelete := 'About Glamorous Toolkit'.

	self assert: pageNode topics size equals: 3.
	self assert: (pageNode topics includes: topicToAdd) not.
	self assert: (pageNode topics includes: topic2ToAdd) not.

	pageNode toggleTopic: topicToAdd.
	pageNode toggleTopic: topic2ToAdd.
	pageNode toggleTopic: topicToDelete.

	self assert: pageNode topics size equals: 4.
	self assert: (pageNode topics includes: topicToDelete) not.
	self assert: (pageNode topics includes: topicToAdd).
	self assert: (pageNode topics includes: topic2ToAdd).
	updatedTopicMap := self updatedTopicMap.
	self assert: (updatedTopicMap pageNodeWithTitle: 'feenk') topics size equals: 4.
	self
		assert: ((updatedTopicMap pageNodeWithTitle: 'feenk') topics includes: topicToDelete)
				not.
	self
		assert: ((updatedTopicMap pageNodeWithTitle: 'feenk') topics includes: topicToAdd).
	self
		assert: ((updatedTopicMap pageNodeWithTitle: 'feenk') topics includes: topic2ToAdd).

	^ pageNode
]

{ #category : #examples }
TMEditingExamples >> topicMap [
	<gtExample>
	| topicMap |
	topicMap := TopicMap forJson: self clonedTestJsonFile.
	self assert: topicMap database equals: LeDatabase gtBook.
	^ topicMap
]

{ #category : #examples }
TMEditingExamples >> updateKindOfFeenkPageNode [
	<gtExample>
	| pageNode |
	pageNode := self feenkPageNode.
	self assert: pageNode kind equals: 'Introduction'.

	pageNode updateKindTo: 'Definition'.

	self assert: pageNode kind equals: 'Definition'.
	self
		assert: (self updatedTopicMap pageNodeWithTitle: 'feenk') kind
		equals: 'Definition'.

	^ pageNode
]

{ #category : #examples }
TMEditingExamples >> updateMissingPage [
	<gtExample>
	| missingPageTitle topicMap newPage newTitle missingPageCount updatedTopicMap |
	topicMap := self topicMap.
	missingPageTitle := self missingPage.
	newPage := topicMap closestUnmappedPageFor: missingPageTitle.
	newTitle := 'Adding tools to assistants'.
	missingPageCount := topicMap missingPages size.

	self assert: (topicMap missingPages includes: missingPageTitle).
	self assert: (topicMap pages includes: newPage) not.
	self assert: newPage title equals: newTitle.

	topicMap updateMissingTitle: missingPageTitle.

	self assert: (topicMap missingPages includes: missingPageTitle) not.
	self assert: topicMap missingPages size equals: missingPageCount - 1.
	self assert: (topicMap pages includes: newPage).
	updatedTopicMap := self updatedTopicMap.
	self assert: (updatedTopicMap missingPages includes: missingPageTitle) not.
	self assert: updatedTopicMap missingPages size equals: missingPageCount - 1.
	self assert: (updatedTopicMap pages includes: newPage).

	^ updatedTopicMap
]

{ #category : #examples }
TMEditingExamples >> updatedTopicMap [
	"Returns the topic map for a possibly updated version of the test json file."

	<gtExample>
	^ TopicMap forJson: self testJsonFile
]
