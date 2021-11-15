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
		string := string , 'blah '.
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

{ #category : #tests }
TestConcurrentCollection >> testOrderedCollectionConcurrentAddAfter [

	| increment collectionTest incrementRef  oldObject collectionRef oldObjectRef |
	
	"Racy execution"
	collectionTest := OrderedCollection new.
	increment := 0.
	oldObject := 'Blah ', increment asString.
	collectionTest addFirst: oldObject.
	10000 timesRepeat: [ 
		[ 	|newObject|
		increment := increment + 1.
		newObject := 'Blah ', increment asString.
		collectionTest add: newObject after: oldObject.
		oldObject := newObject.
		 ] fork ].

	"Reference to comapre the result we should have"
	collectionRef := OrderedCollection new.
	incrementRef := 0.
	oldObjectRef := 'Blah ', increment asString.
	collectionRef addFirst: oldObject.
	10000 timesRepeat: [ |newObject|
		incrementRef := incrementRef + 1.
		newObject := 'Blah ', increment asString.
		collectionRef add: newObject after: oldObjectRef.
		oldObjectRef := newObject. ].
	self
		  deny: collectionTest
		  equals: collectionRef
]
