Class {
	#name : #BaselineOFShadowCast,
	#superclass : #Object,
	#category : #BaselineOfShadowCast
}

{ #category : #accessing }
BaselineOFShadowCast >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'ShadowCast-Core-Base' ]
]

{ #category : #accessing }
BaselineOFShadowCast >> projectClass [
	^ MetacelloCypressBaselineProject
]
