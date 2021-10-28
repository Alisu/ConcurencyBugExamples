Class {
	#name : #EProcessRegister,
	#superclass : #Dictionary,
	#category : #'ConcurrencyMessageOrderViolation-ProcessusRegister'
}

{ #category : #'as yet unclassified' }
EProcessRegister >> registerName: aName for: aPid [

	self
		at: aName
		ifPresent: [ self error: 'key already used' ]
		ifAbsent: [ self add: aName -> aPid ]
]

{ #category : #'as yet unclassified' }
EProcessRegister >> registered [

	^ self keys 
]

{ #category : #'as yet unclassified' }
EProcessRegister >> whereis: aName [

	^self at: aName ifAbsent: [ nil ]
]
