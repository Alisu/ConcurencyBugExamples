Class {
	#name : #EProcess,
	#superclass : #Object,
	#instVars : [
		'pid'
	],
	#classVars : [
		'classPid'
	],
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #'instance creation' }
EProcess class >> spawn [

	| instance |
	instance := self new.
	^ instance pid
]

{ #category : #initialization }
EProcess >> initialize [
	
	classPid ifNil: [ classPid := 1 ].
	pid := classPid.
	classPid := classPid + 1.
]

{ #category : #accessing }
EProcess >> pid [ 
	^pid
]
