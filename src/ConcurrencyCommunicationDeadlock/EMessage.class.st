Class {
	#name : #EMessage,
	#superclass : #Object,
	#instVars : [
		'nextTarget',
		'content'
	],
	#category : #ConcurrencyCommunicationDeadlock
}

{ #category : #'instance creation' }
EMessage class >> newNextTarget: aMailboxe content: anotherString [ 
	
	| instance |
	instance := self new.
	instance nextTarget: aMailboxe;
	content: anotherString.
	^instance
]

{ #category : #'instance creation' }
EMessage class >> newWithContent: aString2 [

	| instance |
	instance := self new.
	instance content: aString2.
	^ instance
]

{ #category : #accessing }
EMessage >> content [
	^ content
]

{ #category : #setting }
EMessage >> content: aString [ 
	content := aString
]

{ #category : #checking }
EMessage >> isPingRequest [
	^content = 'ping'
]

{ #category : #checking }
EMessage >> isPongRequest [
	^content = 'pong'
]

{ #category : #checking }
EMessage >> isReply [
	^content = 'pong'
]

{ #category : #checking }
EMessage >> isStop [
	^content = 'stop'
]

{ #category : #accessing }
EMessage >> nextTarget [
	^ nextTarget
]

{ #category : #setting }
EMessage >> nextTarget: anUndefinedObject [ 
	nextTarget := anUndefinedObject
]
