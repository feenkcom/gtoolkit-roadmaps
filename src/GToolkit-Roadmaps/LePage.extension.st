Extension { #name : #LePage }

{ #category : #'*GToolkit-Roadmaps' }
LePage >> asPageNode [
	^ TMPageNode for: self
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtTopicMapActionFor: anAction [
	"To do: 
		- fix this to show the topic map for just this page
		- add an id."

	<lePageAction>
	TMRegistry uniqueInstance extensionsEnabled ifFalse: [ ^ anAction empty ].
	self hasTopicMap ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Inspect topic map';
		icon: BrGlamorousVectorIcons roadmap;
		action: [ :aButton | aButton phlow spawnObject: self asPageNode ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: self asPageNode ]
			mouseCursor: BlCopyCursor new
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtTopicMapFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons roadmap;
		priority: 30;
		tooltip: 'Inspect page topic map';
		action: [ :aButton | aButton phlow spawnObject: (TMPageNode for: self) ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: (TMPageNode for: self) ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtTopicMapMenuFor: anAction [
	<gtAction>
	^ anAction dropdown
		icon: BrGlamorousVectorIcons hamburger;
		priority: 32;
		tooltip: 'Topic Map Menu';
		content: [ :aButton | 
			BrGlamorousSimpleContextMenuContent new
				items: {'Inspect database topic map'
							-> [ aButton phlow spawnObject: self database topicMap ].
						'Inspect page topic map'
							-> [ aButton phlow spawnObject: (TMPageNode for: self) ].
						'Enable LePage topic map actions'
							-> [ TMRegistry uniqueInstance enableExtensions ].
						'Disable LePage topic map actions'
							-> [ TMRegistry uniqueInstance disableExtensions ]};
				yourself ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> hasTopicMap [
	^ self database hasTopicMap
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> pageString [
	^ GtLlmLepiterContentExporter new
		page: self;
		export
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> topicMap [
	^ self database topicMap
]
