Extension { #name : #CmTWithBasicNameAndDescription }

{ #category : #'*Commander2-Deprecations' }
CmTWithBasicNameAndDescription >> basicDescription [
	self deprecated: 'Use #description instead.' transformWith: '`@receiver basicDescription' -> '`@receiver description'.
	^ self description
]

{ #category : #'*Commander2-Deprecations' }
CmTWithBasicNameAndDescription >> basicDescription: anObject [
	self deprecated: 'Use #description: instead.' transformWith: '`@receiver basicDescription: `@arg' -> '`@receiver description: `@arg'.
	^ self description: anObject
]

{ #category : #'*Commander2-Deprecations' }
CmTWithBasicNameAndDescription >> basicName [
	self deprecated: 'Use #name instead.' transformWith: '`@receiver basicName' -> '`@receiver name'.
	^ self name
]

{ #category : #'*Commander2-Deprecations' }
CmTWithBasicNameAndDescription >> basicName: anObject [
	self deprecated: 'Use #name: instead.' transformWith: '`@receiver basicName: `@arg' -> '`@receiver name: `@arg'.
	^ self name: anObject
]
