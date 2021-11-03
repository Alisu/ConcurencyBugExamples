Class {
	#name : #ProcregFunctionLikeTest,
	#superclass : #TestCase,
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #running }
ProcregFunctionLikeTest >> setUp [
	super setUp.

]

{ #category : #tests }
ProcregFunctionLikeTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTime [

	"proc-reg code:
			proc_reg(Name) ->
			...
				case whereis(Name) of
					undefined ->
						Pid = spawn(...),
						register(Name,Pid);
				Pid -> % already
				true % registered
			end,"

	"The bad interleaving
			proc_reg(gazonk)
			. . . 							proc_reg(gazonk)
			whereis(gazonk)
											. . . 
			Pid1 = spawn(...)
											whereis(gazonk)
			register(gazonk,Pid1)
											Pid2 = spawn(...)
											register(gazonk,Pid2)"

	"We will simulate the proc_reg function with the bad interleaving"

	| processSpawner1 processSpawner2 register |
	register := EProcessRegister new.
	processSpawner1 := ProcessSpawner spawnWithRegister: register.
	processSpawner2 := ProcessSpawner spawnWithRegister: register.
	
	processSpawner1 signal.
	processSpawner1 signal.
	
	processSpawner2 signal.
	
	processSpawner1 signal.

	processSpawner2 signal.
	processSpawner2 signal.
	
	"We wait until the processSwapner finishes execution before asserting"
	processSpawner1 waitFinished.
	processSpawner2 waitFinished.
	self assert: processSpawner2 isError.
	
	
	

]

{ #category : #tests }
ProcregFunctionLikeTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTimeWithLooseTransactionWithFullChannel [

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
ProcregFunctionLikeTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTimeWithLooseTransactionWithWriteChannel [

	"testConcurrentProcessSpawnerDoesNotRegisterAtSameTime is the orignal bug.
LooseTransaction means there is only a send and receive englobing all the proc_reg message.
In this solution we use a WritePermissionTransferChannel.
Since we already transfered the write permission we cannot transfer it a second time thus we have an Error"

	| processSpawner1 processSpawner2 register |
	register := EProcessRegister newOwned.
	processSpawner1 := ProcessSpawnerLooseTransaction spawn.
	processSpawner2 := ProcessSpawnerLooseTransaction spawn.

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

{ #category : #tests }
ProcregFunctionLikeTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTimeWithTightTransaction [

	"proc-reg code:
			proc_reg(Name) ->
			...
				case whereis(Name) of
					undefined ->
						Pid = spawn(...),
						register(Name,Pid);
				Pid -> % already
				true % registered
			end,"

	"The bad interleaving
			proc_reg(gazonk)
			. . . 							proc_reg(gazonk)
			whereis(gazonk)
											. . . 
			Pid1 = spawn(...)
											whereis(gazonk)
			register(gazonk,Pid1)
											Pid2 = spawn(...)
											register(gazonk,Pid2)"

	"We will simulate the proc_reg function with the bad interleaving"

	| processSpawner1 processSpawner2 register |
	register := EProcessRegister new.
	processSpawner1 := ProcessSpawnerLooseTransaction spawn.
	processSpawner2 := ProcessSpawnerLooseTransaction spawn.
	
	processSpawner1 channelInSend: register.
	
	processSpawner1 signal.
	processSpawner1 signal.
	
	self should: [processSpawner2 channelInSend: register] raise: ModificationForbidden.
	processSpawner2 signal.
	
	processSpawner1 signal.

	processSpawner2 signal.
	processSpawner2 signal.
	
	"We wait until the processSwapner finishes execution before asserting"
	processSpawner1 waitFinished.
	processSpawner2 waitFinished.
	self assert: processSpawner2 isError.
	
	
	

]
