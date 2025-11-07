Extension { #name : #LePage }

{ #category : #'*GToolkit-Roadmaps' }
LePage >> asPageNode [
	^ TMPageNode for: self
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtDisableTopicMapLePageExtensionsActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Disable LePage topic map actions';
		priority: 16;
		target: LePageInspectorActionTarget;
		icon: BrGlamorousVectorIcons roadmap;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton :aModel :anEvent | TMRegistry uniqueInstance disableExtensions ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtEnableTopicMapLePageExtensionsActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Enable LePage topic map actions';
		priority: 15;
		target: LePageInspectorActionTarget;
		icon: BrGlamorousVectorIcons roadmap;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton :aModel :anEvent | TMRegistry uniqueInstance enableExtensions ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtInspectGtBookTopicMapActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Inspect GT Book Topic Map';
		priority: 10;
		target: LePageInspectorActionTarget;
		icon: BrGlamorousVectorIcons roadmap;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton :aModel :anEvent | aButton phlow spawnObject: TopicMap forGtBook ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtInspectPageTopicMapActionFor: anAction [
	<gtAction>
	self hasTopicMap ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Inspect Topic Map for this page';
		priority: 11;
		target: LePageInspectorActionTarget;
		icon: BrGlamorousVectorIcons roadmap;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton :aModel :anEvent | aButton phlow spawnObject: self asPageNode ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtTopicMapActionFor: anAction [
	"To do: 
		- add an id."

	<gtAction>
	TMRegistry uniqueInstance extensionsEnabled ifFalse: [ ^ anAction empty ].
	self hasTopicMap ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Inspect topic map';
		icon: BrGlamorousVectorIcons roadmap;
		target: LePageActionTarget;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | aButton phlow spawnObject: self asPageNode ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: self asPageNode ]
			mouseCursor: BlCopyCursor new
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtTopicMapFor: anAction [
	"<gtAction>"
	^ anAction button
		icon: BrGlamorousVectorIcons roadmap;
		priority: 30;
		tooltip: 'Inspect page topic map';
		action: [ :aButton | aButton phlow spawnObject: (TMPageNode for: self) ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: (TMPageNode for: self) ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtTopicMapMenuFor: anAction [
	"Moved these to gtPageInspectorActionsDropdownMenuFor:"
	"<gtAction>"

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
