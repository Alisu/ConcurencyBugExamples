Class {
	#name : #ExampleWebApp,
	#superclass : #Object,
	#instVars : [
		'userInterruptSemaphore',
		'requestSemaphore',
		'data',
		'error',
		'finishedSemaphore'
	],
	#category : #ConcurrencyBadMessageInterleaving
}

{ #category : #'as yet unclassified' }
ExampleWebApp >> doSomethingWith: anObject [

	"It has no importance. We should never arrive here with a bad interleaving"
	
]

{ #category : #accessing }
ExampleWebApp >> firstRequest [

	data := Dictionary new.
	data at: #someKey put: Object new.
]

{ #category : #initialization }
ExampleWebApp >> initialize [ 

	userInterruptSemaphore := Semaphore new.
	requestSemaphore := Semaphore new.
	finishedSemaphore := Semaphore new.
	error := false.
]

{ #category : #accessing }
ExampleWebApp >> isOnError [
	^error
]

{ #category : #requesting }
ExampleWebApp >> requesting [
	[self firstRequest.
	self secondRequest] fork.
]

{ #category : #accessing }
ExampleWebApp >> secondRequest [

	| dataToWorkWith |
	[ 
	requestSemaphore wait.
	dataToWorkWith := data at: #someKey.
	self doSomethingWith: dataToWorkWith ] onErrorDo: [ 
		error := true.
		finishedSemaphore signal ]
]

{ #category : #signalling }
ExampleWebApp >> signalUserInterrupt [
	userInterruptSemaphore signal.
]

{ #category : #accessing }
ExampleWebApp >> userInteraction [

	[userInterruptSemaphore wait.
	data := nil.
	requestSemaphore signal.
	] fork.
]

{ #category : #waiting }
ExampleWebApp >> waitFinished [
	
    finishedSemaphore wait.
]
