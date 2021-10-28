Class {
	#name : #ExampleWebAppTest,
	#superclass : #TestCase,
	#category : #ConcurrencyBadMessageInterleaving
}

{ #category : #tests }
ExampleWebAppTest >> testBadInterleaving [

	| myWebApp |
	myWebApp := ExampleWebApp new.
	myWebApp requesting.
	myWebApp userInteraction.
	
	myWebApp signalUserInterrupt.
	
	myWebApp waitFinished.
	
	self assert: myWebApp isOnError.

	
	
]
