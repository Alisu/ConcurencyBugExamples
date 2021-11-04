Class {
	#name : #ProcessSpawnerLooseTransactionTest,
	#superclass : #ProcessSpawnerTest,
	#instVars : [
		'register',
		'processSpawner1',
		'processSpawner2'
	],
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #running }
ProcessSpawnerLooseTransactionTest >> setUp [
	super setUp.
	register := EProcessRegister newOwned.
	processSpawner1 := ProcessSpawnerLooseTransaction spawn.
	processSpawner2 := ProcessSpawnerLooseTransaction spawn.

]

{ #category : #tests }
ProcessSpawnerLooseTransactionTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTimeWithLooseTransactionWithCopyValueChannel [

	"testConcurrentProcessSpawnerDoesNotRegisterAtSameTime is the orignal bug.
LooseTransaction means there is only a send and receive englobing all the proc_reg message.
In this solution we use a FullPermissionTransferChannel.
We have a problem during the transfer cause Object instance do not understand owner: else we should have a DNU during runtime but there is no garanty
May be we should have a specific placeholder."

	| processSpawner1 processSpawner2 register |
	register := EProcessRegister newOwned.
	processSpawner1 := ProcessSpawnerLooseTransaction spawn.
	processSpawner2 := ProcessSpawnerLooseTransaction spawn.
	
	"Changing the default writeChannel to fullChannel"
	processSpawner1 channelIn: CopyValueTransferChannel new.
	processSpawner2 channelIn: CopyValueTransferChannel new.

	processSpawner1 channelInSend: register.
	processSpawner2 channelInSend: register.

	processSpawner1 signal.
	processSpawner1 signal.

	processSpawner2 signal.
	
	processSpawner1 signal.

	processSpawner2 signal.
	processSpawner2 signal.
	
	
	processSpawner1 waitFinished.
	processSpawner2 waitFinished.
	self assert: processSpawner2 isError.
]

{ #category : #tests }
ProcessSpawnerLooseTransactionTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTimeWithLooseTransactionWithFullChannel [

	"testConcurrentProcessSpawnerDoesNotRegisterAtSameTime is the orignal bug.
LooseTransaction means there is only a send and receive englobing all the proc_reg message.
In this solution we use a FullPermissionTransferChannel.
We have a problem during the transfer cause Object instance do not understand owner: else we should have a DNU during runtime but there is no garanty
May be we should have a specific placeholder."
	
	"Changing the default writeChannel to fullChannel"
	processSpawner1 channelIn: FullPermissionTransferChannel new.
	processSpawner2 channelIn: FullPermissionTransferChannel new.

	processSpawner1 channelInSend: register.

	processSpawner1 signal.
	processSpawner1 signal.

	self should: [processSpawner2 channelInSend: register.] raise: MessageNotUnderstood.

	"
	processSpawner2 signal.
	
	processSpawner1 signal.

	processSpawner2 signal.
	processSpawner2 signal.
	
	
	processSpawner1 waitFinished.
	processSpawner2 waitFinished.
	self assert: processSpawner2 isError."
]

{ #category : #tests }
ProcessSpawnerLooseTransactionTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTimeWithLooseTransactionWithWriteChannel [

	"testConcurrentProcessSpawnerDoesNotRegisterAtSameTime is the orignal bug.
LooseTransaction means there is only a send and receive englobing all the proc_reg message.
In this solution we use a WritePermissionTransferChannel.
Since we already transfered the write permission we cannot transfer it a second time thus we have an Error"

	processSpawner1 channelInSend: register.

	processSpawner1 signal.
	processSpawner1 signal.

	self should: [ processSpawner2 channelInSend: register ] raise: ModificationForbidden

	"We dont need the rest, it should not work "
	"processSpawner2 signal.
	
	processSpawner1 signal.

	processSpawner2 signal.
	processSpawner2 signal.
	
	
	processSpawner1 waitFinished.
	processSpawner2 waitFinished.
	self assert: processSpawner2 isError."
]
