Extension { #name : #LeDatabase }

{ #category : #'*GToolkit-RoadmapsTEMP' }
LeDatabase >> gtTopicMapMenuFor: anAction [
	<gtAction>
	^ anAction dropdown
		icon: TopicMap topicMapIcon;
		priority: 20;
		tooltip: 'Topic Map Menu';
		content: [ :aButton | 
			BrGlamorousSimpleContextMenuContent new
				items: {'Inspect topic map' -> [ aButton phlow spawnObject: self topicMap ].
						'Enable topic map actions'
							-> [ TMRegistry uniqueInstance enableExtensions ].
						'Disable topic map actions'
							-> [ TMRegistry uniqueInstance disableExtensions ]};
				yourself ]
]

{ #category : #'*GToolkit-RoadmapsTEMP' }
LeDatabase >> hasTopicMap [
	^ TMRegistry uniqueInstance hasTopicMapFor: self databaseName
]

{ #category : #'*GToolkit-RoadmapsTEMP' }
LeDatabase >> topicMap [
	self
		assert: self hasTopicMap
		description: 'No topic map exists for the database ' , self databaseName.
	^ TMRegistry uniqueInstance topicMapFor: self databaseName
]
