Class {
	#name : #EPong,
	#superclass : #Object,
	#instVars : [
		'mailboxe',
		'sentPong',
		'receivePing'
	],
	#category : #ConcurrencyCommunicationDeadlock
}

{ #category : #initialization }
EPong >> initialize [ 

	mailboxe := AtomicSharedQueue new.
	sentPong := false.
	receivePing := false.

]

{ #category : #accessing }
EPong >> mailboxe [
	^ mailboxe
]

{ #category : #accessing }
EPong >> pong: aPinger [

	| receivedMessage pongMessage okMessage |
	
	pongMessage := (EMessage newNextTarget: self mailboxe content: 'pong').
	okMessage := (EMessage newNextTarget: self mailboxe content: 'ok').
	
	aPinger mailboxe nextPut: pongMessage.
	sentPong := true.
	receivedMessage := mailboxe next.
	receivedMessage isPingRequest ifTrue: [ 
		receivePing := true.
		receivedMessage nextTarget nextPut: pongMessage. ].
	receivedMessage isStop ifTrue: [ 
		aPinger mailboxe nextPut: okMessage.
		^ true ].
	self pong: aPinger.
]

{ #category : #accessing }
EPong >> receivePing [
	^ receivePing
]

{ #category : #accessing }
EPong >> sentPong [
	^ sentPong
]
