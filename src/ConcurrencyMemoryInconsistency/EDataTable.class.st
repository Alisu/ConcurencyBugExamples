Class {
	#name : #EDataTable,
	#superclass : #Dictionary,
	#instVars : [
		'name',
		'tid',
		'synchronization',
		'jointPointSemaphore'
	],
	#classVars : [
		'classTid'
	],
	#category : #ConcurrencyMemoryInconsistency
}

{ #category : #'instance creation' }
EDataTable class >> newName: aName [

	"We remove the with option since it needs to be public for dataraces"

	| instance |
	instance := self new.
	instance name: aName.
	instance synchronization:  Semaphore new.
	inc := 0.
	^instance
]

{ #category : #'as yet unclassified' }
EDataTable >> inc: aTable _: anInc [


	| result |
	result := self lookupFor: #some_key inTable: aTable.
	jointPointSemaphore signal.
	synchronization wait.
	result
		ifNil: [ self insert: #some_key -> anInc table: aTable ]
		ifNotNil: [ self insert: #some_key -> (result + anInc) table: aTable ].
	jointPointSemaphore signal.
]

{ #category : #'public - layout' }
EDataTable >> insert: anObject table: aTableName [

	"They say an object but it's a tuple"

	self add: anObject.
]

{ #category : #setting }
EDataTable >> jointPointSemaphore: aCollection [ 
	jointPointSemaphore := aCollection
]

{ #category : #'public - layout' }
EDataTable >> lookupFor: aKey inTable: aTableName [

	^ self at: aKey ifAbsent: [ nil ]
]

{ #category : #setting }
EDataTable >> name: aString [ 
	name := aString
]

{ #category : #signalling }
EDataTable >> signal [
	synchronization signal
]

{ #category : #setting }
EDataTable >> synchronization: aCollection [ 
	synchronization := aCollection
]

{ #category : #accessing }
EDataTable >> tid [

	tid ifNil: [ 
		classTid ifNil: [ classTid := 1 ].
		tid := classTid.
		classTid := classTid + 1 ].
	^tid
]
