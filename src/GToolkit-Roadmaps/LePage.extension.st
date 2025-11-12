Extension { #name : #LePage }

{ #category : #'*GToolkit-Roadmaps' }
LePage >> asPageNode [
	^ TMPageNode for: self
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtDisableTopicMapLePageExtensionsActionFor: anAction [
	"Appears as a LePage inspector gtAction menu item."
	"<gtAction>"
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
	"Appears as a LePage inspector gtAction menu item."
	"<gtAction>"
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
	"Appears as a LePage inspector gtAction menu item."
	<gtAction>
	^ anAction button
		tooltip: 'Inspect GT Book Topic Map';
		priority: 10;
		id: LePageTopicMapActionId;
		target: LePageInspectorActionTarget;
		icon: BrGlamorousVectorIcons roadmap;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton :aModel :anEvent | aButton phlow spawnObject: TopicMap forGtBook ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtInspectPageTopicMapActionFor: anAction [
	"Appears as a LePage inspector gtAction menu item."
	<gtAction>
	self hasTopicMap ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Inspect Topic Map for this page';
		priority: 11;
		id: LePageTopicMapActionId;
		target: LePageInspectorActionTarget;
		icon: BrGlamorousVectorIcons roadmap;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton :aModel :anEvent | aButton phlow spawnObject: self asPageNode ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtLePageGitMenuActionFor: anAction [
	<gtAction>
	(self database monitor isLocalStore not or: [ self icebergRepo isNil ])
		ifTrue: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Go to repository';
		priority: 72;
		target: LePageActionTarget;
		menuItemGroup: BrMenuItemGroupConfiguration editing;
		icon: BrGlamorousVectorIcons branching;
		action: [ :aButton | 
			aButton phlow
				spawnTool: (GtGitPhlowTool new
						repository: (GtGitRepository fromIcebergRepository: self icebergRepo)) ]
]

{ #category : #'*GToolkit-Roadmaps' }
LePage >> gtTopicMapActionFor: anAction [
	"Appears as a lePageAction menu item."

	<gtAction>
	self hasTopicMap ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Inspect topic map for this page';
		icon: BrGlamorousVectorIcons roadmap;
		id: LePageTopicMapActionId;
		target: LePageActionTarget;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | aButton phlow spawnObject: self asPageNode ];
		primaryModifierAction: [ :aButton | aButton phlow showObject: self asPageNode ]
			mouseCursor: BlCopyCursor new
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
