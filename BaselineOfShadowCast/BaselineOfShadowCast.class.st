Class {
	#name : #BaselineOfShadowCast,
	#superclass : #BaselineOf,
	#category : #BaselineOfShadowCast
}

{ #category : #baselines }
BaselineOfShadowCast >> baseline: spec [

	<baseline>
	spec for: #common do: [ spec package: 'Shadowcast-Core-Base' ]
]

{ #category : #baselines }
BaselineOfShadowCast >> projectClass [
	^ MetacelloCypressBaselineProject
]
