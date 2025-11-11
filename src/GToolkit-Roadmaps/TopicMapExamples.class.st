"
I contain TopicMap examples based on a a frozen state of the GT book topic map, containing some missing (renamed) pages for testing purposes.
The main instance is `TopicMapExamples new topicMap`.

The other examples test that the various derived maps and queries work as expected.
"
Class {
	#name : #TopicMapExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #example }
TopicMapExamples >> database [
	<gtExample>
	| database |
	database := self topicMap database.
	self
		assert: database 
		equals: LeDatabase gtBook.
	^ database
]

{ #category : #example }
TopicMapExamples >> databaseNode [
	<gtExample>
	| databaseNode |
	databaseNode := self topicMap databaseNode.
	self assert: databaseNode fields size equals: 5.
	self assert: databaseNode children isTMNodeGroup.
	self assert: databaseNode children isTMPageGroup not.
	self assert: databaseNode parents isEmpty.
	^ databaseNode
]

{ #category : #example }
TopicMapExamples >> field2Topics [
	<gtExample>
	| fields2Topics topicMap |
	topicMap := self topicMap.
	fields2Topics := topicMap field2Topics.
	self assert: fields2Topics size equals: 5.
	^ fields2Topics
]

{ #category : #example }
TopicMapExamples >> fieldNodeGtBasics [
	"NB: Fragile test, #topics could change in book."

	<gtExample>
	| fieldNodeGtBasics |
	fieldNodeGtBasics := self topicMap fieldNodeNamed: 'Glamorous Toolkit Basics'.
	self assert: fieldNodeGtBasics topics size equals: 10.
	self assert: fieldNodeGtBasics kinds size equals: 11.
	self
		assert: fieldNodeGtBasics pages size < fieldNodeGtBasics database pages size.
	self assert: fieldNodeGtBasics children isTMTreeNode.
	self assert: fieldNodeGtBasics children isTMPageGroup not.
	self assert: fieldNodeGtBasics parents size equals: 1.
	self assert: fieldNodeGtBasics parents first equals: self databaseNode.
	^ fieldNodeGtBasics
]

{ #category : #example }
TopicMapExamples >> json [
	"Verify that this is the commented test topicFile."

	<gtExample>
	| json |
	json := self topicMap json.
	self assert: (json includesKey: 'comment').
	^ json
]

{ #category : #example }
TopicMapExamples >> kind2Pages [
	<gtExample>
	| category2Page topicMap |
	topicMap := self topicMap.
	category2Page := topicMap kind2Pages.
	self assert: category2Page size equals: topicMap kinds size.
	^ category2Page
]

{ #category : #example }
TopicMapExamples >> kindNodeIntroduction [
	<gtExample>
	| aboutGtKindNode |
	aboutGtKindNode := self topicMap kindNodeNamed: 'Introduction'.

	self assert: aboutGtKindNode fields size equals: 5.
	self assert: aboutGtKindNode topics size equals: 36.
	self assert: aboutGtKindNode kinds size equals: 1.
	self assert: aboutGtKindNode pages size < aboutGtKindNode database pages size.
	self assert: aboutGtKindNode children isTMNodeGroup.
	self assert: aboutGtKindNode children isTMPageGroup.

	^ aboutGtKindNode
]

{ #category : #example }
TopicMapExamples >> kindNodeIntroductionWithinAboutGtTopic [
	"NB: Since pages can have multiple topics, a kind within 
	a topic can branch to multiple other topics and fields,
	as is the case here."

	<gtExample>
	| aboutGtKindNode |
	aboutGtKindNode := (TMKindNode for: 'Introduction' in: self topicMap)
			pageContext: self topicNodeAboutGt pageGroup;
			yourself.

	self
		assert: aboutGtKindNode
		equals: (self topicNodeAboutGt kindNodes nodes detect: [ :n | n kind = 'Introduction' ]).
	self assert: aboutGtKindNode fields size equals: 3.
	self assert: aboutGtKindNode topics size equals: 10.
	self assert: aboutGtKindNode kinds size equals: 1.
	self assert: aboutGtKindNode pages size < aboutGtKindNode database pages size.
	self assert: aboutGtKindNode children isTMNodeGroup.
	self assert: aboutGtKindNode children isTMPageGroup.
	
	^ aboutGtKindNode
]

{ #category : #example }
TopicMapExamples >> kinds [
	<gtExample>
	| categories |
	categories := self topicMap kinds.
	self assert: categories size equals: 11.
	^ categories
]

{ #category : #example }
TopicMapExamples >> missingPages [
	<gtExample>
	| missingPages topicMap |
	topicMap := self topicMap.
	missingPages := topicMap missingPages.
	self assert: missingPages size + topicMap pages size equals: (topicMap json at: 'pages') size.
	^ missingPages
]

{ #category : #example }
TopicMapExamples >> mondrianGraph4Database [
	"Very slow (~12s), so noTest."

	<gtExample>
	<noTest>
	| mondrianTree |
	mondrianTree := self databaseNode mondrianGraph.
	^ mondrianTree
]

{ #category : #example }
TopicMapExamples >> mondrianGraph4Field [
	"Slow (3s), so noTest."

	<gtExample>
	<noTest>
	| mondrianTree |
	mondrianTree := self fieldNodeGtBasics mondrianGraph.
	^ mondrianTree
]

{ #category : #example }
TopicMapExamples >> mondrianTree4Database [
	"Very slow (20s), so noTest."

	<gtExample>
	<noTest>
	| mondrianTree |
	mondrianTree := self databaseNode mondrianTree.
	^ mondrianTree
]

{ #category : #example }
TopicMapExamples >> mondrianTree4Field [
	"Slow (3s), so noTest."

	<gtExample>
	<noTest>
	| mondrianTree |
	mondrianTree := self fieldNodeGtBasics mondrianTree.
	^ mondrianTree
]

{ #category : #example }
TopicMapExamples >> nodeGroupChildrenOfFieldNodeGtBasics [
	"NB: Fragile test, #topics could change in book."

	<gtExample>
	| nodeGroup |
	nodeGroup := self fieldNodeGtBasics children.
	self assert: nodeGroup size equals: 10.
	self assert: nodeGroup isTMTreeNode.
	self assert: nodeGroup isTMNodeGroup.
	self assert: nodeGroup isTMPageGroup not.
	self assert: nodeGroup children isTMNodeGroup.
	self assert: nodeGroup children isTMPageGroup not.
	^ nodeGroup
]

{ #category : #example }
TopicMapExamples >> nodeGroupWithAllNodeTypes [
	<gtExample>
	| nodeGroup |
	nodeGroup := self topicMap newNodeGroup.
	nodeGroup
		addDatabaseNode;
		addFieldNodeNamed: 'Glamorous Toolkit Basics';
		addTopicNodeNamed: 'About Glamorous Toolkit';
		addKindNodeNamed: 'Introduction';
		addPageNodeWithTitle: 'Glamorous Toolkit'.

	self assert: nodeGroup size equals: 5.
	self assert: nodeGroup isTMTreeNode.
	self assert: nodeGroup isTMNodeGroup.
	self assert: nodeGroup isTMPageGroup not.
	self assert: nodeGroup children isTMNodeGroup.
	self assert: nodeGroup children isTMPageGroup not.

	^ nodeGroup
]

{ #category : #example }
TopicMapExamples >> nodeGroupWithFieldsAndTopics [
	"NB: Fragile test, #topics could change in book."

	<gtExample>
	| nodeGroup |
	nodeGroup := self fieldNodeGtBasics children
			addNodeGroup: self databaseNode children;
			yourself.

	self assert: nodeGroup size equals: 15.
	self assert: nodeGroup isTMTreeNode.
	self assert: nodeGroup isTMNodeGroup.
	self assert: nodeGroup isTMPageGroup not.
	self assert: nodeGroup children isTMNodeGroup.
	self assert: nodeGroup children isTMPageGroup not.
	
	^ nodeGroup
]

{ #category : #example }
TopicMapExamples >> page2Kind [
	<gtExample>
	| page2Kind |
	page2Kind := self topicMap page2Kind.
	self assert: page2Kind size equals: self page2Topics size.
	^ page2Kind
]

{ #category : #example }
TopicMapExamples >> page2Topics [
	<gtExample>
	| page2Topics topicMap |
	topicMap := self topicMap.
	page2Topics := topicMap page2Topics.
	self
		assert: page2Topics size
		equals: (topicMap json at: 'pages') size - topicMap missingPages size.
	^ page2Topics
]

{ #category : #example }
TopicMapExamples >> pageGroupChildrenOfKindsWithinAboutGt [
	<gtExample>
	| pageGroup |
	pageGroup := self kindNodeIntroductionWithinAboutGtTopic children.
	self assert: pageGroup size equals: 6.
	self assert: pageGroup isTMTreeNode.
	self assert: pageGroup isTMNodeGroup.
	self assert: pageGroup isTMPageGroup.
	self assert: pageGroup children isTMNodeGroup.
	self assert: pageGroup children isTMPageGroup.
	^ pageGroup
]

{ #category : #example }
TopicMapExamples >> pageGroupFromTopicMap [
	"Not a useful page group as it is too cluttered."

	<gtExample>
	| pageGroup |
	pageGroup := self topicMap pageGroup.
	self assert: pageGroup isTMPageGroup.
	^ pageGroup
]

{ #category : #example }
TopicMapExamples >> pageNodeWhatIsGt [
	"NB: No breadcrumb."

	<gtExample>
	| pageNodeWhatIsGt |
	pageNodeWhatIsGt := TMPageNode
			forTitle: 'What is Glamorous Toolkit?'
			in: self topicMap.

	self assert: pageNodeWhatIsGt fields size equals: 3.
	self assert: pageNodeWhatIsGt topics size equals: 5.
	self assert: pageNodeWhatIsGt kinds size equals: 1.
	self assert: pageNodeWhatIsGt pages size equals: 1.
	self assert: pageNodeWhatIsGt children isTMNodeGroup.
	self assert: pageNodeWhatIsGt children isTMPageGroup not.
	self assert: pageNodeWhatIsGt parents equals: pageNodeWhatIsGt kindNodes.
	self assert: pageNodeWhatIsGt breadcrumb isEmpty.
	
	^ pageNodeWhatIsGt
]

{ #category : #example }
TopicMapExamples >> pageNodeWhatIsGtViaTopicAboutGt [
	"Same as pageNodeWhatIsGt but with breadcrumb."

	<gtExample>
	| pageNodeWhatIsGt |
	pageNodeWhatIsGt := self topicNodeAboutGt
			pageNodeWithTitle: 'What is Glamorous Toolkit?'.

	self assert: pageNodeWhatIsGt fields size equals: 3.
	self assert: pageNodeWhatIsGt topics size equals: 5.
	self assert: pageNodeWhatIsGt kinds size equals: 1.
	self assert: pageNodeWhatIsGt pages size equals: 1.
	self assert: pageNodeWhatIsGt children isTMNodeGroup.
	self assert: pageNodeWhatIsGt children isTMPageGroup not.
	self assert: pageNodeWhatIsGt parents equals: pageNodeWhatIsGt kindNodes.
	self assert: pageNodeWhatIsGt breadcrumb notEmpty.
	
	^ pageNodeWhatIsGt
]

{ #category : #example }
TopicMapExamples >> pages [
	"NB: missing pages are filtered out."

	<gtExample>
	| pages |
	pages := self topicMap pages.
	self assert: pages size equals: self page2Topics size.
	self assert: pages isTMPageGroup not.
	^ pages
]

{ #category : #example }
TopicMapExamples >> smaccQuery [
	"NB: fragile query. Results depend on the GT Book content."

	<gtExample>
	| query databaseNode smaccQuery |
	query := 'SmaCC'.
	databaseNode := self topicMap databaseNode.
	smaccQuery := databaseNode contentIncludes: query.
	self assert: smaccQuery fields size equals: 5.
	self assert: smaccQuery children isTMNodeGroup.
	self assert: smaccQuery children isTMPageGroup.
	self assert: smaccQuery parents isNotEmpty.
	^ smaccQuery
]

{ #category : #example }
TopicMapExamples >> tempTopicMap [
	"NB: the temp file must be deleted explicitly."

	<gtExample>
	<noTest>
	| topicMap |
	topicMap := TopicMap forJson: self tempTopicMapTestFile.
	self assert: topicMap database equals: LeDatabase gtBook.
	self assert: topicMap missingPages notNil.
	^ topicMap
]

{ #category : #example }
TopicMapExamples >> tempTopicMapTestFile [
	"Create a copy of the test data file with a new random file name.
	NB: the temp file must be deleted explicitly."

	<gtExample>
	<noTest>
	| origFile tempFile |
	origFile := self topicMapTestFile.
	origFile := TopicMapExamples new topicMapTestFile.
	tempFile := origFile
			copyWithPath: origFile path , (10000 atRandom printString , '-temp.json').
	tempFile ensureDelete.
	origFile copyTo: tempFile.
	^ tempFile
]

{ #category : #example }
TopicMapExamples >> topic2Pages [
	<gtExample>
	| topicMap topic2Pages |
	topicMap := self topicMap.
	topic2Pages := self topicMap topic2Pages.
	self pages
		do: [ :aPage | 
			(topicMap topics4Page: aPage)
				do: [ :aTopic | self assert: ((topicMap pages4Topic: aTopic) includes: aPage) ] ].
	^ topic2Pages
]

{ #category : #example }
TopicMapExamples >> topicMap [
	<gtExample>
	| topicMap |
	topicMap := TopicMap forJson: self topicMapTestFile.
	self assert: topicMap database equals: LeDatabase gtBook.
	self assert: topicMap missingPages size > 0.
	^ topicMap
]

{ #category : #example }
TopicMapExamples >> topicMapEntities [
	<gtExample>
	<noTest>
	| topicMapEntities |
	topicMapEntities := self topicMapEntityExamples collect: #returnValue.	"topicMapEntities
		do: [ :t | self assert: (Smalltalk compiler evaluate: t storeString) equals: t ]."
	^ topicMapEntities
]

{ #category : #example }
TopicMapExamples >> topicMapEntityExamples [
	"A bit slow at around 5s, so <noTest>."

	<gtExample>
	<noTest>
	| exampleGroup thisMethod topicMapEntityExamples |
	thisMethod := thisContext stack first method.
	self assert: thisMethod equals: TopicMapExamples >> #topicMapEntityExamples.

	exampleGroup := GtExplicitExampleGroup
			withAll: (self class package gtExamplesAllContained
					reject: [ :eg | eg method = thisMethod or: [ eg method hasPragmaNamed: 'noTest' ] ]).
	topicMapEntityExamples := exampleGroup examples
			select: [ :eg | eg returnValue isTopicMapEntity ].
	^ topicMapEntityExamples
]

{ #category : #example }
TopicMapExamples >> topicMapTestFile [
	"NB: This test file for the GT Book is a frozen snapshop. 
	It is *not* intended to match the current state of the book. 
	In fact, some tests depend on mismatches existing between the pages in the book and version of the topic map."

	<gtExample>
	^ FileLocator gtResource / 'feenkcom/gtoolkit-roadmaps/data/topicMapTestExample.json'
]

{ #category : #example }
TopicMapExamples >> topicNodeAboutGt [
	"NB: Fragile test, #kinds could change in book."

	<gtExample>
	| topicNodeaAboutGt |
	topicNodeaAboutGt := self fieldNodeGtBasics
			topicNodeNamed: 'About Glamorous Toolkit'.
	self assert: topicNodeaAboutGt fields size equals: 1.
	self assert: topicNodeaAboutGt topics size equals: 1.
	self assert: topicNodeaAboutGt kinds size equals: 5.
	self
		assert: topicNodeaAboutGt pages size < topicNodeaAboutGt database pages size.
	self assert: topicNodeaAboutGt children isTMNodeGroup.
	self assert: topicNodeaAboutGt children isTMPageGroup.
	self assert: topicNodeaAboutGt parents size equals: 1.
	self assert: topicNodeaAboutGt parents first equals: self fieldNodeGtBasics.
	^ topicNodeaAboutGt
]
