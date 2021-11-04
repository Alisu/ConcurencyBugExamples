Class {
	#name : #ProcessSpawnerTightTransactionTest,
	#superclass : #ProcessSpawnerTest,
	#instVars : [
		'register',
		'processSpawner1',
		'processSpawner2'
	],
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #running }
ProcessSpawnerTightTransactionTest >> setUp [
	super setUp.
	register := EProcessRegister newOwned.
	processSpawner1 := ProcessSpawnerTightTransaction spawn.
	processSpawner2 := ProcessSpawnerTightTransaction spawn.

]

{ #category : #tests }
ProcessSpawnerTightTransactionTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTimeWithTightTransaction [

	processSpawner1 channelWhereIsSend: register.
	processSpawner1 signal.
	"It is a synchronization, useless in this exmaple synchronization"
	processSpawner1 channelWhereIsReceive.

	processSpawner1 signal.


	processSpawner2 channelWhereIsSend: register.
	processSpawner2 signal.
	processSpawner2 channelWhereIsReceive.

	processSpawner1 sendRegister: register.
	processSpawner1 signal.
	processSpawner1 receiveRegister.

	processSpawner2 signal.

	processSpawner2 sendRegister: register.
	processSpawner2 signal.
	processSpawner2 receiveRegister.


	"We wait until the processSwapner finishes execution before asserting"
	processSpawner1 waitFinished.
	processSpawner2 waitFinished.
	self assert: processSpawner2 isError
]

{ #category : #tests }
ProcessSpawnerTightTransactionTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTimeWithTightTransactionWithFullTransfer [
	
	"Change the channels"
	processSpawner1 registerChannelSend: CopyValueTransferChannel new.
	processSpawner1 registerChannelReceive: CopyValueTransferChannel new.
	processSpawner2 registerChannelSend: CopyValueTransferChannel new.
	processSpawner2 registerChannelReceive: CopyValueTransferChannel new.

	processSpawner1 channelWhereIsSend: register.
	processSpawner1 signal.
	"It is a synchronization, useless in this exmaple"
	processSpawner1 channelWhereIsReceive.

	processSpawner1 signal.


	processSpawner2 channelWhereIsSend: register.
	processSpawner2 signal.
	processSpawner2 channelWhereIsReceive.

	processSpawner1 sendRegister: register.
	processSpawner1 signal.
	processSpawner1 receiveRegister.

	processSpawner2 signal.

	self should: [processSpawner2 channelInSend: register.] raise: MessageNotUnderstood.
	"processSpawner2 signal.
	processSpawner2 receiveRegister.

	processSpawner1 waitFinished.
	processSpawner2 waitFinished.
	self assert: processSpawner2 isError"
]
