Extension { #name : #ByteString }

{ #category : #'*GToolkit-Roadmaps-LLM' }
ByteString >> asPrompt [
	^ PCSimplePrompt new
		promptString: self;
		yourself
]
