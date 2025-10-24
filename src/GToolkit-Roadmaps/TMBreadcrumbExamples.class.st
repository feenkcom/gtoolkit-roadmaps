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
	self assert: breadcrumb nodes isEmpty not.
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
	self assert: breadcrumb nodes isEmpty.
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
	self assert: breadcrumb nodes isEmpty not.
	self assert: breadcrumb databaseNode notNil.
	self assert: breadcrumb fieldNode notNil.
	self assert: breadcrumb topicNode isNil.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> kindNodeWithPathContext [
	<gtExample>
	| node |
	node := self kindNodeWithoutPathContext.
	node pathContext: self topicNodeBreadcrumb.
	self assert: node pathContext ~= self emptyBreadcrumb.
	^ node
]

{ #category : #examples }
TMBreadcrumbExamples >> kindNodeWithPathContextBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self kindNodeWithPathContext breadcrumb.
	self assert: breadcrumb size equals: 4.
	self assert: breadcrumb nodes isEmpty not.
	self assert: breadcrumb databaseNode notNil.
	self assert: breadcrumb fieldNode notNil.
	self assert: breadcrumb topicNode notNil.
	self assert: breadcrumb kindNode notNil.
	self assert: breadcrumb pageNode isNil.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> kindNodeWithoutPathContext [
	<gtExample>
	| node |
	node := TopicMapExamples new kindNodeIntroductionWithinAboutGtTopic.
	self assert: node pathContext equals: self emptyBreadcrumb.
	^ node
]

{ #category : #examples }
TMBreadcrumbExamples >> kindNodeWithoutPathContextBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self kindNodeWithoutPathContext breadcrumb.
	self assert: breadcrumb equals: self emptyBreadcrumb.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> pageNodeWithPathContext [
	<gtExample>
	| node |
	node := self pageNodeWithoutPathContext.
	node pathContext: self topicNodeBreadcrumb.
	self assert: node pathContext ~= self emptyBreadcrumb.
	^ node
]

{ #category : #examples }
TMBreadcrumbExamples >> pageNodeWithPathContextBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self pageNodeWithPathContext breadcrumb.
	self assert: breadcrumb size equals: 5.
	self assert: breadcrumb nodes isEmpty not.
	self assert: breadcrumb databaseNode notNil.
	self assert: breadcrumb fieldNode notNil.
	self assert: breadcrumb topicNode notNil.
	self assert: breadcrumb kindNode notNil.
	self assert: breadcrumb pageNode notNil.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> pageNodeWithoutPathContext [
	<gtExample>
	| node |
	node := TopicMapExamples new pageNodeWhatIsGt.
	self assert: node pathContext equals: self emptyBreadcrumb.
	^ node
]

{ #category : #examples }
TMBreadcrumbExamples >> pageNodeWithoutPathContextBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := self pageNodeWithoutPathContext breadcrumb.
	self assert: breadcrumb equals: self emptyBreadcrumb.
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
	self assert: breadcrumb nodes isEmpty not.
	self assert: breadcrumb databaseNode notNil.
	self assert: breadcrumb fieldNode notNil.
	self assert: breadcrumb topicNode notNil.
	self assert: breadcrumb kindNode isNil.
	^ breadcrumb
]
