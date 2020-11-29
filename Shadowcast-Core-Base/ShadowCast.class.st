Class {
	#name : #ShadowCast,
	#superclass : #Object,
	#instVars : [
		'markVisible',
		'isBlocking',
		'radius'
	],
	#category : #'Shadowcast-Core-Base'
}

{ #category : #accessing }
ShadowCast class >> roundTiesDown: n [
	^ (n - 0.5) ceiling 
]

{ #category : #accessing }
ShadowCast class >> roundTiesUp: n [
	^ (n + 0.5) floor
]

{ #category : #accessing }
ShadowCast class >> slope: tile [

	| rowDepth col |
	rowDepth := tile x.
	col := tile y.
	"return Fraction(2 * col - 1, 2 * row_depth)"
	^ Fraction numerator: 2 * col -1  denominator: (2 * rowDepth)
]

{ #category : #'as yet unclassified' }
ShadowCast >> computeFov: origin [

	markVisible value: origin.
	Transcript
		show: 'computeFov from origin ' , origin asString;
		cr.
	0 to: 3 do: [ :i | 
		| quadrant firstRow |
		quadrant := ShadowCastQuadrant new
			            cardinal: i;
			            origin: origin.
		firstRow := ShadowCastRow new
			            depth: 1;
			            startSlope: (Fraction numerator: -1 denominator: 1);
			            endSlope: (Fraction numerator: 1 denominator: 1).
			Transcript show:'caling scan on quadrant ',i asString;cr.
		self scan: firstRow quadrant: quadrant ]
]

{ #category : #accessing }
ShadowCast >> isBlocking [
	^ isBlocking
]

{ #category : #accessing }
ShadowCast >> isBlocking: anObject [
	isBlocking := anObject
]

{ #category : #'as yet unclassified' }
ShadowCast >> isFloor: tile quadrant: quadrant [
	| point |
	tile ifNil: [ ^ false ].
	point := quadrant transform: tile.
	"Transcript show:'isFloor called for ',tile asString;cr."
	^ (isBlocking  value: tile) not
]

{ #category : #accessing }
ShadowCast >> isSymmetric: row tile: tile [
	| rowDepth col |
	rowDepth := tile x.
	col := tile y.
	"return (col >= row.depth * row.start_slope
        and col <= row.depth * row.end_slope)"
	^ (col >= (row depth * (row startSlope))) and: (col <= (row depth * (row endSlope)))
]

{ #category : #'as yet unclassified' }
ShadowCast >> isWall: tile quadrant: quadrant [
	| point rv |
	tile ifNil: [ ^ false ].
	point := quadrant transform: tile.
	rv := self isBlocking value: point.
	"Transcript show:'isWall for ',tile asString,' got ',rv asString;cr."
	^ rv.
]

{ #category : #accessing }
ShadowCast >> markVisible [
	^ markVisible
]

{ #category : #accessing }
ShadowCast >> markVisible: anObject [
	markVisible := anObject
]

{ #category : #accessing }
ShadowCast >> passedFloor: tile prevTile: prevTile row: row quadrant: quadrant [
	"if is_floor(prev_tile) and is_wall(tile)"
	^ (self isWall: tile quadrant: quadrant)
		and: (self isFloor: prevTile quadrant: quadrant)
]

{ #category : #accessing }
ShadowCast >> passedWall: tile prevTile: prevTile row: row quadrant: quadrant [
	"if is_wall(prev_tile) and is_floor(tile)"
	^ (self isWall: prevTile quadrant: quadrant)
		& (self isFloor: tile quadrant: quadrant)
]

{ #category : #accessing }
ShadowCast >> radius [
	^ radius
]

{ #category : #accessing }
ShadowCast >> radius: anObject [
	radius := anObject
]

{ #category : #'as yet unclassified' }
ShadowCast >> reveal: tile quadrant: quadrant [
	| point |
	point := quadrant transform: tile.
	markVisible value: point
]

{ #category : #scanning }
ShadowCast >> scan: row quadrant: quadrant [

	| prevTile |
	"Transcript show:'scan for quadrant ',quadrant asString,' row ', row asString;cr."
	prevTile := nil.
	row tiles do: [ :tile | 
		(self shouldReveal: tile row: row quadrant: quadrant) ifTrue: [ 
			self reveal: tile quadrant: quadrant ].
		(self passedWall: tile prevTile: prevTile row: row quadrant: quadrant) ifTrue: [ 
			row startSlope: (self class slope: tile) ].
		(self passedFloor: tile prevTile: prevTile row: row quadrant: quadrant) ifTrue: [ 
			| nextRow |
			nextRow := row next.
			nextRow endSlope: (self class slope: tile).
			self scan: nextRow quadrant: quadrant ].
		prevTile := tile.
		((self isFloor: prevTile quadrant: quadrant) and: row depth < radius) 
			ifTrue: [ self scan: row next quadrant: quadrant ] ]
]

{ #category : #accessing }
ShadowCast >> shouldReveal: tile row: row quadrant: quadrant [
	^ (self isWall: tile quadrant: quadrant)
		or: (self isSymmetric: row tile: tile)
]
