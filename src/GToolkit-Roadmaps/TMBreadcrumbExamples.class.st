Class {
	#name : #TMBreadcrumbExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #examples }
TMBreadcrumbExamples >> databaseNode [
	<gtExample>
	^ self topicMap databaseNode
]

{ #category : #examples }
TMBreadcrumbExamples >> databaseNodeBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self databaseNode breadcrumb.
	self assert: breadcrumb equals: self defaultBreadcrumb.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> defaultBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self topicMap defaultBreadcrumb.
	self assert: breadcrumb size equals: 1.
	self assert: breadcrumb isEmpty not.
	self assert: breadcrumb databaseNode notNil.
	self assert: breadcrumb fieldNode isNil.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> emptyBreadcrumb [
	"An empty breadcrumb may arise if we jump into a kind node or page node without following any path."

	<gtExample>
	| breadcrumb |
	breadcrumb := TMBreadcrumb for: {}.
	self assert: breadcrumb size equals: 0.
	self assert: breadcrumb isEmpty.
	self assert: breadcrumb databaseNode isNil.
	self assert: breadcrumb fieldNode isNil.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> fieldNode [
	<gtExample>
	^ TopicMapExamples new fieldNodeGtBasics
]

{ #category : #examples }
TMBreadcrumbExamples >> fieldNodeBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self fieldNode breadcrumb.
	self assert: breadcrumb size equals: 2.
	self assert: breadcrumb isEmpty not.
	self assert: breadcrumb databaseNode notNil.
	self assert: breadcrumb fieldNode notNil.
	self assert: breadcrumb topicNode isNil.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> kindNodeWithContext [
	<gtExample>
	| node |
	node := self kindNodeWithoutContext.
	node withContext: self topicNodeBreadcrumb.
	self assert: node breadcrumb isEmpty not.
	^ node
]

{ #category : #examples }
TMBreadcrumbExamples >> kindNodeWithContextBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self kindNodeWithContext breadcrumb.
	self assert: breadcrumb size equals: 4.
	self assert: breadcrumb isEmpty not.
	self assert: breadcrumb databaseNode notNil.
	self assert: breadcrumb fieldNode notNil.
	self assert: breadcrumb topicNode notNil.
	self assert: breadcrumb kindNode notNil.
	self assert: breadcrumb pageNode isNil.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> kindNodeWithoutContext [
	<gtExample>
	| node |
	node := TopicMapExamples new kindNodeIntroductionWithinAboutGtTopic.
	self assert: node breadcrumb isEmpty.
	^ node
]

{ #category : #examples }
TMBreadcrumbExamples >> kindNodeWithoutContextBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self kindNodeWithoutContext breadcrumb.
	self assert: breadcrumb isEmpty.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> nodeGroupNode [
	<gtExample>
	^ TopicMapExamples new nodeGroupChildrenOfFieldNodeGtBasics
]

{ #category : #examples }
TMBreadcrumbExamples >> nodeGroupNodeBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self nodeGroupNode breadcrumb.
	self assert: breadcrumb isEmpty.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> pageGroupFromQueryNode [
	<gtExample>
	^ TopicMapExamples new smaccQuery
]

{ #category : #examples }
TMBreadcrumbExamples >> pageGroupNode [
	<gtExample>
	^ TopicMapExamples new pageGroupChildrenOfKindsWithinAboutGt
]

{ #category : #examples }
TMBreadcrumbExamples >> pageGroupNodeBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self pageGroupNode breadcrumb.
	self assert: breadcrumb isEmpty.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> pageNodeFromTopicNode [
	"Simulate clicking on a node of a topic roadmap to pick out a page.
	This will propagate the breadcrumb."

	<gtExample>
	| pageNode |
	pageNode := self topicNode roadmapNodesWithContext
			detect: [ :n | n isTMPageNode and: [ n page title = 'A short history of Glamorous Toolkit' ] ].
	self assert: pageNode breadcrumb isEmpty not.
	^ pageNode
]

{ #category : #examples }
TMBreadcrumbExamples >> pageNodeWithContext [
	<gtExample>
	| node |
	node := self pageNodeWithoutContext.
	node withContext: self topicNodeBreadcrumb.
	self assert: node breadcrumb ~= self emptyBreadcrumb.
	^ node
]

{ #category : #examples }
TMBreadcrumbExamples >> pageNodeWithContextBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self pageNodeWithContext breadcrumb.
	self assert: breadcrumb size equals: 5.
	self assert: breadcrumb isEmpty not.
	self assert: breadcrumb databaseNode notNil.
	self assert: breadcrumb fieldNode notNil.
	self assert: breadcrumb topicNode notNil.
	self assert: breadcrumb kindNode notNil.
	self assert: breadcrumb pageNode notNil.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> pageNodeWithoutContext [
	<gtExample>
	| node |
	node := TopicMapExamples new pageNodeWhatIsGt.
	self assert: node breadcrumb equals: self emptyBreadcrumb.
	^ node
]

{ #category : #examples }
TMBreadcrumbExamples >> pageNodeWithoutContextBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self pageNodeWithoutContext breadcrumb.
	self assert: breadcrumb isEmpty.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> topicMap [
	<gtExample>
	^ TopicMapExamples new topicMap
]

{ #category : #examples }
TMBreadcrumbExamples >> topicNode [
	<gtExample>
	^ TopicMapExamples new topicNodeAboutGt
]

{ #category : #examples }
TMBreadcrumbExamples >> topicNodeBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self topicNode breadcrumb.
	self assert: breadcrumb size equals: 3.
	self assert: breadcrumb isEmpty not.
	self assert: breadcrumb databaseNode notNil.
	self assert: breadcrumb fieldNode notNil.
	self assert: breadcrumb topicNode notNil.
	self assert: breadcrumb kindNode isNil.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> umappedPagesNode [
	<gtExample>
	| nodeGroup |
	nodeGroup := TopicMapExamples new topicMap unmappedPages.
	self assert: nodeGroup topicNodes isEmpty.
	self assert: nodeGroup fieldNodes isEmpty.
	self assert: nodeGroup kindNodes isEmpty.
	self assert: nodeGroup roadmapNodes asSet equals: nodeGroup nodes asSet.
	^ nodeGroup
]
