"
I am modeled after the classifier experiments `CategoryClassifierExperiments>>#cat4DetailedPromptCategoryClassifier4`.

I can be used to classify unmapped pages.
"
Class {
	#name : #TMClassifier,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-LLM-Model'
}

{ #category : #examples }
TMClassifier >> gtBookTopicMap [
	<gtExample>
	| topicMap |
	topicMap := LeDatabase gtBook topicMap.
	self assert: topicMap database databaseName equals: 'Glamorous Toolkit Book'.
	^ topicMap
]
