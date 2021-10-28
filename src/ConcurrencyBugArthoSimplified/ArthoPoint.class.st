Class {
	#name : #ArthoPoint,
	#superclass : #Point,
	#instVars : [
		'mutex',
		'achieved'
	],
	#category : #ConcurrencyBugArthoSimplified
}

{ #category : #'as yet unclassified' }
ArthoPoint >> achieved [

	mutex critical: [ achieved := true ]
]

{ #category : #'as yet unclassified' }
ArthoPoint >> achieved: aBoolean [

	mutex critical: [ achieved := aBoolean ]
]

{ #category : #accessing }
ArthoPoint >> getXY [

	^ mutex critical: [ ^self ]
]

{ #category : #initialization }
ArthoPoint >> initialize [

	mutex := Semaphore forMutualExclusion.
]

{ #category : #accessing }
ArthoPoint >> setX: xValue setY: yValue [

	mutex critical: [^ super setX: xValue setY: yValue ]
]

{ #category : #'as yet unclassified' }
ArthoPoint >> unsafeX [

	^x
]

{ #category : #'as yet unclassified' }
ArthoPoint >> unsafeX: xValue [

	x := xValue
]

{ #category : #'as yet unclassified' }
ArthoPoint >> unsafeY [

	^y
]

{ #category : #'as yet unclassified' }
ArthoPoint >> unsafeY: yValue [

	y := yValue
]

{ #category : #accessing }
ArthoPoint >> x [

	mutex critical: [^ super x ]
]

{ #category : #accessing }
ArthoPoint >> x: xValue [

	mutex critical: [^ self unsafeX: xValue ]
]

{ #category : #accessing }
ArthoPoint >> y [

	mutex critical: [^ super y ]
]

{ #category : #accessing }
ArthoPoint >> y: yValue [

	mutex critical: [^ self unsafeY: yValue ]
]
