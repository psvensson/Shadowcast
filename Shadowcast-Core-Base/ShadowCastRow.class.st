Class {
	#name : #ShadowCastRow,
	#superclass : #Object,
	#instVars : [
		'depth',
		'startSlope',
		'endSlope'
	],
	#category : #'Shadowcast-Core-Base'
}

{ #category : #accessing }
ShadowCastRow >> asString [
	^ depth asString,' start ',startSlope asString ,' end ',endSlope asString
]

{ #category : #accessing }
ShadowCastRow >> depth [
	^ depth
]

{ #category : #accessing }
ShadowCastRow >> depth: anObject [
	depth := anObject
]

{ #category : #accessing }
ShadowCastRow >> endSlope [
	^ endSlope
]

{ #category : #accessing }
ShadowCastRow >> endSlope: anObject [
	endSlope := anObject
]

{ #category : #accessing }
ShadowCastRow >> next [
	Transcript show:'row next for depth ',depth asString;cr.
	^ self class new
		  depth: depth + 1;
		  startSlope: startSlope;
		  endSlope: endSlope
]

{ #category : #accessing }
ShadowCastRow >> startSlope [
	^ startSlope
]

{ #category : #accessing }
ShadowCastRow >> startSlope: anObject [
	startSlope := anObject
]

{ #category : #accessing }
ShadowCastRow >> tiles [

	| minCol maxCol rv |
	rv := OrderedCollection new.
	minCol := ShadowCast roundTiesUp: depth * startSlope.
	maxCol := ShadowCast roundTiesDown: depth * endSlope.
	minCol  to: maxCol + 1  do: [ :col | rv add: depth @ col ].
	^ rv
]
