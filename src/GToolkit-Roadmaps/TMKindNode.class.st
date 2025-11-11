Class {
	#name : #TMKindNode,
	#superclass : #TMAbstractTreeNode,
	#instVars : [
		'kind',
		'pageContext'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TMKindNode class >> for: aString in: aTopicMap [
	"When the context is all of the pages of the topic map."

	^ self new
		kind: aString;
		topicMap: aTopicMap;
		pageContext: aTopicMap pageGroup;
		yourself
]

{ #category : #breadcrumbs }
TMKindNode >> breadcrumbForContext: aBreadcrumb [
	"Only if the topic of the previous roadmap's breadcrumb matches this kind,
	do we have a context for building a new breadcrumb."

	^ (self topicInContext: aBreadcrumb)
		ifTrue: [ TMBreadcrumb
				for: {aBreadcrumb databaseNode.
						aBreadcrumb fieldNode.
						aBreadcrumb topicNode.
						self} ]
		ifFalse: [ TMBreadcrumb for: {} ]
]

{ #category : #navigation }
TMKindNode >> children [
	^ self pageGroupFor: self pages	"^ self
		pageGroupFor: (self pages collect: [ :aPage | TMPageNode for: aPage in: self topicMap ])"
]

{ #category : #breadcrumbs }
TMKindNode >> defaultBreadcrumb [
	^ TMBreadcrumb for: {}
]

{ #category : #querying }
TMKindNode >> fields [
	^ (self topicNodes nodes flatCollect: #fields) copyWithoutDuplicates
]

{ #category : #help }
TMKindNode >> helpPageName [
	^ 'Topic Kind'
]

{ #category : #accessing }
TMKindNode >> kind [
	^ kind
]

{ #category : #accessing }
TMKindNode >> kind: anObject [
	kind := anObject
]

{ #category : #navigation }
TMKindNode >> kinds [
	^ {kind}
]

{ #category : #accessing }
TMKindNode >> nodeLabel [
	^ self kind
]

{ #category : #accessing }
TMKindNode >> nodeType [
	^ 'Kind'
]

{ #category : #accessing }
TMKindNode >> pageContext [
	"The page context is the restricted TMPageGroup we consider for this kind node,
	in case we don't want to have all the pages of the topic map.
	For example, within a given topic, we are only interested in the pages of that topic."

	^ pageContext
]

{ #category : #accessing }
TMKindNode >> pageContext: aPageGroup [
	pageContext := aPageGroup
]

{ #category : #querying }
TMKindNode >> pages [
	"NB: We only want the pages in *this* page group with this kind.
	Could we use the breadcrumb instead?
	"
	
	"self halt."

	^ self pageContext pages
		select: [ :aPage | (self topicMap kind4Page: aPage) = self kind ]
]

{ #category : #accessing }
TMKindNode >> parents [
	"Could we use the breadcrumb instead?"

	"^ self nodesFor: (self pageContext flatCollect: #parents) copyWithoutDuplicates"
	^ self topicNodes
]

{ #category : #roadmap }
TMKindNode >> roadmapNodeColor [
	^ self kindPalette at: self kind ifAbsent: Color veryLightGray
]

{ #category : #roadmap }
TMKindNode >> roadmapNodes [
	"Kind k in topic t:  d->d.f*->t.f.t*->t.k*->t[k].p*
	Kind k, no topic: d->k.p*.f*->k.p*.t*->k"

	| nodes root |
	"nodes := self pageGroup roadmapNodes."
	root := self databaseNode.
	nodes := self topicInBreadcrumb
			ifTrue: [ | topicNode |
				topicNode := self breadcrumb topicNode.
				root roadmapNodes , {topicNode} , topicNode kindNodes
					, (topicNode pageNodes select: [ :n | n kind = self kind ]) ]
			ifFalse: [ root roadmapNodes , self topicNodes , self kindNodes ].
	self highlightBreadcrumbsIn: nodes.
	^ nodes
]

{ #category : #printing }
TMKindNode >> storeOn: aStream [
<todo: 'Handle cases with pathContext and pageContext'>
	aStream
		nextPut: $(;
		storeObject: self topicMap;
		nextPutAll: ' kindNodeNamed: ';
		nextPutAll: self kind printString;
		nextPut: $)
]

{ #category : #printing }
TMKindNode >> storeOnNodeGroup: aStream [
	aStream
		nextPutAll: ' addKindNodeNamed: ';
		nextPutAll: self kind printString
]

{ #category : #querying }
TMKindNode >> topics [
	^ (self pageGroup flatCollect: #topics) copyWithoutDuplicates
]

{ #category : #treemaps }
TMKindNode >> treeMapChildren [
	"My children are leaves."

	^ self emptyNodes
]

{ #category : #treemaps }
TMKindNode >> treeMapLeaves [
	^ self pageGroup
]
