Class {
	#name : #ProcessSpawner,
	#superclass : #Object,
	#instVars : [
		'globalProcessRegister',
		'error',
		'finishedSemaphore',
		'startedBlock',
		'finishedBlock'
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
	startedBlock := Semaphore new.
	finishedBlock := Semaphore new.
	finishedSemaphore := Semaphore new.
	error := false.
]

{ #category : #accessing }
ProcessSpawner >> isError [

	^ error
]

{ #category : #'as yet unclassified' }
ProcessSpawner >> procReg [

	| pid1 registered |
	self waitStarting.

	registered := globalProcessRegister whereis: 'gazonk'.
	self wait.

	registered
		ifNil: [ 
			pid1 := EProcess spawn.
			self wait.

			[ globalProcessRegister registerName: 'gazonk' for: pid1 ] 
				onErrorDo: [ error := true ] ]
		ifNotNil: [ 
			self wait.
			true ].
	 self signalFinished.	
	
]

{ #category : #signalling }
ProcessSpawner >> signal [
	
	startedBlock signal.
	finishedBlock wait.
	
]

{ #category : #signalling }
ProcessSpawner >> signalFinished [

	finishedBlock signal.
	finishedSemaphore signal
]

{ #category : #accessing }
ProcessSpawner >> startedBlock [

	^ startedBlock
]

{ #category : #accessing }
ProcessSpawner >> synchronizationSemaphore: anObject [

	startedBlock := anObject
]

{ #category : #synchronization }
ProcessSpawner >> wait [

	finishedBlock signal.
	startedBlock wait.
]

{ #category : #finalization }
ProcessSpawner >> waitFinished [
	finishedSemaphore wait
]

{ #category : #'as yet unclassified' }
ProcessSpawner >> waitStarting [
	
	startedBlock wait.
]
