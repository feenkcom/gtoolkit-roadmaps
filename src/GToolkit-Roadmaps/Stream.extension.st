Extension { #name : #Stream }

{ #category : #'*GToolkit-Roadmaps' }
Stream >> storeObject: anObject [
	"Have anObject store itself on the receiver (analogous to #print:, but avoiding conflicts with #store:)."

	anObject storeOn: self
]
