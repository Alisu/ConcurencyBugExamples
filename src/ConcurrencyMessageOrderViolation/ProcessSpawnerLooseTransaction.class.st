Class {
	#name : #ProcessSpawnerLooseTransaction,
	#superclass : #ProcessSpawner,
	#instVars : [
		'channelIn',
		'channelOut'
	],
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #'instance creation' }
ProcessSpawnerLooseTransaction class >> spawn [

	| instance |
	instance := self new.
	[ instance procReg ] fork. 

	^instance
]

{ #category : #setting }
ProcessSpawnerLooseTransaction >> channelIn: aFullPermissionTransferChannel [ 
	channelIn := aFullPermissionTransferChannel
]

{ #category : #sending }
ProcessSpawnerLooseTransaction >> channelInSend: aCollection [ 
	channelIn send: aCollection.
]

{ #category : #setting }
ProcessSpawnerLooseTransaction >> channelOut: aFullPermissionTransferChannel [ 
	channelOut := aFullPermissionTransferChannel
]

{ #category : #initialization }
ProcessSpawnerLooseTransaction >> initialize [ 

	super initialize.
	channelIn := WritePermissionTransferChannel new.
	channelOut := WritePermissionTransferChannel new.
]

{ #category : #'as yet unclassified' }
ProcessSpawnerLooseTransaction >> procReg [

	| pid1 |
	[ 

	self wait.
	globalProcessRegister := channelIn receive.
	globalProcessRegister whereis: 'gazonk'.
	self wait.

	pid1 := EProcess spawn.
	self wait.

	globalProcessRegister registerName: 'gazonk' for: pid1 ] onErrorDo: [ 
		error := true ].
	channelOut send: globalProcessRegister.
	self signalFinished
]
