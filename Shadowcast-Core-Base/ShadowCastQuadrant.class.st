Class {
	#name : #ShadowCastQuadrant,
	#superclass : #Object,
	#instVars : [
		'cardinal',
		'ox',
		'oy',
		'origin'
	],
	#category : #'Shadowcast-Core-Base'
}

{ #category : #accessing }
ShadowCastQuadrant >> asString [
	^ cardinal asString
]

{ #category : #accessing }
ShadowCastQuadrant >> cardinal [
	^ cardinal
]

{ #category : #accessing }
ShadowCastQuadrant >> cardinal: anObject [
	cardinal := anObject
]

{ #category : #accessing }
ShadowCastQuadrant >> origin [
	^ origin
]

{ #category : #accessing }
ShadowCastQuadrant >> origin: anObject [
	origin := anObject.
	ox := origin x.
	oy := origin y
	
]

{ #category : #accessing }
ShadowCastQuadrant >> ox [
	^ ox
]

{ #category : #accessing }
ShadowCastQuadrant >> ox: anObject [
	ox := anObject
]

{ #category : #accessing }
ShadowCastQuadrant >> oy [
	^ oy
]

{ #category : #accessing }
ShadowCastQuadrant >> oy: anObject [
	oy := anObject
]

{ #category : #accessing }
ShadowCastQuadrant >> transform: tile [

	| row col |
	row := tile x.
	col := tile y.
	" if self.cardinal == north:  return (self.ox + col, self.oy - row)
     if self.cardinal == south:  return (self.ox + col, self.oy + row)
     if self.cardinal == east:   return (self.ox + row, self.oy + col)
     if self.cardinal == west:   return (self.ox - row, self.oy + col)"
	cardinal = 0 ifTrue: [ ^ ox + col @ (oy - row) ]. "north"
	cardinal = 2 ifTrue: [ ^ ox + col @ (oy + row) ]. "south"
	cardinal = 1 ifTrue: [ ^ ox + row @ (oy + col) ]. "east"
	cardinal = 3 ifTrue: [ ^ ox - row @ (oy + col) ] "west"
]
