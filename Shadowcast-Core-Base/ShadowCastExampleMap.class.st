Class {
	#name : #ShadowCastExampleMap,
	#superclass : #Object,
	#instVars : [
		'map',
		'visibleArea',
		'minX',
		'minY',
		'maxX',
		'maxY',
		'scale',
		'origin'
	],
	#category : #'Shadowcast-Core-Base-Shadowcast-Core-Base'
}

{ #category : #accessing }
ShadowCastExampleMap >> addVisible: pos [
	self minMaxValues: pos.
	visibleArea at: pos put: (map at: pos ifAbsent: [1])
]

{ #category : #accessing }
ShadowCastExampleMap >> addVisible: pos tile: tile [
	self minMaxValues: pos.
	visibleArea at: pos put: tile
]

{ #category : #accessing }
ShadowCastExampleMap >> createLine: start to: end [
	^BlLineElement new
					fromAnchor: (BlAbsolutePositionAnchor position:start);
					toAnchor: (BlAbsolutePositionAnchor position: end);
					border: (BlBorder paint: Color gray width:1).
]

{ #category : #accessing }
ShadowCastExampleMap >> createSampleMap [
	#(#(1 1 1 1 1 1 1 1 1 1)
	#(1 0 1 0 0 0 0 0 0 1)
	#(1 0 1 0 0 0 0 0 0 1)
	#(1 0 0 0 0 0 1 1 0 1)
	#(1 0 0 0 1 0 0 0 0 1)
	#(1 0 0 0 1 0 0 0 0 1)
	#(1 1 1 1 1 0 0 1 0 1)
	#(1 0 0 0 0 0 0 0 0 1)
	#(1 0 0 0 0 0 0 0 0 1)
	#(1 1 1 1 1 1 1 1 1 1) )
		doWithIndex:
			[ :row :y | row doWithIndex: [ :cell :x | map at: x @ y put: cell ] ]
]

{ #category : #accessing }
ShadowCastExampleMap >> drawBoxAt: pos [
	| toBox |
	toBox := BlElement new
		size: scale@scale;
		background: (Color gray alpha: 0.3);
		border: (BlBorder builder width: 1; paint: Color gray; build);
		layout: BlFrameLayout new.
	toBox relocate: pos.
	^toBox
]

{ #category : #accessing }
ShadowCastExampleMap >> drawBoxAt: pos size: size [
	| toBox |
	toBox := BlElement new
		size: size@size;
		background: (Color gray alpha: 0.3);
		border: (BlBorder builder width: 1; paint: Color gray; build);
		layout: BlFrameLayout new.
	toBox relocate: pos.
	^toBox
]

{ #category : #accessing }
ShadowCastExampleMap >> drawBoxAt: pos size: size color: color [
	| toBox |
	toBox := BlElement new
		size: size@size;
		background: color;
		border: (BlBorder builder width: 1; paint: Color gray; build);
		layout: BlFrameLayout new.
	toBox relocate: pos.
	^toBox
]

{ #category : #accessing }
ShadowCastExampleMap >> exampleMap [
	<gtExample>
	| gamemap shadowCasting |
	origin := 8 @ 5.
	gamemap := ShadowCastExampleMap new origin: origin.
	shadowCasting := ShadowCast new.
	shadowCasting
		markVisible: [ :pos | gamemap addVisible: pos ];
		isBlocking: [ :pos | 
			| rv |
			rv := gamemap isWall: pos.
			rv ];
		radius: 4.
	shadowCasting computeFov: origin.
	gamemap
]

{ #category : #accessing }
ShadowCastExampleMap >> exampleMapOn: aView [
	<gtView>
	^ aView explicit
		title: 'Details for ' , origin asString;
		priority: 5;
		stencil: [ | container |
			container := BlElement new
				size: 700 @ 700;
				relocate: 50 @ 50.
			visibleArea keys
				do: [ :pos | 
					container
						addChild:
							(self
								drawBoxAt: pos * scale
								size: scale
								color: (Color gray alpha: 0.3)) ].
			map
				keysAndValuesDo: [ :mp :val | 
					(self isWall: mp)
						ifTrue: [ container
								addChild: (self drawBoxAt: mp * scale size: scale color: Color black) ] ].
			self drawBoxAt: origin * scale size: scale color: Color red.
			container ]
]

{ #category : #accessing }
ShadowCastExampleMap >> initialize [
	map := Dictionary new.
	visibleArea := Dictionary new.
	scale := 40.
	minX := 0.
	minY := 0.
	maxX := 0.
	maxY := 0.
	self createSampleMap
]

{ #category : #accessing }
ShadowCastExampleMap >> isFloor: pos [
	| val |
	val := map at: pos ifAbsent: [ 1 ].
	^ val = 0
]

{ #category : #accessing }
ShadowCastExampleMap >> isWall: pos [
	| val |
	val := map at: pos ifAbsent: [ 1 ].
	^ val = 1
]

{ #category : #accessing }
ShadowCastExampleMap >> mapAt: pos [
	^ map at: pos
]

{ #category : #accessing }
ShadowCastExampleMap >> minMaxValues: pos [
	pos x < minX
		ifTrue: [ minX := pos x ].
	pos y < minY
		ifTrue: [ minY := pos y ].
	pos x > maxX
		ifTrue: [ maxX := pos x ].
	pos y > maxY
		ifTrue: [ maxY := pos y ]
]

{ #category : #accessing }
ShadowCastExampleMap >> origin: pos [
	origin := pos
]

{ #category : #accessing }
ShadowCastExampleMap >> reset [
	visibleArea := Dictionary new.
]

{ #category : #accessing }
ShadowCastExampleMap >> visibleArea [
	^ visibleArea
]
