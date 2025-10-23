Class {
	#name : #TMBreadcrumbExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #examples }
TMBreadcrumbExamples >> breadcrumbWithDatabaseNode [
	<gtExample>
	| breadcrumb |
	breadcrumb := self emptyBreadcrumb.
	breadcrumb addNode: self gtBookTopicMap databaseNode.
	self assert: breadcrumb size equals: 1.
	self assert: breadcrumb nodes isEmpty not.
	self assert: breadcrumb equals: self gtBookBreadcrumb.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> emptyBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := TMBreadcrumb new.
	self assert: breadcrumb size equals: 0.
	self assert: breadcrumb nodes isEmpty.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> gtBookBreadcrumb [
	<gtExample>
	| breadcrumb |
	breadcrumb := TMBreadcrumb for: self gtBookTopicMap.
	self assert: breadcrumb size equals: 1.
	self assert: breadcrumb nodes isEmpty  not.
	^ breadcrumb
]

{ #category : #examples }
TMBreadcrumbExamples >> gtBookTopicMap [
	<gtExample>
	^ LeDatabase gtBook topicMap
]
