Class {
	#name : #BarberShopTest,
	#superclass : #TestCase,
	#instVars : [
		'barberShop'
	],
	#category : #ConcurrencyLivelock
}

{ #category : #tests }
BarberShopTest >> testLivelock [

	barberShop := BarberShop new.
	barberShop fillWaitingRoom: 10.
	barberShop open.
	
	"If we still have customer it means that probably we livelocked"
	self assert: barberShop hasCustomers.
	self assert: barberShop waitingRoom first hasHairCut.
	self deny: barberShop waitingRoom second hasHairCut. 
]
