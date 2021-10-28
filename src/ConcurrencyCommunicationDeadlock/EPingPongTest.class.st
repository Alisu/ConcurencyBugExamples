Class {
	#name : #EPingPongTest,
	#superclass : #TestCase,
	#category : #ConcurrencyCommunicationDeadlock
}

{ #category : #tests }
EPingPongTest >> testPing [

	"I started with the example in Test-Driven Development of Concurrent
Programs using Concuerror but in the end used Static Detection of Deadlocks in Erlang"

	| ponger pinger |
	ponger := EPong new.
	pinger := EPing new.
	
	[ponger pong: pinger.] fork.
	pinger ping: ponger.
	
	"We use this delay as timeOut then the pinger send a stop message to stop the ponger"
	(Delay forSeconds: 3) wait.
	pinger stop: ponger.

	self assert: ponger sentPong.
	self deny: ponger receivePing
]
