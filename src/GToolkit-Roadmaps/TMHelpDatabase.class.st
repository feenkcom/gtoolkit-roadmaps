"
I am a singleton class that provides a Help database for topic maps and nodes.

You can access my in-memory database as follows:
```
TMHelpDatabase database
```

To load and access the persistent database (NB: slow):
```
TMHelpDatabase
	cleanUp;
	loadRoadmapsHelpLepiter;
	database
```

To unload the persistent database and load again the in-memory version:
```
TMHelpDatabase
	cleanUp;
	unloadRoadmapsHelpLepiter;
	database
```

"
Class {
	#name : #TMHelpDatabase,
	#superclass : #LeAbstractInMemoryDatabaseSingleton,
	#category : #'GToolkit-Roadmaps-Model'
}

{ #category : #loading }
TMHelpDatabase class >> databaseName [
	^ 'feenkcom/gtoolkit-roadmaps/roadmaps-help'
]

{ #category : #loading }
TMHelpDatabase class >> loadRoadmapsHelpLepiter [
	"If we need to edit the database, it must be loaded first."

	BaselineOfGtoolkitRoadmaps loadRoadmapsHelpLepiter
]

{ #category : #loading }
TMHelpDatabase class >> unloadRoadmapsHelpLepiter [
	"Mainly available for testing and debugging."

	| registry db |
	registry := LeDatabasesRegistry uniqueInstance defaultLogicalDatabase.
	db := registry databaseNamed: self databaseName.
	registry removeDB: db
]

{ #category : #initialization }
TMHelpDatabase >> initialize [
	super initialize.
	self databaseName: self class databaseName.
	self initializeDatabase
]
