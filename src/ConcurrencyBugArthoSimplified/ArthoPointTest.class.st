Class {
	#name : #ArthoPointTest,
	#superclass : #TestCase,
	#instVars : [
		'point',
		'semaphoreForOrdering',
		'semaphoreForOrdering2'
	],
	#category : #ConcurrencyBugArthoSimplified
}

{ #category : #running }
ArthoPointTest >> setUp [
	super setUp.
	
	point := ArthoPoint new.
	semaphoreForOrdering := Semaphore new.
	semaphoreForOrdering2 := Semaphore new.
]

{ #category : #tests }
ArthoPointTest >> testPaperScenarioForConcurrencyBug [

	"Simulate that the task work on the property (here the point)"
	[ point y: 40.
	semaphoreForOrdering2 signal.
	semaphoreForOrdering wait.
	point achieved: true.
	 ] fork .
	
	"Simulate a random event changing the spacecraft state"
	[ 
	semaphoreForOrdering2 wait.
	point unsafeY: 0.
	semaphoreForOrdering signal.
	 ] fork.
	
	"The deamon checks the property"
	self deny: point getXY unsafeY equals: 40.
]
