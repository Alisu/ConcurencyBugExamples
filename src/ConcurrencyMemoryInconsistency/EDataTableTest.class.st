Class {
	#name : #EDataTableTest,
	#superclass : #TestCase,
	#instVars : [
		'globalProcessRegister',
		'semaphoreForOrdering',
		'semaphoreForOrdering2',
		'dataTable',
		'joinPointSemaphore'
	],
	#category : #ConcurrencyMemoryInconsistency
}

{ #category : #running }
EDataTableTest >> setUp [
	super setUp.
	
	dataTable := EDataTable newName: 'MyLittleDataTable'.
	joinPointSemaphore := Semaphore new.
	dataTable jointPointSemaphore: joinPointSemaphore.
]

{ #category : #tests }
EDataTableTest >> testLeftBoxFigure2 [

	| increment numberOfRepetition |

	increment := 1.
	numberOfRepetition := 10.
	
	numberOfRepetition timesRepeat: [ [ dataTable inc: dataTable _: increment ] fork ].
	
	numberOfRepetition timesRepeat: [ joinPointSemaphore wait ].
	
	numberOfRepetition timesRepeat: [  dataTable signal ].
	
	numberOfRepetition timesRepeat: [ joinPointSemaphore wait ].

	self
		deny: (dataTable lookupFor: #some_key inTable: dataTable)
		equals: numberOfRepetition + 1.
]
