Class {
	#name : #BaselineOfGtoolkitRoadmaps,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtoolkitRoadmaps
}

{ #category : #baseline }
BaselineOfGtoolkitRoadmaps class >> gtDependencyAnalysisPreloadedBaselines [
	^ super gtDependencyAnalysisPreloadedBaselines
		copyWith: BaselineOfGToolkit
]

{ #category : #loading }
BaselineOfGtoolkitRoadmaps class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gtoolkit-roadmaps' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #loading }
BaselineOfGtoolkitRoadmaps class >> loadRoadmapsHelpLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gtoolkit-roadmaps' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'roadmaps-help'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGtoolkitRoadmaps >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'GToolkit-Roadmaps'
		]
]
