Class {
	#name : #ProcessSpawner,
	#superclass : #Object,
	#instVars : [
		'globalProcessRegister',
		'synchronizationSemaphore',
		'error',
		'finishedSemaphore'
	],
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #'instance creation' }
ProcessSpawner class >> spawnWithRegister: aRegister [

	| instance |
	instance := self new.
	instance globalProcessRegister: aRegister.
	[ instance procReg ] fork. 

	^instance
]

{ #category : #accessing }
ProcessSpawner >> globalProcessRegister [

	^ globalProcessRegister
]

{ #category : #accessing }
ProcessSpawner >> globalProcessRegister: anObject [

	globalProcessRegister := anObject
]

{ #category : #initialization }
ProcessSpawner >> initialize [ 

	super initialize.
	synchronizationSemaphore := Semaphore new.
	finishedSemaphore  := Semaphore new.
	error := false.
]

{ #category : #accessing }
ProcessSpawner >> isError [

	^ error
]

{ #category : #'as yet unclassified' }
ProcessSpawner >> procReg [

	| pid1 |
	[ 
	synchronizationSemaphore wait.

	globalProcessRegister whereis: 'gazonk'.

	synchronizationSemaphore wait.

	pid1 := EProcess spawn.

	synchronizationSemaphore wait.

	globalProcessRegister registerName: 'gazonk' for: pid1 ] onErrorDo: [ 
		error := true ].
	
	finishedSemaphore signal.
]

{ #category : #signalling }
ProcessSpawner >> signal [
	
	synchronizationSemaphore signal.
]

{ #category : #accessing }
ProcessSpawner >> synchronizationSemaphore [

	^ synchronizationSemaphore
]

{ #category : #accessing }
ProcessSpawner >> synchronizationSemaphore: anObject [

	synchronizationSemaphore := anObject
]

{ #category : #synchronization }
ProcessSpawner >> wait [
	synchronizationSemaphore wait.
]

{ #category : #finalization }
ProcessSpawner >> waitFinished [
	finishedSemaphore wait
]
