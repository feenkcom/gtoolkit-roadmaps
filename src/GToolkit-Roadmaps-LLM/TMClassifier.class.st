"
I am modeled after the classifier experiments `CategoryClassifierExperiments>>#cat4DetailedPromptCategoryClassifier4`.

I can be used to classify unmapped pages.
"
Class {
	#name : #TMClassifier,
	#superclass : #Object,
	#instVars : [
		'kindClassifier',
		'topicMap',
		'pageGroup'
	],
	#category : #'GToolkit-Roadmaps-LLM-Model'
}

{ #category : #'instance creation' }
TMClassifier class >> for: aTopicMap [
	^ self new
		topicMap: aTopicMap;
		yourself
]

{ #category : #examples }
TMClassifier >> exampleDatabaseName [
	<gtExample>
	^ PageClassifierExamples new exampleDatabaseName
]

{ #category : #views }
TMClassifier >> gtKindClassifierFor: aView [
	<gtView>
	^ aView forward
		title: 'Kind classifier';
		object: [ self kindClassifier ];
		view: #gtChatsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect Page classifier'
			action: [ :aButton :aTab | aButton phlow spawnObject: self kindClassifier ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Run  classifier'
			action: [ :aButton | self kindClassifier requestResults ]
]

{ #category : #factory }
TMClassifier >> kindClassifier [
	<gtExample>
	^ kindClassifier
		ifNil: [ kindClassifier := self pageClassiferFor: 'Kind' withPrompt: self kindPrompt ]
]

{ #category : #examples }
TMClassifier >> kindExamples [
	^ {'Glamorous Toolkit' -> 'Introduction'.
		'Getting started with GT in 7''' -> 'Media'.
		'Working with a REST API: the GitHub case study' -> 'Case study'.
		'Treemap' -> 'Examples'.
		'A gentle introduction to Pharo Smalltalk' -> 'Tutorial'.
		'Contextual View' -> 'Pattern'.
		'How do I recover my work after a crash?' -> 'FAQ'.
		'How to pages related to GemStone' -> 'Index'.
		'Coder' -> 'Definition'.
		'Java' -> 'Tag'.
		'Basic shortcuts' -> 'Documentation'} asDictionary
]

{ #category : #examples }
TMClassifier >> kindPrompt [
	<gtExample>
	^ PCExampleBasedPrompt new
		promptString: self kindPromptString;
		exampleDatabaseNamed: self exampleDatabaseName;
		examples: self kindExamples;
		yourself
]

{ #category : #examples }
TMClassifier >> kindPromptString [
	^ 'The Glamorous Toolkit Book consists of numerous notebook pages documenting various aspects of Moldable Development and the Glamorous Toolkit (GT) IDE that supports it.
We are interested in categorizing the pages according to the kind of information they contain.

Here is a description of each of the categories:

- Introduction: a page that introduces a topic, usually with little or no code.
- Media: a page pointing the reader to a slideshow or an on-line video for a given topic.
- Case study: a page describing an existing case study that illustrates a topic, with detailed code examples.
- Examples: a page listing one or more examples of a tool or technique, but not a proper case study.
- Tutorial: a page containing a step-by-step series of explanations and exercises with code to teach the reader about a topic. Whereas a case study focuses on a specific application, a tutorial focuses on how to acquire a specific skill. A tutorial often takes the form of an exercise to be performed by the reader.
- Pattern: a pattern describes a recurring design problem and its solution. A pattern must include sections describing the Context, the Problem, Forces, and Solution, and may also have sections Steps and Examples.
- FAQ: a page containing a "how to" question related to a topic, with a detailed answer to just that question. The title will often start with "How to".
- Index: a structuring page that serves only to point to or list other pages.
- Definition: a page whose title is a term and whose contents consists of a concise definition of that term.
- Tag: a page whose title consist of a single word identifying a topic, and little or no contents, to be used as a tag in other pages on that topic. A tag never has a title of more than two words.
- Documentation: a page containing a technical description, a set of metrics, release notes, or other details of some component or API.

Your task is to assign a category to a page provided as input. A single answer is preferred, but in case of doubt, please propose two, or at most three alternatives.

Note that the category Video is preferred instead of Tutorial or FAQ, and FAQ is preferred over Definition.
The category Documentation should be used as a default only if none of the other categories fits.
Do not propose any new categories.

In your answers, simply provide the category without any further explanation.

Below follows a series of examples of User inputs consisting of notebook page contents, and the expected Assistant category as an answer.'
]

{ #category : #factory }
TMClassifier >> pageClassiferFor: aResultType withPrompt: aPrompt [
	| json |
	json := {'resultType' -> aResultType.
			'bookName' -> self topicMap database databaseName.
			'prompt' -> aPrompt jsonObject.
			'chats'
				-> (self pageGroup
						collect: [ :p | 
							{'pageName' -> p title.
								'results' -> Array new} asDictionary ]) asArray} asDictionary.
	^ PageClassifier newFromJson: json
]

{ #category : #accessing }
TMClassifier >> pageGroup [
	^ pageGroup ifNil: [ pageGroup := self topicMap unmappedPages ]
]

{ #category : #accessing }
TMClassifier >> pageGroup: anObject [
	pageGroup := anObject
]

{ #category : #accessing }
TMClassifier >> topicMap [
	^ topicMap ifNil: [ topicMap := LeDatabase gtBook topicMap ]
]

{ #category : #accessing }
TMClassifier >> topicMap: anObject [
	topicMap := anObject
]
