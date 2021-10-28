Class {
	#name : #BarberShop,
	#superclass : #Object,
	#instVars : [
		'barber',
		'waitingRoom'
	],
	#category : #ConcurrencyLivelock
}

{ #category : #'as yet unclassified' }
BarberShop >> fillWaitingRoom: aNumber [

	aNumber timesRepeat: [waitingRoom add: BarberShopCustomer new.]
]

{ #category : #testing }
BarberShop >> hasCustomers [

	^ waitingRoom isNotEmpty.
]

{ #category : #initialization }
BarberShop >> initialize [

	barber := Barber newFor: self.
	waitingRoom := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
BarberShop >> nextCustomer [

	^ waitingRoom first.
]

{ #category : #'instance creation' }
BarberShop >> open [

	| barberProcess |
	barberProcess := barber works.
	
	"The shop closes after a day, since our barber is livelocked we terminate him at the end of the day."
	(Delay forSeconds: 3) wait.
	barberProcess terminate.
]

{ #category : #accessing }
BarberShop >> waitingRoom [
	^ waitingRoom
]
