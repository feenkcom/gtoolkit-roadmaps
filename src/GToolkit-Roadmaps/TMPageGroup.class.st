"
I am like my parent, but specifically contain just pages.
"
Class {
	#name : #TMPageGroup,
	#superclass : #TMNodeGroup,
	#instVars : [
		'queryString'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMPageGroup class >> for: aPageCollection in: aTopicMap [
	^ self new
		topicMap: aTopicMap;
		pages: aPageCollection;
		yourself
]

{ #category : #testing }
TMPageGroup >> isTMPageGroup [
	^ true
]

{ #category : #accessing }
TMPageGroup >> nodeLabel [
	^ 'Page group', self queryString
]

{ #category : #navigation }
TMPageGroup >> pageGroup [
	^ self
]

{ #category : #navigation }
TMPageGroup >> pages [
	"Each node is a TMPageNode"

	^ nodes collect: #page
]

{ #category : #initialization }
TMPageGroup >> pages: aPageCollection [
	"Wrap the pages as nodes."

	^ self
		nodes: (aPageCollection collect: [ :aPage | TMPageNode for: aPage in: self topicMap ])
]

{ #category : #accessing }
TMPageGroup >> queryString [
	^ queryString ifNil: [ queryString := '' ]
]

{ #category : #accessing }
TMPageGroup >> queryString: aString [
	queryString := ' query: ', aString
]

{ #category : #utility }
TMPageGroup >> sortedByStyles [
	| sortedPages |
	sortedPages := OrderedCollection new.
	self stylesStandardOrder
		do: [ :aStyle | sortedPages addAll: (self nodes select: [ :n | n style = aStyle ]) ].
	^ sortedPages
]

{ #category : #treemaps }
TMPageGroup >> treeMapChildren [
	"Want to organize by styles -- fro some reason doesn't display styles in groups as it should."

	<todo: 'Debug the display of treeMaps for queries.'>
	^ self styleNodes
]

{ #category : #treemaps }
TMPageGroup >> treeMapLeaves [
	^ self
]
