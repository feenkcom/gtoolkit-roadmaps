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
		'field2Topics'
	],
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #icons }
TopicMap class >> directionsIcon [
	"Based on https://www.svgrepo.com/svg/509081/directions.
	Just a placeholder icon -- to be replaced by one we create ourselves 
	with Inkscape or OmniGraffle"

	<script: 'self add directions'>
	^ [ BlElement new
		size: BrGlamorousVectorIcons standardSize;
		geometry: (BlSvgPath new
				svg: 'M 15.890625 2.90625 L 14.332031 1.167969 C 14.238281 1.058594 14.101562 1 13.960938 1 L 8.488281 1 L 8.488281 0.46875 C 8.488281 0.210938 8.261719 0 7.988281 0 C 7.710938 0 7.488281 0.210938 7.488281 0.46875 L 7.488281 1 L 3.488281 1 C 3.214844 1 2.988281 1.222656 2.988281 1.5 L 2.988281 4.992188 C 2.988281 5.269531 3.214844 5.492188 3.488281 5.492188 L 7.488281 5.492188 L 7.488281 6.496094 L 2.039062 6.496094 C 1.898438 6.496094 1.761719 6.554688 1.667969 6.664062 L 0.109375 8.433594 C -0.0585938 8.625 -0.0585938 8.910156 0.109375 9.097656 L 1.667969 10.851562 C 1.761719 10.960938 1.898438 11.003906 2.039062 11.003906 L 7.488281 11.003906 L 7.488281 15.53125 C 7.488281 15.789062 7.710938 16 7.988281 16 C 8.261719 16 8.488281 15.789062 8.488281 15.53125 L 8.488281 11.003906 L 12.496094 11.003906 C 12.769531 11.003906 12.996094 10.78125 12.996094 10.503906 L 12.996094 6.996094 C 12.996094 6.71875 12.769531 6.496094 12.496094 6.496094 L 8.488281 6.496094 L 8.488281 5.492188 L 13.960938 5.492188 C 14.101562 5.492188 14.238281 5.433594 14.335938 5.324219 L 15.890625 3.570312 C 16.058594 3.382812 16.058594 3.097656 15.890625 2.90625 Z M 11.996094 10.003906 L 2.265625 10.003906 L 1.152344 8.765625 L 2.265625 7.496094 L 11.996094 7.496094 Z M 13.734375 4.496094 L 3.988281 4.496094 L 3.988281 2 L 13.734375 2 L 14.847656 3.238281 Z M 13.734375 4.496094'
				viewbox: (0 @ 0 extent: BrGlamorousVectorIcons standardSize));
		background: Color black ] asStencil
]

