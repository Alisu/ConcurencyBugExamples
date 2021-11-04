Class {
	#name : #ProcessSpawnerTightTransactionTest,
	#superclass : #ProcessSpawnerTest,
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #tests }
ProcessSpawnerTightTransactionTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTimeWithTightTransaction [

	| processSpawner1 processSpawner2 register|
	register := EProcessRegister new.
	processSpawner1 := ProcessSpawnerTightTransaction spawn.
	processSpawner2 := ProcessSpawnerTightTransaction spawn.

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
