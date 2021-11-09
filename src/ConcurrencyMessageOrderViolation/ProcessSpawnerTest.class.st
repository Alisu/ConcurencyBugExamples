Class {
	#name : #ProcessSpawnerTest,
	#superclass : #TestCase,
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #running }
ProcessSpawnerTest >> setUp [
	super setUp.

]

{ #category : #tests }
ProcessSpawnerTest >> testConcurrentProcessSpawnerDoesNotRegisterAtSameTime [

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
