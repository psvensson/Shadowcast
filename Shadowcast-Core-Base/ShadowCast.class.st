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

{ #category : #accessing }
ShadowCast >> computeFov: origin [
	markVisible value: origin.
	Transcript
		show: 'computeFov from origin ' , origin asString;
		cr.
	0 to: 3 do: [ :i | self computeFovFor: origin quadrant: i ]
]

{ #category : #accessing }
ShadowCast >> computeFovFor: origin quadrant: i [
	| quadrant firstRow |
		quadrant := ShadowCastQuadrant new
			            cardinal: i;
			            origin: origin.
		firstRow := ShadowCastRow new
			            depth: 1;
			            startSlope: (Fraction numerator: -1 denominator: 1);
			            endSlope: (Fraction numerator: 1 denominator: 1).
			Transcript show:'caling scan on quadrant ',i asString;cr.
		self scan: firstRow quadrant: quadrant
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
	^ (isBlocking  value:point) not
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

{ #category : #accessing }
ShadowCast >> isWall: tile quadrant: quadrant [
	| point rv |
	tile ifNil: [ ^ false ].
	point := quadrant transform: tile.
	rv := self isBlocking value: point.
	"Transcript show:'isWall for ',point asString,' got ',rv asString;cr."
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
	"Transcript
		show:
			'----- scan for quadrant ' , quadrant asString , ' row '
				, row asString;
		cr."
	prevTile := nil.
	row tiles
		do: [ :tile | 
			(self shouldReveal: tile row: row quadrant: quadrant)
				ifTrue: [ self reveal: tile quadrant: quadrant ].
			(self
				passedWall: tile
				prevTile: prevTile
				row: row
				quadrant: quadrant)
				ifTrue: [ row startSlope: (self class slope: tile) ].
			(self
				passedFloor: tile
				prevTile: prevTile
				row: row
				quadrant: quadrant)
				ifTrue: [ | nextRow |
					row depth < radius
						ifTrue: [ nextRow := row next.
							nextRow endSlope: (self class slope: tile).
							self scan: nextRow quadrant: quadrant ] ].
			prevTile := tile ].
	((self isFloor: prevTile quadrant: quadrant) and: row depth < radius)
		ifTrue: [ | nextRow |
			nextRow := row next.
			self scan: nextRow quadrant: quadrant ]
]

{ #category : #accessing }
ShadowCast >> shadowCasterOn: aView [
	<gtView>
	^ aView explicit
		title: 'Details' translated;
		priority: 5;
		stencil:
				[ | container verticalContainer detailsTextContainer avatarContainer nameTextContainer details |
			container := BlElement new
				layout: BlLinearLayout horizontal;
				background: Color white;
				look: BrShadowLook;
				margin: (BlInsets all: 20);
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent ].
			detailsTextContainer := BrEditor new
				look: (BrGlamorousRegularEditorLook new fontSize: 16);
				text: details;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			verticalContainer := BlElement new
				layout: BlLinearLayout vertical;
				margin: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			nameTextContainer := BlTextElement new
				constraintsDo: [ :c | c horizontal matchParent ];
				margin:
					(BlInsets
						top: 5
						right: 0
						bottom: 20
						left: 5);
				text:
					('Foobar' asRopedText glamorousRegularFont
						fontSize: 30;
						foreground: Color black).
			verticalContainer addChild: nameTextContainer.
			container addChild: verticalContainer.
			container ]
]

{ #category : #accessing }
ShadowCast >> shouldReveal: tile row: row quadrant: quadrant [
	^ (self isWall: tile quadrant: quadrant)
		or: (self isSymmetric: row tile: tile)
]
