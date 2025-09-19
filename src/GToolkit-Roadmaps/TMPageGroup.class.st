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

{ #category : #querying }
TMPageGroup >> contentIncludes: query [
	^ (self
		pageGroupFor: (self pages select: [ :p | p asMarkdownPage includesSubstring: query ]))
		queryString: query;
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

{ #category : #roadmap }
TMPageGroup >> roadmapWithKindNodes [
	^ self roadmapNodes
		, (self pageGroup flatCollect: #kindNodes) copyWithoutDuplicates
]

{ #category : #utility }
TMPageGroup >> sortedByKinds [
	| sortedPages |
	sortedPages := OrderedCollection new.
	self kindsStandardOrder
		do: [ :aKind | sortedPages addAll: (self nodes select: [ :n | n kind = aKind ]) ].
	^ sortedPages
]

{ #category : #querying }
TMPageGroup >> titleIncludes: query [
	^ (self
		pageGroupFor: (self pages select: [ :p | p title includesSubstring: query ]))
		queryString: query;
		yourself
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
