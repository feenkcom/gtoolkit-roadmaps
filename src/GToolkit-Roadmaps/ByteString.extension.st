Extension { #name : #ByteString }

{ #category : #'*GToolkit-Roadmaps' }
ByteString >> asPrompt [
	^ PCSimplePrompt new
		promptString: self;
		yourself
]
