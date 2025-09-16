Extension { #name : #Dictionary }

{ #category : #'*GToolkit-Roadmaps-LLM' }
Dictionary >> asPrompt [
	"NB: convert the examples JSON back into a dictionary."

	^ (self includesKey: 'examples')
		ifTrue: [ PCExampleBasedPrompt new
				promptString: (self at: 'promptString');
				exampleDatabaseNamed: (self at: 'exampleDatabaseName');
				examples: ((self at: 'examples') collect: [ :d | (d at: 'pageName') -> (d at: 'answer') ])
						asDictionary;
				yourself ]
		ifFalse: [ (self at: 'promptString') asPrompt ]
]
