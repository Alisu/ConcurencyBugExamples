Class {
	#name : #TestConcurrentCollection,
	#superclass : #TestCase,
	#category : #ConcurrencyCollectionPharo
}

{ #category : #accessing }
TestConcurrentCollection class >> defaultTimeLimit [
	^DefaultTimeLimit ifNil: [DefaultTimeLimit := 60 seconds]
]

{ #category : #tests }
TestConcurrentCollection >> testDictionary [

	| increment dictTest string dictRef incrementRef stringRef |
	dictTest := Dictionary new.
	increment := 0.
	string := 'Blah ' , increment asString.
	dictTest add: #increment -> string.
	10000 timesRepeat: [ 
		[ 
		increment := increment + 1.
		string := string , increment asString.
		dictTest add: #increment -> increment ] fork ].
	dictRef := Dictionary new.
	incrementRef := 0.
	"stringRef := 'Blah ' , incrementRef asString."
	dictRef add: #increment -> stringRef.
	10000 timesRepeat: [ 
		incrementRef := incrementRef + 1.
		"stringRef := stringRef , incrementRef asString."
		dictRef add: #increment -> incrementRef ].
	self
		  assert: (dictTest at: #increment)
		  equals: (dictRef at: #increment)
]

{ #category : #tests }
TestConcurrentCollection >> testDictionaryWithOutStringManipulation [

	| increment dictTest dictRef incrementRef  |
	
	"Racy execution"
	dictTest := Dictionary new.
	increment := 0.
	dictTest add: #increment -> increment.
	10000 timesRepeat: [ 
		[ 
		increment := increment + 1.
		dictTest add: #increment -> increment ] fork ].

	"Reference to comapre the result we should have"
	dictRef := Dictionary new.
	incrementRef := 0.
	dictRef add: #increment -> incrementRef.
	10000 timesRepeat: [ 
		incrementRef := incrementRef + 1.
		dictRef add: #increment -> incrementRef ].
	self
		  deny: (dictTest at: #increment)
		  equals: (dictRef at: #increment)
]
