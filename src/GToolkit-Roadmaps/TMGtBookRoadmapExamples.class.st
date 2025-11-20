"
Examples to be used in documentation.

NB: These examples depend on the current state of the GT Book topic map, in contrast to `TopicMapExamples`, which use a frozen topic map test file, so they are all declared `<noTest>` to avoid issues with the build.
"
Class {
	#name : #TMGtBookRoadmapExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #examples }
TMGtBookRoadmapExamples >> aboutGtTopicNode [
	<gtExample>
	<noTest>
	<return: #TMTopicNode>
	| topicNode |
	topicNode := self gtBasicsFieldNode topicNodes first.
	self assert: topicNode topic equals: 'About Glamorous Toolkit'.
	^ topicNode
]

{ #category : #examples }
TMGtBookRoadmapExamples >> explainableSystemsTopicNode [
	"A small example with many dkinds of pages.
	NB: assertion is fragile -- might change."

	<gtExample>
	<noTest>
	<return: #TMTopicNode>
	| topicNode |
	topicNode := self gtBookTopicMap topicNodeNamed: 'Explainable Systems'.
	self assert: topicNode kindNodes size >= 7.
	^ topicNode
]

{ #category : #examples }
TMGtBookRoadmapExamples >> gtBasicsFieldNode [
	<gtExample>
	<noTest>
	<return: #TMFieldNode>
	| fieldNode |
	fieldNode := self gtBookDatabaseNode fieldNodes first.
	self assert: fieldNode field equals: 'Glamorous Toolkit Basics'.
	^ fieldNode
]

{ #category : #examples }
TMGtBookRoadmapExamples >> gtBookDatabaseNode [
	<gtExample>
	<noTest>
	<return: #TMDatabaseNode>
	| databaseNode |
	databaseNode := self gtBookTopicMap databaseNode.
	self
		assert: databaseNode database databaseName
		equals: 'Glamorous Toolkit Book'.
	^ databaseNode
]

{ #category : #examples }
TMGtBookRoadmapExamples >> gtBookTopicMap [
	<gtExample>
	<noTest>
	<return: #TopicMap>
	| topicMap |
	topicMap := TopicMap default.
	self assert: topicMap database databaseName equals: 'Glamorous Toolkit Book'.
	^ topicMap
]

{ #category : #examples }
TMGtBookRoadmapExamples >> jsonFile [
	<gtExample>
	<noTest>
	<return: #FileLocator>
	| jsonFile |
	jsonFile := self gtBookTopicMap jsonFile.
	^ jsonFile
]

{ #category : #examples }
TMGtBookRoadmapExamples >> kind2Pages [
	<gtExample>
	<noTest>
	<return: #Dictionary>
	| kind2Pages |
	kind2Pages := self gtBookTopicMap kind2Pages.
	self assert: kind2Pages keys asSet equals: self gtBookTopicMap kinds asSet.
	^ kind2Pages
]

{ #category : #examples }
TMGtBookRoadmapExamples >> rustQuery [
	"NB: fragile query. Results depend on the GT Book content."

	<gtExample>
	<noTest>
	<return: #TMPageGroup>
	| query databaseNode rustQuery |
	query := 'Rust'.
	databaseNode := self gtBookDatabaseNode.
	rustQuery := databaseNode contentIncludes: query.
	self assert: rustQuery fields size > 2.
	self assert: rustQuery children isTMNodeGroup.
	self assert: rustQuery children isTMPageGroup.
	self assert: rustQuery parents isNotEmpty.
	^ rustQuery
]

{ #category : #examples }
TMGtBookRoadmapExamples >> smaccQuery [
	"NB: fragile query. Results depend on the GT Book content."

	<gtExample>
	<noTest>
	<return: #TMPageGroup>
	| query databaseNode smaccQuery |
	query := 'SmaCC'.
	databaseNode := self gtBookDatabaseNode.
	smaccQuery := databaseNode contentIncludes: query.
	self assert: smaccQuery fields size equals: 5.
	self assert: smaccQuery children isTMNodeGroup.
	self assert: smaccQuery children isTMPageGroup.
	self assert: smaccQuery parents isNotEmpty.
	^ smaccQuery
]

{ #category : #examples }
TMGtBookRoadmapExamples >> whatIsGtPageNode [
	"We search globally for the pageNode, without traversing a specific topic."

	<gtExample>
	<noTest>
	<return: #TMPageNode>
	| pageNode |
	pageNode := self gtBookTopicMap pageNodeWithTitle: 'What is Glamorous Toolkit?'.
	self assert: pageNode title equals: 'What is Glamorous Toolkit?'.
	^ pageNode
]

{ #category : #examples }
TMGtBookRoadmapExamples >> whatIsGtPageNodeWithinAboutGtTopic [
	<gtExample>
	<noTest>
	<return: #TMPageNode>
	| pageNode parentTopicNode |
	parentTopicNode := self aboutGtTopicNode.
	pageNode := parentTopicNode roadmapNodes
			detect: [ :n | n isTMPageNode and: [ n title = 'What is Glamorous Toolkit?' ] ].
	self assert: pageNode title equals: 'What is Glamorous Toolkit?'.
	^ pageNode
]
