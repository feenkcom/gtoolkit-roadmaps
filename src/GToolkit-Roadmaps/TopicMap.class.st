"
I am responsible for mapping Lepiter database pages to their topics and styles.

I am initialized from a JSON file that contains this mapping, as well as the list of fields grouping the various topics.

"
Class {
	#name : #TopicMap,
	#superclass : #TMAbstractEntity,
	#instVars : [
		'jsonFile',
		'json',
		'database',
		'page2Topics',
		'topic2Pages',
		'topic2Field',
		'page2Kind',
		'field2Topics',
		'monitor',
		'kind2Pages'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #'instance creation' }
TopicMap class >> default [
	^ self forGtBook
]

{ #category : #loading }
TopicMap class >> ensureLlmLoaded [
	"To wait for this to complete, just send #wait to the result."

	| semaphore |
	semaphore := Semaphore new.
	self llmPackage isLoaded
		ifTrue: [ semaphore signal ]
		ifFalse: [ [ UIManager default
				informUser: 'Loading GtoolkitRoadmapsLLM package'
				during: [ Metacello new
						repository: 'github://feenkcom/gtoolkit-roadmaps:main/src';
						baseline: 'GtoolkitRoadmapsLLM';
						load.
					#BaselineOfGtoolkitRoadmapsLLM asClass loadLepiterGtbookExamples ].
			semaphore signal ] fork ].
	^ semaphore
]

{ #category : #'instance creation' }
TopicMap class >> forGtBook [
	^ LeDatabase gtBook topicMap
]

{ #category : #'instance creation' }
TopicMap class >> forJson: aFileReference [
	^ self new
		jsonFile: aFileReference;
		yourself
]

{ #category : #views }
TopicMap class >> gtInstanceButtonFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: 'Inspect GT Book Topic Map';
		priority: 10;
		icon: BrGlamorousVectorIcons playinspect;
		action: [ :aButton | aButton phlow spawnObject: self forGtBook]
]

{ #category : #loading }
TopicMap class >> llmPackage [
	"To test if loaded, or to quickly load or unload."

	^ (IceRepository registry detect: [ :repo | repo name = 'gtoolkit-roadmaps' ])
		packageNamed: 'GToolkit-Roadmaps-LLM'
]

{ #category : #updating }
TopicMap >> addDraftPage: aDraftPage [
	| topicMapPages |
	self
		assert: aDraftPage kind isNotNil
		description: 'Page “', aDraftPage page title , '” is missing a kind.'.
	self
		assert: (self kinds includes: aDraftPage kind)
		description: aDraftPage kind , ' is not a valid page kind for page “' , aDraftPage page title, '”'.
	self
		assert: aDraftPage topics isNotEmpty
		description: 'Page “', aDraftPage page title , '” is missing topics.'.
	topicMapPages := self json at: 'pages'.
	self
		assert: (topicMapPages select: [ :d | (d at: 'page') = aDraftPage page title ]) isEmpty.
	self json at: 'pages' put: (topicMapPages copyWith: aDraftPage json).
	self clearCaches.
	self writeJsonFile.
	^ self pageNodeWithTitle: aDraftPage page title
]

{ #category : #utility }
TopicMap >> clearCaches [
	"If we update the json and write it out, we need to clear the caches so they will be updated too."

	database := nil.
	field2Topics := nil.
	topic2Pages := nil.
	topic2Field := nil.
	kind2Pages := nil.
	page2Topics := nil.
	page2Kind := nil.
]

{ #category : #querying }
TopicMap >> closestUnmappedPageFor: aMissingTitle [
	"Find the unmapped page whose title has the smallest edit distance to a title of a missing page."

	| pages |
	pages := self unmappedPages pages.
	self assert: pages isNotEmpty description: 'There are no unmapped pages to search.'.

	^ ((pages
		collect: [ :aPage | 
			{GtLevenshtein distanceBetween: aPage title and: aMissingTitle.
				aPage} ]) sortedAs: #first) first second
]

{ #category : #accessing }
TopicMap >> database [
	^ database
		ifNil: [ database := LeDatabase databaseNamed: (self json at: 'database') ]
]

{ #category : #views }
TopicMap >> databaseNode [
	^ TMDatabaseNode for: self database
]

{ #category : #breadcrumbs }
TopicMap >> defaultBreadcrumb [
	^ self databaseNode breadcrumb
]

{ #category : #querying }
TopicMap >> defaultValue [
	"Default value for lookups that fail (missing kind, topic etc)."

	^ '<unknown>'
]

{ #category : #updating }
TopicMap >> deleteMissingPageWithTitle: aTitle [
	| newPages index |
	index := (self json at: 'pages') detectIndex: [ :d | (d at: 'page') = aTitle ].
	newPages := (self json at: 'pages') copyWithoutIndex: index.
	self json at: 'pages' put: newPages.
	self assert: (self jsonDict4PageTitle: aTitle ifNone: [ nil ]) isNil.
	self clearCaches.
	self writeJsonFile
]

{ #category : #querying }
TopicMap >> emptyKindPages [
	"This group should always be empty -- only unmapped pages should be missing kinds."

	^ self pageGroupFor: (self pageNodes select: [ :n | n kinds isEmpty ])
]

{ #category : #querying }
TopicMap >> emptyTopicPages [
	"This group should always be empty -- only unmapped pages should be missing topics."

	^ self pageGroupFor: (self pageNodes select: [ :n | n topics isEmpty ])
]

{ #category : #accessing }
TopicMap >> field2Topics [
	^ field2Topics
		ifNil: [ field2Topics := ((self json at: 'fields')
					collect: [ :d | (d at: 'field') -> (d at: 'topics') ]) asDictionary ]
]

{ #category : #querying }
TopicMap >> field4Topic: aTopic [
	^ self topic2Field at: aTopic ifAbsent: self defaultValue
]

{ #category : #accessing }
TopicMap >> fields [
	"NB: respect the order of the fields in the JSON file."

	^ (self json at: 'fields') collect: [ :d | d at: 'field' ]
]

{ #category : #views }
TopicMap >> gtJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON';
		priority: 60;
		object: [ self json ];
		view: #gtTreeFor:context:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect  JSON'
			action: [ :aButton :aTab | aButton phlow spawnObject: self json asGtJson ]
]

{ #category : #views }
TopicMap >> gtMissingPagesFor: aView [
	"Pages listed in the JSON but absent from the database.
	These pages may have been removed, but more likely have been renamed.
	Renamed pages will appear in the Unmapped pages view under their new name."

	<gtView>
	^ aView columnedList
		title: 'Missing pages';
		priority: 40;
		items: [ self missingPages ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Missing page title'
			text: [ :each | each gtDisplayString ]
			width: 300;
		column: 'Closest match'
			text: [ :each | self closestUnmappedPageFor: each ]
			width: 300;
		column: 'Accept'
			do: [ :column | 
				column
					stencil: [ :each | 
						BrButton new
							aptitude: BrGlamorousButtonWithIconAptitude;
							icon: BrGlamorousVectorIcons accept;
							label: 'Accept renaming';
							action: [ :aButton | 
								self updateMissingTitle: each.
								aButton phlow fireViewUpdateWish ] ];
					width: 60 ];
		column: 'Delete'
			do: [ :column | 
				column
					stencil: [ :each | 
						BrButton new
							aptitude: BrGlamorousButtonWithIconAptitude;
							icon: BrGlamorousVectorIcons close;
							label: 'Delete the missing page';
							action: [ :aButton | 
								self deleteMissingPageWithTitle: each.
								aButton phlow fireViewUpdateWish ] ];
					width: 60 ];
		send: [ :each | self closestUnmappedPageFor: each ];
		actionButtonIcon: BrGlamorousVectorIcons changes
			tooltip: 'Inspect  pages'
			action: [ :aButton :aTab | aButton phlow spawnObject: self missingPages ];
		actionUpdateButton
]

{ #category : #actions }
TopicMap >> gtPageGroupActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Inspect pages';
		priority: 20;
		icon: BrGlamorousVectorIcons changes;
		action: [ :aButton | aButton phlow spawnObject: self pageGroup ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: self pageGroup ]
			mouseCursor: BlCopyCursor new
]

{ #category : #views }
TopicMap >> gtRoadmap: aView [
	<gtView>
	^ aView forward
		title: 'Roadmap';
		priority: 10;
		object: [ self databaseNode ];
		view: #gtRoadmap:
]

{ #category : #actions }
TopicMap >> gtTopicMapMenuFor: anAction [
	<gtAction>
	^ anAction dropdown
		icon: BrGlamorousVectorIcons hamburger;
		priority: 40;
		tooltip: 'Topic Map Menu';
		content: [ :aButton | 
			BrGlamorousSimpleContextMenuContent new
				items: {'Inspect database node' -> [ aButton phlow spawnObject: self databaseNode ].
						'Enable topic map actions'
							-> [ TMRegistry uniqueInstance enableExtensions ].
						'Disable topic map actions'
							-> [ TMRegistry uniqueInstance disableExtensions ].
						'Inspect JSON file' -> [ aButton phlow spawnObject: self jsonFile ]};
				yourself ]
]

{ #category : #views }
TopicMap >> gtTopicTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Topic Tree';
		priority: 25;
		object: [ self databaseNode ];
		view: #gtTopicTreeFor:
]

{ #category : #views }
TopicMap >> gtTreeMapFor: aView [
	<gtView>
	^ aView forward
		title: 'Tree Map';
		priority: 15;
		object: [ self databaseNode ];
		view: #gtTreeMapFor:
]

{ #category : #views }
TopicMap >> gtUnmappedPagesFor: aView [
	"Pages not listed in the JSON. They may be new or renamed pages.
	Renamed pages can be fixed in the Missing Pages view.
	New pages can be added using the LLM PageClassifier.
	"

	<gtView>
	^ aView forward
		title: 'New pages';
		priority: 45;
		object: [ self unmappedPages ];
		view: #gtTopicTreeFor:;
		actionButtonIcon: BrGlamorousVectorIcons repair
			tooltip: (self class llmPackage isLoaded
					ifTrue: [ 'Repair' ]
					ifFalse: [ 'Load LLM package and repair' ]), ' unmapped pages'
			action: [ :aButton :aTab | 
				[ self class ensureLlmLoaded wait.
				aButton phlow spawnObject: (#TMClassifier asClass for: self) ] fork ]
]

{ #category : #actions }
TopicMap >> gtWriteJsonActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Write JSON';
		priority: 50;
		icon: BrGlamorousVectorIcons savetodisk;
		action: [  "aButton phlow fireToolUpdateWish.":aButton | aButton phlow spawnObject: self writeJsonFile ]
]

{ #category : #help }
TopicMap >> helpPageName [
	^ 'Topic Map'
]

{ #category : #icons }
TopicMap >> hotSaveToDisk [
	^ [ BrGlamorousVectorIcons savetodisk valuable value background: Color lightRed ]
		asStencil
]

{ #category : #initialization }
TopicMap >> initialize [
	super initialize.
	monitor := Monitor new
]

{ #category : #accessing }
TopicMap >> json [
	^ json ifNil: [ json := STON fromString: self jsonFile contents ]
]

{ #category : #querying }
TopicMap >> jsonDict4FieldName: aField ifNone: aBlock [
	^ (self json at: 'fields')
		detect: [ :d | (d at: 'field') = aField ]
		ifNone: aBlock
]

{ #category : #querying }
TopicMap >> jsonDict4PageTitle: aTitle ifNone: aBlock [
	^ (self json at: 'pages') detect: [ :d | (d at: 'page') = aTitle ] ifNone: aBlock
]

{ #category : #accessing }
TopicMap >> jsonFile [
	^ jsonFile
]

{ #category : #accessing }
TopicMap >> jsonFile: aFileReference [
	jsonFile := aFileReference
]

{ #category : #mapping }
TopicMap >> kind2Pages [
	^ kind2Pages
		ifNil: [ kind2Pages := Dictionary new.
			self page2Kind
				associationsDo: [ :assoc | (kind2Pages at: assoc value ifAbsentPut: OrderedCollection new) add: assoc key ].
			kind2Pages keys
				do: [ :key | (kind2Pages at: key) sort: [ :a :b | a title < b title ] ].
			kind2Pages ]
]

{ #category : #querying }
TopicMap >> kind4Page: aPage [
	^ self page2Kind at: aPage ifAbsent: self defaultValue
]

{ #category : #accessing }
TopicMap >> kindNodeNamed: aKind inFieldNamed: aField [
	^ (self fieldNodeNamed: aField) kindNodeNamed: aKind
]

{ #category : #accessing }
TopicMap >> kinds [
	^ self kindsStandardOrder
]

{ #category : #querying }
TopicMap >> kinds4Topic: aTopic [
	"NB: we list the kinds of pages for a topic in the same canonical order defined in TopicMap>>#kind"

	^ self kinds
		select: [ :aKind | 
			((self topic2Pages at: aTopic ifAbsent: {}) collect: [ :aPage | self kind4Page: aPage ])
				includes: aKind ]
]

{ #category : #accessing }
TopicMap >> kindsStandardOrder [
	"Can be used by nodes to sort kinds and pages into a standard order.
	Access: self topicMap kindsStandardOrder"

	^ self json at: 'kinds'
]

{ #category : #querying }
TopicMap >> missingPages [
	"Pages listed in the JSON but not (or no longer) in the database.
	NB: We cannot return a PageGroup because these pages do not exist!"

	^ ((self json at: 'pages')
		collect: [ :d | d at: 'page' ]
		thenReject: [ :p | self database hasPageNamed: p ]) sorted
]

{ #category : #mapping }
TopicMap >> page2Kind [
	^ page2Kind
		ifNil: [ page2Kind := ((self json at: 'pages')
					select: [ :d | self database hasPageNamed: (d at: 'page') ]
					thenCollect: [ :d | (self database pageNamed: (d at: 'page')) -> (d at: 'kind') ])
					asDictionary ]
]

{ #category : #mapping }
TopicMap >> page2Topics [
	^ page2Topics
		ifNil: [ page2Topics := ((self json at: 'pages')
					select: [ :d | self database hasPageNamed: (d at: 'page') ]
					thenCollect: [ :d | (self database pageNamed: (d at: 'page')) -> (d at: 'topics') ])
					asDictionary ]
]

{ #category : #querying }
TopicMap >> pages [
	^ self page2Topics keys sortedAs: #title
]

{ #category : #querying }
TopicMap >> pages4Kind: aKind [
	^ self kind2Pages at: aKind ifAbsent: {self defaultValue}
]

{ #category : #querying }
TopicMap >> pages4Topic: aTopic [
	^ self topic2Pages at: aTopic ifAbsent: {self defaultValue}
]

{ #category : #accessing }
TopicMap >> roadmap [
	^ self databaseNode roadmap
]

{ #category : #views }
TopicMap >> summary [
	"These should always be empty -- only unmapped pages should be missing kinds or topics."

	^ super summary
		, {{'#Pages without kinds'.
					self emptyKindPages size.
					self emptyKindPages}.
				{'#Pages without topics'.
					self emptyTopicPages size.
					self emptyTopicPages}}
]

{ #category : #mapping }
TopicMap >> topic2Field [
	^ topic2Field
		ifNil: [ topic2Field := Dictionary new.
			self field2Topics
				associationsDo: [ :assoc | assoc value do: [ :aTopic | topic2Field at: aTopic put: assoc key ] ].
			topic2Field ]
]

{ #category : #mapping }
TopicMap >> topic2Pages [
	^ topic2Pages
		ifNil: [ topic2Pages := Dictionary new.
			self page2Topics
				associationsDo: [ :assoc | 
					assoc value
						do: [ :topic | (topic2Pages at: topic ifAbsentPut: OrderedCollection new) add: assoc key ] ].
			topic2Pages ]
]

{ #category : #querying }
TopicMap >> topic4Field: aField [
	^ self field2Topics at: aField ifAbsent: self defaultValue
]

{ #category : #querying }
TopicMap >> topicMap [
	^ self
]

{ #category : #accessing }
TopicMap >> topics [
	^ self topic2Pages keys
]

{ #category : #querying }
TopicMap >> topics4Page: aPage [
	^ self page2Topics at: aPage ifAbsent: {}
]

{ #category : #querying }
TopicMap >> unmappedPages [
	"Pages in the database but not listed in the json. Could either be new or renamed pages.
	NB: the latter will also show up as missing pages."

	^ self
		draftPageGroupFor: ((self database pages copyWithoutAll: self pages) sortedAs: #title)
]

{ #category : #updating }
TopicMap >> updateFieldForTopic: aTopicNode to: aField [
	"Remove the topic from the old field and add it to the new one."

	| topic oldField oldDict newDict |
	topic := aTopicNode topic.
	oldField := aTopicNode field.
	oldDict := self
			jsonDict4FieldName: oldField
			ifNone: [ self error: 'Could not find JSON entry for field ' , oldField ].
	newDict := self
			jsonDict4FieldName: aField
			ifNone: [ self error: 'Could not find JSON entry for field ' , aField ].

	self assert: ((oldDict at: 'topics') includes: topic).
	self assert: ((newDict at: 'topics') includes: topic) not.

	oldDict at: 'topics' put: ((oldDict at: 'topics') copyWithout: topic).
	newDict at: 'topics' put: ((newDict at: 'topics') copyWith: topic) sorted.

	self clearCaches.
	self writeJsonFile
]

{ #category : #updating }
TopicMap >> updateKindForPage: aPageNode to: aKind [
	| dict |
	self
		assert: (self kindsStandardOrder includes: aKind)
		description: 'Unknown kind: ' , aKind.
	dict := self
			jsonDict4PageTitle: aPageNode title
			ifNone: [ self error: 'Could not find JSON entry for page ' , aPageNode title ].
	self assert: (dict at: 'kind') ~= aKind description: 'Kind is unchanged.'.
	dict at: 'kind' put: aKind.
	self clearCaches.
	self writeJsonFile
]

{ #category : #updating }
TopicMap >> updateMissingTitle: aMissingTitle [
	| aPage |
	self
		assert: (self missingPages includes: aMissingTitle)
		description: aMissingTitle , ' has already been deleted or renamed.'.
	aPage := self closestUnmappedPageFor: aMissingTitle.
	(self
		jsonDict4PageTitle: aMissingTitle
		ifNone: [ self error: 'Could not find entry for ' , aMissingTitle ])
		at: 'page'
		put: aPage title.
	self assert: (self jsonDict4PageTitle: aMissingTitle ifNone: [ nil ]) isNil.
	self clearCaches.
	self writeJsonFile
]

{ #category : #updating }
TopicMap >> updateTopicsForPage: aPageNode to: aTopicArray [
	| dict |
	aTopicArray
		do: [ :aTopic | 
			self
				assert: (self topics includes: aTopic)
				description: 'Unknown topic: ' , aTopic ].
	dict := self
			jsonDict4PageTitle: aPageNode title
			ifNone: [ self error: 'Could not find JSON entry for page ' , aPageNode title ].
	self
		assert: (dict at: 'topics') ~= aTopicArray
		description: 'Topics are unchanged.'.
	dict at: 'topics' put: aTopicArray.
	self clearCaches.
	self writeJsonFile
]

{ #category : #updating }
TopicMap >> writeJsonFile [
	| tempFile |
	tempFile := self jsonFile copyWithPath: self jsonFile path , 'temp.json'.
	tempFile ensureDelete.
	tempFile
		writeStreamDo: [ :aStream | STON put: self json asJsonOnStreamPretty: aStream ].
	[ tempFile readStreamDo: [ :aStream | STON fromStream: aStream ] ]
		onErrorDo: [ tempFile ensureDelete.
			self error: 'Writing JSON failed -- leaving old JSON as is.' ].
	monitor
		critical: [ self jsonFile ensureDelete.
			tempFile renameTo: self jsonFile basename ].
	^ self jsonFile
]
