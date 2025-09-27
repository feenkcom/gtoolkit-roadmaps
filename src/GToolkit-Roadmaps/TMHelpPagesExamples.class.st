Class {
	#name : #TMHelpPagesExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #'as yet unclassified' }
TMHelpPagesExamples >> helpDatabase [
	<gtExample>
	^ LeDatabase gtBook topicMap helpDatabase
]

{ #category : #'as yet unclassified' }
TMHelpPagesExamples >> invalidHelpPageNameMethods [
	"This should never fail, but should be empty. If not, the methods returned need to be fixed."

	<gtExample>
	| helpPageNameMethods |
	helpPageNameMethods := (#helpPageName gtImplementors
			& TopicMap package gtPackageMatches) contents.
	^ helpPageNameMethods
		reject: [ :m | 
			| pageTitle |
			pageTitle := m valueWithReceiver: m methodClass new arguments: #().
			self helpDatabase hasPageNamed: pageTitle ]
]

{ #category : #'as yet unclassified' }
TMHelpPagesExamples >> noInvalidHelpPageNameMethods [
	<gtExample>
	| invalidMethods |
	invalidMethods := self invalidHelpPageNameMethods.
	self
		assert: invalidMethods isEmpty
		description: 'Invalid pages referenced in: ' , invalidMethods printString.
	^ self
]
