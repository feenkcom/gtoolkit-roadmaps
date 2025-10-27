"
Examples to be used in documentation.
NB: These examples depend on the current state of the GT Book topic map, in contrast to `TopicMapExamples`, which use a frozen topic map test file.
"
Class {
	#name : #TMGtBookRoadmapExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #'as yet unclassified' }
TMGtBookRoadmapExamples >> aboutGtTopicNode [
	<gtExample>
	| topicNode |
	topicNode := self gtBasicsFieldNode topicNodes first.
	self assert: topicNode topic equals: 'About Glamorous Toolkit'.
	^ topicNode
]

{ #category : #accessing }
TMGtBookRoadmapExamples >> explainableSystemsTopicNode [
	"A small example with many dkinds of pages.
	NB: assertion is fragile -- might change."

	<gtExample>
	| topicNode |
	topicNode := self gtBookTopicMap topicNodeNamed: 'Explainable Systems'.
	self assert: topicNode kindNodes size >= 9.
	^ topicNode
]

{ #category : #'as yet unclassified' }
TMGtBookRoadmapExamples >> gtBasicsFieldNode [
	<gtExample>
	| fieldNode |
	fieldNode := self gtBookDatabaseNode fieldNodes first.
	self assert: fieldNode field equals: 'Glamorous Toolkit Basics'.
	^ fieldNode
]

{ #category : #'as yet unclassified' }
TMGtBookRoadmapExamples >> gtBookDatabaseNode [
	<gtExample>
	| databaseNode |
	databaseNode := self gtBookTopicMap databaseNode.
	self assert: databaseNode database databaseName equals: 'Glamorous Toolkit Book'.
	^ databaseNode
]

{ #category : #'as yet unclassified' }
TMGtBookRoadmapExamples >> gtBookTopicMap [
	<gtExample>
	| topicMap |
	topicMap := LeDatabase gtBook topicMap.
	self assert: topicMap database databaseName equals: 'Glamorous Toolkit Book'.
	^ topicMap
]

{ #category : #accessing }
TMGtBookRoadmapExamples >> kind2Pages [
	<gtExample>
	| kind2Pages |
	kind2Pages := self gtBookTopicMap kind2Pages.
	self assert: kind2Pages keys asSet equals: self gtBookTopicMap kinds asSet.
	^ kind2Pages
]

{ #category : #'as yet unclassified' }
TMGtBookRoadmapExamples >> rustQuery [
	"NB: fragile query. Results depend on the GT Book content."

	<gtExample>
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

{ #category : #'as yet unclassified' }
TMGtBookRoadmapExamples >> smaccQuery [
	"NB: fragile query. Results depend on the GT Book content."

	<gtExample>
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

{ #category : #'as yet unclassified' }
TMGtBookRoadmapExamples >> whatIsGtPageNode [
	"We search globally for the pageNode, without traversing a specific topic."

	<gtExample>
	| pageNode |
	pageNode := self gtBookTopicMap pageNodeWithTitle: 'What is Glamorous Toolkit?'.
	self assert: pageNode title equals: 'What is Glamorous Toolkit?'.
	^ pageNode
]

{ #category : #'as yet unclassified' }
TMGtBookRoadmapExamples >> whatIsGtPageNodeWithinAboutGtTopic [
	<gtExample>
	| pageNode parentTopicNode |
	parentTopicNode := self aboutGtTopicNode.
	pageNode := parentTopicNode roadmapNodes
			detect: [ :n | n isTMPageNode and: [ n title = 'What is Glamorous Toolkit?' ] ].
	self assert: pageNode title equals: 'What is Glamorous Toolkit?'.
	^ pageNode
]
