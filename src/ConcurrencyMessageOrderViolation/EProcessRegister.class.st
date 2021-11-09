Class {
	#name : #EProcessRegister,
	#superclass : #Dictionary,
	#instVars : [
		'owner'
	],
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #'instance creation' }
EProcessRegister class >> newOwned [

	| instance |
	instance := self new.
	instance owner: Processor activeProcess.
	^instance
]

{ #category : #setting }
EProcessRegister >> owner: aProcess [

"Hack becasue it do not know how to bypass the bytecode or ask the compiler to send a instVarAt:Put: instead"

	(owner isNil
		or: [ owner = Processor activeProcess ])
		ifTrue: [ owner := aProcess ]
	ifFalse: [ ^(ModificationForbidden for: self at: 0 with: aProcess retrySelector: #owner:) signal  ]
]

{ #category : #'as yet unclassified' }
EProcessRegister >> registerName: aName for: aPid [

	self
		at: aName
		ifPresent: [ self error: 'key already used' ]
		ifAbsentPut: aPid
]

{ #category : #'as yet unclassified' }
EProcessRegister >> registered [

	^ self keys 
]

{ #category : #'as yet unclassified' }
EProcessRegister >> whereis: aName [

	^self at: aName ifAbsent: [ nil ]
]
