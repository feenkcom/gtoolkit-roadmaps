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

{ #category : #navigation }
TMPageGroup >> children [
	"Or just return self?"

	"^ self pageGroupFor: self pages"
	
	^ self
]

{ #category : #help }
TMPageGroup >> helpPageName [
	^ 'Topic Page Group'
]

{ #category : #testing }
TMPageGroup >> isTMPageGroup [
	^ true
]

{ #category : #printing }
TMPageGroup >> newNodeGroupSelector [
	^ #newPageGroup
]

{ #category : #accessing }
TMPageGroup >> nodeLabel [
	^ 'Page group', self queryString
]

{ #category : #accessing }
TMPageGroup >> nodeType [
	^ 'Page group'
]

{ #category : #navigation }
TMPageGroup >> pageGroup [
	^ self
]

{ #category : #navigation }
TMPageGroup >> pages [
	"Each node is a TMPageNode, so get the actual LePage."

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
TMPageGroup >> sortedByKinds [
	| sortedPages |
	sortedPages := OrderedCollection new.
	self kindsStandardOrder
		do: [ :aKind | sortedPages addAll: (self nodes select: [ :n | n kind = aKind ]) ].
	^ sortedPages
]

{ #category : #treemaps }
TMPageGroup >> treeMapChildren [
	"Want to organize pages by kinds."

	<todo: 'Debug the display of treeMaps for queries.'>
	^ self kindNodes
]

{ #category : #treemaps }
TMPageGroup >> treeMapLeaves [
	^ self
]

{ #category : #'as yet unclassified' }
TMPageGroup >> treeMapRoots [
	^ self kindNodes
]
