Class {
	#name : #BaselineOfGtoolkitRoadmapsLLM,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtoolkitRoadmapsLLM
}

{ #category : #baselines }
BaselineOfGtoolkitRoadmapsLLM class >> gtDependencyAnalysisPreloadedBaselines [
	^ super gtDependencyAnalysisPreloadedBaselines
		copyWith: BaselineOfGToolkit
]

{ #category : #loading }
BaselineOfGtoolkitRoadmapsLLM class >> loadLepiterGtbookExamples [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gtoolkit-roadmaps' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'gtbook-examples'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baselines }
BaselineOfGtoolkitRoadmapsLLM >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'GToolkit-Roadmaps-LLM'
		]
]
