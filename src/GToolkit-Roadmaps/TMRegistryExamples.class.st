Class {
	#name : #TMRegistryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Roadmaps-Examples'
}

{ #category : #examples }
TMRegistryExamples >> fileWithStoreOnView [
	"Used in: GT Inspector  views for files"

	<gtExample>
	| scripter file |
	file := self gtBookJsonFile.
	scripter := BlScripter new.
	scripter element: (GtInspector createOn: file) maximized.
	scripter inspectorStep
		label: 'Select the Store on view';
		clickOnTabWithName: 'Store on';
		play.
	(scripter inspectorStep
		label: 'Open the source view';
		clickOnTabWithName: 'Store on')
		modifiers: BlKeyModifiers alt;
		play.
	^ scripter elementWithoutParent
]

{ #category : #examples }
TMRegistryExamples >> gtBookJsonFile [
	<gtExample>
	<return: #FileLocator>
	| fileReference |
	fileReference := self tmRegistrySingleton jsonFileFor: LeDatabase gtBookName.
	self assert: fileReference exists.
	^ fileReference
]

{ #category : #examples }
TMRegistryExamples >> gtBookJsonFilePath [
	<gtExample>
	<return: #ByteString>
	| filePath |
	filePath := self tmRegistrySingleton jsonFilePathFor: LeDatabase gtBookName.
	self assert: (filePath endsWith: '.json').
	^ filePath
]

{ #category : #examples }
TMRegistryExamples >> gtBookTopicMap [
	"TopicMap for all pages from the test file."

	<gtExample>
	<return: #TopicMap>
	| gtBookTopicMap |
	gtBookTopicMap := self tmRegistrySingleton topicMapFor: LeDatabase gtBookName.
	^ gtBookTopicMap
]

{ #category : #examples }
TMRegistryExamples >> tmRegistrySingleton [
	<gtExample>
	<return: #TMRegistry>
	| tmRegistry |
	tmRegistry := TMRegistry uniqueInstance.
	self assert: tmRegistry registry size equals: 1.
	self assert: (tmRegistry hasTopicMapFor: LeDatabase gtBookName).
	^ tmRegistry
]
