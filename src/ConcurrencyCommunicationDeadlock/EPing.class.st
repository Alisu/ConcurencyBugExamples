Class {
	#name : #EPing,
	#superclass : #Object,
	#instVars : [
		'mailboxe',
		'lastReply'
	],
	#category : #ConcurrencyCommunicationDeadlock
}

{ #category : #initialization }
EPing >> initialize [ 

	mailboxe := AtomicSharedQueue new.
]

{ #category : #accessing }
EPing >> lastReply [
	^ lastReply
]

{ #category : #accessing }
EPing >> mailboxe [
	^ mailboxe
]

{ #category : #accessing }
EPing >> ping: aPonger [

	| response pingMessage |
	pingMessage := EMessage newNextTarget: self mailboxe content: 'ping'.
	response := mailboxe next.
	response isPongRequest ifTrue: [ lastReply := response content.
		"aPonger mailboxe nextPut: pingMessage ."
		 ]
]

{ #category : #accessing }
EPing >> stop: aPonger [

	| stopMessage |
	stopMessage := EMessage newNextTarget: self mailboxe content: 'stop'.
	aPonger mailboxe nextPut: stopMessage.
	^mailboxe next content.

]
