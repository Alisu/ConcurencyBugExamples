Class {
	#name : #Barber,
	#superclass : #Object,
	#instVars : [
		'barberShop'
	],
	#category : #ConcurrencyLivelock
}

{ #category : #'instance creation' }
Barber class >> newFor: aBarberShop [

	| instance |
	instance := self new.
	instance barberShop: aBarberShop.
	^instance 
]

{ #category : #accessing }
Barber >> barberShop: aBarberShop [

	barberShop := aBarberShop.
]

{ #category : #'as yet unclassified' }
Barber >> cutHairOf: aBarberShopCustomer [

	aBarberShopCustomer hasHairCut: true.
]

{ #category : #'as yet unclassified' }
Barber >> works [

	"return the process we will catch it to terminate it after a time out"

	| customer |
	^ [ 
	  [ barberShop hasCustomers ] whileTrue: [ 
		  customer := barberShop nextCustomer.
		  self cutHairOf: customer ] ] fork
]
