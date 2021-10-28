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
ProcregFunctionLikeTest >> testExample1OfArticle [

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
	processSpawner2 waitFinished.
	
	self assert: processSpawner2 isError.
	
	
	

]

{ #category : #tests }
ProcregFunctionLikeTest >> testExample1OfArticleWithChannels [

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

	| pid1 pid2 channel |
	[ 
	globalProcessRegister whereis: 'gazonk'.
	pid1 := EProcess spawn.
	semaphoreForOrdering signal.
	semaphoreForOrdering2 wait.
	globalProcessRegister registerName: 'gazonk' for: pid1.
	channel send: globalProcessRegister.
	semaphoreForOrdering signal ] fork.

	self
		should: [ 
			[ 
			semaphoreForOrdering wait.
			globalProcessRegister := channel receive.
			globalProcessRegister whereis: 'gazonk'.
			semaphoreForOrdering2 signal.
			semaphoreForOrdering wait.
			pid2 := EProcess spawn.
			globalProcessRegister registerName: 'gazonk' for: pid2 ] fork ]
		raise: Error
]