{ #category : #'instance creation' }
TopicMap class >> forJson: aFileReference [
	^ self new
		jsonFile: aFileReference;
		yourself
]

{ #category : #icons }
TopicMap class >> topicMapIcon [
	"^ BrGlamorousVectorIcons bookmark"

	^ TopicMap directionsIcon
]

{ #category : #utility }
TopicMap >> clearCaches [
	"If we update the json and write it out, we need to clear the caches so they will be updated too."

	database := nil.
	field2Topics := nil.
	page2Topics := nil.
	page2Kind := nil.
	topic2Pages := nil.
	topic2Field := nil.
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

{ #category : #querying }
TopicMap >> defaultValue [
	"Default value for lookups that fail (missing kind, topic etc)."

	^ '<unknown>'
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
		view: #gtTreeFor:context:
]

{ #category : #views }
TopicMap >> gtMissingPagesFor: aView [
	"Pages listed in the JSON but absent from the database.
	These pages may have been removed, but more likely have been renamed.
	Renamed pages will appear in the Unmapped pages view under their new name."

	<gtView>
	^ aView columnedList
		title: 'Missing pages';
		priority: 45;
		items: [ self missingPages ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Missing page title'
			text: [ :each | each gtDisplayString ]
			width: 300;
		column: 'Closest match'
			text: [ :each | self unmappedPageFor: each ]
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
					stencil: [ :aCard | 
						BrButton new
							aptitude: BrGlamorousButtonWithIconAptitude;
							icon: BrGlamorousVectorIcons close;
							label: 'Delete the missing page';
							action: [ :aButton | self shouldBeImplemented ] ];
					width: 60 ];
		send: [ :each | self unmappedPageFor: each ];
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
TopicMap >> gtRoadmapFor: aView [
	<gtView>
	^ aView forward
		title: 'OLD Roadmap';
		priority: 37;
		object: [ self databaseNode ];
		view: #gtRoadmapFor:
]

{ #category : #views }
TopicMap >> gtRoadmapWithKindFor: aView [
	<gtView>
	^ aView forward
		title: 'Roadmap';
		priority: 36;
		object: [ self databaseNode ];
		view: #gtRoadmapWithKindFor:
]

{ #category : #views }
TopicMap >> gtSummaryFor: aView [
	<gtView>
	^ aView forward
		title: 'Summary';
		priority: 20;
		object: [ self databaseNode ];
		view: #gtSummaryFor:
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
						'Enable topic map actions' -> [ TMRegistry uniqueInstance enableExtensions ].
						'Disable topic map actions' -> [ TMRegistry uniqueInstance disableExtensions ]};
				yourself ]
]

{ #category : #views }
TopicMap >> gtTopicMapTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Topic Map';
		priority: 10;
		object: [ self databaseNode ];
		view: #gtTreeFor:
]

{ #category : #views }
TopicMap >> gtTreeMapFor: aView [
	<gtView>
	^ aView forward
		title: 'Tree Map';
		priority: 30;
		object: [ self databaseNode ];
		view: #gtTreeMapFor:
]

{ #category : #views }
TopicMap >> gtUnmappedPagesFor: aView [
	"Pages not listed in the JSON. These will need an assistant to update the JSON."

	<gtView>
"	^ aView columnedList
		title: 'Unmapped pages';
		priority: 40;
		items: [ self unmappedPages ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Value' text: [ :each | each gtDisplayString ];
		actionUpdateButton"

	^ aView forward
		title: 'Unmapped pages';
		priority: 40;
		object: [ self unmappedPages ];
		view: #gtTreeFor:;
		actionUpdateButton
]

{ #category : #accessing }
TopicMap >> json [
	^ json ifNil: [ json := STONJSON fromString: self jsonFile contents ]
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
	| dict |
	dict := Dictionary new.
	self page2Kind
		associationsDo: [ :assoc | (dict at: assoc value ifAbsentPut: OrderedCollection new) add: assoc key ].
	^ dict
]

{ #category : #querying }
TopicMap >> kind4Page: aPage [
	^ self page2Kind at: aPage ifAbsent: self defaultValue
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
			((self topic2Pages at: aTopic) collect: [ :aPage | self kind4Page: aPage ])
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
	"Pages listed in the JSON but not (or no longer) in the database."

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
	^ self page2Topics at: aPage ifAbsent: {self defaultValue}
]

{ #category : #querying }
TopicMap >> unmappedPageFor: aMissingTitle [
	"Find the unmapped page whose title has the smallest edit distance to a title of a missing page."

	| pages |
	pages := self unmappedPages pages.
	self assert: pages isNotEmpty description: 'There are no unmapped pages to search.'.

	^ ((pages
		collect: [ :aPage | 
			{GtLevenshtein distanceBetween: aPage title and: aMissingTitle.
				aPage} ]) sortedAs: #first) first second
]

{ #category : #querying }
TopicMap >> unmappedPages [
	"Pages in the database but not listed in the json. Could either be new or renamed pages.
	NB: the latter will also show up as missing pages."

	^ self
		pageGroupFor: ((self database pages copyWithoutAll: self pages) sortedAs: #title)
]

{ #category : #updating }
TopicMap >> updateMissingTitle: aMissingTitle [
	| jsonPages aPage dict |
	self
		assert: (self missingPages includes: aMissingTitle)
		description: aMissingTitle , ' has already been deleted or renamed.'.
	aPage := self unmappedPageFor: aMissingTitle.
	jsonPages := self json at: 'pages'.
	dict := jsonPages detect: [ :d | (d at: 'page') = aMissingTitle ].
	dict at: 'page' put: aPage title.
	self
		assert: ((self json at: 'pages') select: [ :d | (d at: 'page') = aMissingTitle ])
				isEmpty.
	self clearCaches.
	self writeJsonFile
]

{ #category : #updating }
TopicMap >> writeJsonFile [
	self error: 'This implementation is broken.'.
	^ STON put: self json asJsonOnStreamPretty: self jsonFile writeStream
]
