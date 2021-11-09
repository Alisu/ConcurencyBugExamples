Class {
	#name : #ProcessSpawnerTightTransaction,
	#superclass : #ProcessSpawner,
	#instVars : [
		'channelWhereIsIn',
		'channelWhereIsOut',
		'channelRegisterIn',
		'channelRegisterOut'
	],
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #'instance creation' }
ProcessSpawnerTightTransaction class >> spawn [

	| instance |
	instance := self new.
	[ instance procReg ] fork. 

	^instance
]

{ #category : #'as yet unclassified' }
ProcessSpawnerTightTransaction >> channelWhereIsReceive [

	channelWhereIsOut receive.
]

{ #category : #sending }
ProcessSpawnerTightTransaction >> channelWhereIsSend: aCollection [ 
	channelWhereIsIn send: aCollection.
]

{ #category : #initialization }
ProcessSpawnerTightTransaction >> initialize [ 

	super initialize.
	channelWhereIsIn := ReadPermissionTransferChannel new.
	channelWhereIsOut := ReadPermissionTransferChannel new.
	channelRegisterIn := WritePermissionTransferChannel new.
	channelRegisterOut := WritePermissionTransferChannel new.
]

{ #category : #'as yet unclassified' }
ProcessSpawnerTightTransaction >> procReg [

	| pid1 |
	[ 

	self wait.
	globalProcessRegister := channelWhereIsIn receive.
	globalProcessRegister whereis: 'gazonk'.
	channelWhereIsOut send: globalProcessRegister.
	self wait.

	pid1 := EProcess spawn.
	self wait.
	globalProcessRegister := channelRegisterIn receive.
	globalProcessRegister registerName: 'gazonk' for: pid1 ] onErrorDo: [ 
		error := true ].
	channelRegisterOut send: globalProcessRegister.
	self signalFinished
]

{ #category : #'as yet unclassified' }
ProcessSpawnerTightTransaction >> receiveRegister [

	channelRegisterOut receive.
]

{ #category : #setting }
ProcessSpawnerTightTransaction >> registerChannelReceive: aFullPermissionTransferChannel [ 
	channelRegisterOut := aFullPermissionTransferChannel
]

{ #category : #setting }
ProcessSpawnerTightTransaction >> registerChannelSend: aFullPermissionTransferChannel [ 
	channelRegisterIn := aFullPermissionTransferChannel 
]

{ #category : #'as yet unclassified' }
ProcessSpawnerTightTransaction >> sendRegister: anObject [

	channelRegisterIn send: anObject
]
