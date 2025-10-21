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
		'topicClassifier',
		'unmappedPages',
		'announcer'
	],
	#category : #'GToolkit-Roadmaps-LLM-Model'
}

{ #category : #'instance creation' }
TMClassifier class >> for: aTopicMap [
	^ self new
		topicMap: aTopicMap;
		yourself
]

{ #category : #accessing }
TMClassifier >> announcer [
	^ announcer
]

{ #category : #examples }
TMClassifier >> exampleDatabaseName [
	<gtExample>
	<noTest>
	^ PageClassifierExamples new exampleDatabaseName
]

{ #category : #views }
TMClassifier >> gtKindClassifierFor: aView [
	<gtView>
	^ aView forward
		title: 'Kind classifier';
		priority: 20;
		object: [ self kindClassifier ];
		view: #gtChatsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect Page classifier'
			action: [ :aButton :aTab | aButton phlow spawnObject: self kindClassifier ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Run  classifier'
			action: [ :aButton | self kindClassifier requestResults ]
]

{ #category : #views }
TMClassifier >> gtPagesFor: aView [
	<gtView>
	^ aView forward
		title: 'Unmapped pages';
		priority: 10;
		object: [ self unmappedPages ];
		view: #gtTopicTreeFor:;
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Run classifiers'
			action: [ :aButton :aTab | 
				self kindClassifier requestResults.
				self topicClassifier requestResults ];
		actionButtonIcon: BrGlamorousVectorIcons save
			tooltip: 'Save updates to Topic Map'
			action: [ :aButton :aTab | 
				self unmappedPages addPagesToTopicMap.
				aButton phlow spawnObject: self topicMap ];
		updateWhen: PCResultsUpdatedAnnouncement in: self announcer
]

{ #category : #views }
TMClassifier >> gtTopicClassifierFor: aView [
	<gtView>
	^ aView forward
		title: 'Topic classifier';
		priority: 30;
		object: [ self topicClassifier ];
		view: #gtChatsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect Page classifier'
			action: [ :aButton :aTab | aButton phlow spawnObject: self topicClassifier ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Run  classifier'
			action: [ :aButton | self topicClassifier requestResults ]
]

{ #category : #initialization }
TMClassifier >> initialize [
	super initialize.
	announcer := Announcer new.
]

{ #category : #factory }
TMClassifier >> kindClassifier [
	<gtExample>
	<noTest>
	^ kindClassifier
		ifNil: [ kindClassifier := self pageClassiferFor: 'Kind' withPrompt: self kindPrompt.
			kindClassifier announcer
				when: PCResultsUpdatedAnnouncement
				send: #resultsUpdated
				to: self.
			kindClassifier ]
]

{ #category : #examples }
TMClassifier >> kindExamples [
	<gtExample>
	<noTest>
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
	<noTest>
	^ PCExampleBasedPrompt new
		promptString: self kindPromptString;
		exampleDatabaseNamed: self exampleDatabaseName;
		examples: self kindExamples;
		yourself
]

{ #category : #examples }
TMClassifier >> kindPromptString [
	"Adapted from CategoryClassifierExperiments>>#cat4DetailedPrompt3"

	<gtExample>
	<noTest>
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

{ #category : #announcements }
TMClassifier >> notifyResultsUpdated [
	self announcer announce: PCResultsUpdatedAnnouncement new
]

{ #category : #factory }
TMClassifier >> pageClassiferFor: aResultType withPrompt: aPrompt [
	| json |
	json := {'resultType' -> aResultType.
			'bookName' -> self topicMap database databaseName.
			'prompt' -> aPrompt jsonObject.
			'chats'
				-> (self unmappedPages
						collect: [ :p | 
							{'pageName' -> p title.
								'results' -> Array new} asDictionary ]) asArray} asDictionary.
	^ PageClassifier newFromJson: json
]

{ #category : #announcements }
TMClassifier >> resultsUpdated [
	self storeKindClassifierResults.
	self storeTopicClassifierResults.
	self notifyResultsUpdated
]

{ #category : #updating }
TMClassifier >> storeKindClassifierResults [
	^ (self kindClassifier jsonObject at: 'chats')
		collect: [ :d | 
			(d at: 'results')
				ifNotEmpty: [ (self unmappedPages pageNodeWithTitle: (d at: 'pageName'))
						kind: (d at: 'results') first ] ]
]

{ #category : #updating }
TMClassifier >> storeTopicClassifierResults [
	^ (self topicClassifier jsonObject at: 'chats')
		collect: [ :d | 
			(d at: 'results')
				ifNotEmpty: [ (self unmappedPages pageNodeWithTitle: (d at: 'pageName'))
						topics: (d at: 'results') ] ]
]

{ #category : #factory }
TMClassifier >> topicClassifier [
	<gtExample>
	<noTest>
	^ topicClassifier
		ifNil: [ topicClassifier := self pageClassiferFor: 'Topic' withPrompt: self topicPrompt.
			topicClassifier announcer
				when: PCResultsUpdatedAnnouncement
				send: #resultsUpdated
				to: self.
			topicClassifier ]
]

{ #category : #accessing }
TMClassifier >> topicMap [
	^ topicMap ifNil: [ topicMap := LeDatabase gtBook topicMap ]
]

{ #category : #accessing }
TMClassifier >> topicMap: anObject [
	topicMap := anObject
]

{ #category : #examples }
TMClassifier >> topicPrompt [
	<gtExample>
	<noTest>
	^ self topicPromptString asPrompt
]

{ #category : #examples }
TMClassifier >> topicPromptString [
	"Adapted from TopicClassifierExperiments>>#top4TopicDescriptionPrompt"

	<gtExample>
	<noTest>
	| writeStream |
	writeStream := '' writeStream.
	writeStream
		nextPutAll: 'The Glamorous Toolkit (GT) Book consists of over 500 notebook pages documenting various aspects of Moldable Development and the GT IDE that supports it.

A typical newcomer to GT is either:
(i) someone who has heard of GT, and would like to learn more about it, but has no particular  goal in mind, or
(ii) someone with a specific problem to solve, whether work-related or a personal hobby project.
We want to provide newcomers with a roadmap of the pages organized around a set of GT-related topics.

The topic of a page refers to its subject matter, for example, "Using Bloc", or Programming Smalltalk", not the style or format of the page, such as "Tutorial" or "FAQ".

A good topic is high-level enough that we can assign multiple pages to a topic, but specific enough to be useful for finding relevant pages.

Your job is to assign topics from a curated list to a given page, so that pages can be organized into clusters by topic. Each page will cover at least one topic, but possible more, as topics cross-cut multiple dimensions. Please provide only a single topic per page, unless the page clearly covers more than one topic, in which case a maximum of five topics may be listed. You should only assign topics from the curated list, unless there is no topic that fits, in which case you may propose a topic not on the list. In your results, simply list the topics for the page and do not provide any further explanations.

Here is the list of curated topics:';
		lf;
		lf;
		nextPutAll: '```';
		lf.
	self topics
		do: [ :topic | 
			writeStream
				nextPutAll: topic;
				lf ].
	writeStream nextPutAll: '```'.
	^ writeStream contents
]

{ #category : #examples }
TMClassifier >> topics [
	<gtExample>
	<noTest>
	^ self topicMap topics sorted
]

{ #category : #accessing }
TMClassifier >> unmappedPages [
	^ unmappedPages ifNil: [ unmappedPages := self topicMap unmappedPages ]
]
