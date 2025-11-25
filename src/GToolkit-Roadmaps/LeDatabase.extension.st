Extension { #name : #LeDatabase }

{ #category : #'*GToolkit-Roadmaps' }
LeDatabase >> gtInspectTopicMapActionFor: anAction [
	<gtAction>
	self hasTopicMap ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Inspect Topic Map';
		priority: 10;
		icon: BrGlamorousVectorIcons roadmap;
		action: [ :aButton :aModel :anEvent | aButton phlow spawnObject: self topicMap ];
		primaryModifierAction: [ :aButton :aModel :anEvent | aButton phlow showObject: self topicMap ]
]

{ #category : #'*GToolkit-Roadmaps' }
LeDatabase >> gtInspectTopicMapNavigationActionFor: anAction [
	"Appears as a LeDatabase navigation gtAction menu item."

	<gtAction>
	self hasTopicMap ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Inspect Topic Map';
		priority: 10;
		target: LeDatabaseActionTarget;
		icon: BrGlamorousVectorIcons roadmap;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton :aModel :anEvent | aButton phlow spawnObject: self topicMap ]
]

{ #category : #'*GToolkit-Roadmaps' }
LeDatabase >> hasTopicMap [
	^ TMRegistry uniqueInstance hasTopicMapFor: self databaseName
]

{ #category : #'*GToolkit-Roadmaps' }
LeDatabase >> topicMap [
	self
		assert: self hasTopicMap
		description: 'No topic map exists for the database ' , self databaseName.
	^ TMRegistry uniqueInstance topicMapFor: self databaseName
]
