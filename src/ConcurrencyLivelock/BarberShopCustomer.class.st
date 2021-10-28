Class {
	#name : #BarberShopCustomer,
	#superclass : #Object,
	#instVars : [
		'hasHairCut'
	],
	#category : #ConcurrencyLivelock
}

{ #category : #accessing }
BarberShopCustomer >> hasHairCut [
	^ hasHairCut
]

{ #category : #accessing }
BarberShopCustomer >> hasHairCut: aBoolean [

	hasHairCut := aBoolean
]

{ #category : #initialization }
BarberShopCustomer >> initialize [ 
	hasHairCut := false.
]
