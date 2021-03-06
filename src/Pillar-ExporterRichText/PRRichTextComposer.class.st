"
***
I am a visitor that produces rich text (class Text) based on a pillar document model.
I am implemented using a canvas/brush pattern.


!!Note The composer should be improved to render better and in nicer ways elements. 

#### Advanced 
For the LaTeX rendering, internet connexion is required. 
You can also turn it off/on doing

```
PRRichTextComposer putOffLine
```

#### Known limits
Monospaced text (e.g., `Point`, `Point class`,  `Point>>#setX:setY:`, or `#'Pillar-ExporterPillar'`) uses TextAction to trigger browser opening on the corresponding element. It would be better to use a TextLink because the styler is aware of them. 


"
Class {
	#name : #PRRichTextComposer,
	#superclass : #PRVisitor,
	#instVars : [
		'canvas',
		'monospaceBackgroundColor',
		'superscriptColor',
		'subscriptColor',
		'annotatedParagraphColor',
		'annotatedParagraphAnnotationColor',
		'annotatedParagraphAlignment'
	],
	#classVars : [
		'OffLine'
	],
	#category : #'Pillar-ExporterRichText-Core'
}

{ #category : #private }
PRRichTextComposer class >> browse: urlString [
	"I am a url on the form: browse://Class or browse://Class/method"

	| parts classPart theClass method |
	parts := urlString substrings: '/'. 
	classPart := parts at: 2.
	"handle class side also"
	theClass := (classPart endsWith: ' class')
		ifFalse: [ classPart asClass ]
		ifTrue: [ (classPart withoutSuffix: ' class') asClass class ].
	method := parts size > 2
		ifTrue: [ (parts at: 3) asSymbol ]
		ifFalse: [ nil ].
	method
		ifNil: [ theClass browse ]
		ifNotNil: [ (theClass >> method) browse ]
]

{ #category : #private }
PRRichTextComposer class >> bulletForLevel: level [
	| kind |
	kind := level % 2.
	kind = 0
		ifTrue: [ ^ $• asText ].
	kind = 1
		ifTrue: [ ^ $- asText ]
]

{ #category : #stylers }
PRRichTextComposer class >> codeStylerFor: aString [
	<codeblockStylerFor: 'Smalltalk'>
	
	^SHRBTextStyler new 
		isForWorkspace: true; 
		styledTextFor: aString asText
]

{ #category : #private }
PRRichTextComposer class >> counterFor: counter atLevel: level [
	| kind |
	kind := level % 3.
	kind = 0
		ifTrue: [ ^ counter asString asText , '.' ].
	kind = 1
		ifTrue: [ ^ ($a asInteger + (counter - 1)) asCharacter asText , ')' ].
	kind = 2
		ifTrue: [ ^ ($A asInteger + (counter - 1)) asCharacter asText , ')' ]
]

{ #category : #stylers }
PRRichTextComposer class >> defaultStyler: aString [
	<codeblockStylerFor:'default'>
	
	"By default, render it as code"
	^self codeStylerFor: aString
]

{ #category : #examples }
PRRichTextComposer class >> example1 [
	<example>
	(self asText:
					'!!!First section
and this is just ""first"" line 
# Line 1 More here More here ==More here More here== More here More here More here More here More here More here
#- Kasper tries the strange thing Kasper tries the strange thingKasper tries the strange thingKasper tries the strange thingKasper tries the strange thingKasper tries the strange thingKasper tries the strange thing
#- And one more --silly-- thingie
# Line 2
#-  Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla
#-- Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla
# Line 3') inspect
]

{ #category : #examples }
PRRichTextComposer class >> example10 [
	<example>
	(self asText:
					'
[[[language=PharoMethod
1 + 2 * 3
]]]
') inspect
]

{ #category : #examples }
PRRichTextComposer class >> example2 [
	<example>
	(self asText:
					'!!!Description lists
this is just ""first"" line
# Here is frist enumaration
#;blue
#:color of the sky
#:and my true love''s eyes
#;red
#:color of the fire') inspect
]

{ #category : #examples }
PRRichTextComposer class >> example3 [
	<example>
	(self asText:
					'!!!Code sections
this is just ""first"" line
[[[
Metacello new
   baseline: ''PillarRichTextExporter'';
   repository: ''github://kasperosterbye/PillarRichTextRender'';
   load.
]]]') inspect
]

{ #category : #examples }
PRRichTextComposer class >> example4 [
	<example>
	(self asText:
					'!!!Annotations
this is just ""first"" line
@@todo remember to do annotations
and this is the second line') inspect
]

{ #category : #examples }
PRRichTextComposer class >> example5 [
	<example>
	(self asText:
					'!!!Links
this is just ""first"" line

*Pharo>http://pharo.org/*

*String>browse://String*

*String»trim>browse://String/trim*

and this is the second line') inspect
]

{ #category : #examples }
PRRichTextComposer class >> example6 [
	<example>
	(self asText:
					'!!!Figures
this is just ""first"" line

+Pharologo>https://files.pharo.org/media/logo/logo.png+

and this is the second line') inspect
]

{ #category : #examples }
PRRichTextComposer class >> example7 [
	<example>
	(self asText:
					'!First section

# ==Point== should open a class browser on Point.
# ==Point class== should open a class browser on Point.
# ==Point >> setX:setY:== should open a browser on the correspoding method.
# ==Pillar\-ExporterRichText== should open a browser on the package.
') inspect
]

{ #category : #examples }
PRRichTextComposer class >> example8 [
	<example>
	(self asText:
					'
[[[language=PharoExpression
1 + 2 * 3  
]]]
') inspect
]

{ #category : #examples }
PRRichTextComposer class >> example9 [
	<example>
	(self asText:
					'
[[[language=PharoMethod
foo: arg
	^ arg + self
]]]
') inspect
]

{ #category : #examples }
PRRichTextComposer class >> exampleLatexMath [
	<example>
	(PRRichTextComposer  asText:
'!!!Latex mathematics 
It is possible to render latex math:
[[[language=latexMath
V_i = C_0 - C_3
\frac{C_1\cos(\theta_i+C_3)}{C_4+C_1\cos(\theta_i+C_2)}
]]]
Cool eh?
') inspect
]

{ #category : #stylers }
PRRichTextComposer class >> expressionStylerFor: aString [
	<codeblockStylerFor: 'PharoExpression'>
	
	^SHRBTextStyler new 
		isForWorkspace: true; 
		styledTextFor: aString asText
]

{ #category : #private }
PRRichTextComposer class >> headerLevelFont: level [
	"I return a font annotation to be used with Attributes"

	"StrikeFont actualFamilyNames an OrderedCollection(#'Bitmap DejaVu Sans' #'Bitmap Source Code Pro' #'Bitmap Source Sans Pro')"

	| fontSizes |
	fontSizes := #(22 20 18 16 14 14).
	^ TextFontReference
		toFont:
			(StrikeFont
				familyName: 'Bitmap Source Sans Pro'
				pointSize: (fontSizes at: level))
]

{ #category : #'class initialization' }
PRRichTextComposer class >> initialize [ 
	OffLine := false
]

{ #category : #stylers }
PRRichTextComposer class >> languageStylerFor: aLanguage [
	| stylers |
	stylers := Dictionary
		newFromAssociations: ((PragmaCollector
						filter: [ :prg | prg selector = 'codeblockStylerFor:' ]) reset
						collected collect: [ :p | p arguments first -> p method ]).
	^ stylers
		at: aLanguage
		ifAbsent: [ self languageStylerFor: 'default' ]
]

{ #category : #stylers }
PRRichTextComposer class >> methodStylerFor: aString [
	<codeblockStylerFor:'PharoMethod'>
	
	"when we use a pharo method for an expression the styler breaks for method pattern. So it should be fixed in the future but for now we make sure that at least it does not breaks."
	^[ SHRBTextStyler new 
		isForWorkspace: false; 
		styledTextFor: aString asText ] on: SubscriptOutOfBounds do: [ aString asText ]
]

{ #category : #'class initialization' }
PRRichTextComposer class >> putOffline [

	OffLine := true
]

{ #category : #'class initialization' }
PRRichTextComposer class >> putOnline [

	OffLine := false
]

{ #category : #stylers }
PRRichTextComposer class >> style: aString asLanguage: aLanguage [
	"render aString according to the styler named aLanguage"
	
	| styler |
	styler := self languageStylerFor: aLanguage.
	^ styler
		valueWithReceiver: styler methodClass soleInstance 
		arguments: (Array with: aString)
]

{ #category : #stylers }
PRRichTextComposer class >> textStyler: aString [
	<codeblockStylerFor:'text'>
	
	^aString asText
]

{ #category : #accessing }
PRRichTextComposer >> annotatedParagrapAlignment [
	^ annotatedParagraphAlignment 
]

{ #category : #accessing }
PRRichTextComposer >> annotatedParagraphAnnotationColor [
	^ annotatedParagraphAnnotationColor 
]

{ #category : #accessing }
PRRichTextComposer >> annotatedParagraphAnnotationColor: aColor [
	annotatedParagraphAnnotationColor := aColor
]

{ #category : #accessing }
PRRichTextComposer >> annotatedParagraphColor [
	^ annotatedParagraphColor 
]

{ #category : #accessing }
PRRichTextComposer >> annotatedParagraphColor: aColor [
	annotatedParagraphColor := aColor
]

{ #category : #initialization }
PRRichTextComposer >> defaultAnnotatedParagraphColor [
	^ TextColor blue
]

{ #category : #initialization }
PRRichTextComposer >> defaultSuperscriptColor [
	^ TextColor blue
]

{ #category : #initialization }
PRRichTextComposer >> initialize [
	super initialize.
	monospaceBackgroundColor := self theme settings windowColor.
	superscriptColor := self defaultSuperscriptColor.
	subscriptColor := TextColor red.
	annotatedParagraphColor := self defaultAnnotatedParagraphColor.
	annotatedParagraphAnnotationColor := TextEmphasis bold.
	annotatedParagraphAlignment := TextAlignment leftFlush
]

{ #category : #accessing }
PRRichTextComposer >> monospaceBackgroundColor [

	^ monospaceBackgroundColor
]

{ #category : #accessing }
PRRichTextComposer >> monospaceBackgroundColor: aColor [

	monospaceBackgroundColor := aColor
]

{ #category : #visiting }
PRRichTextComposer >> start: aDocument [
	canvas := PRRichTextCanvas new.
	self visit: aDocument.
	^ canvas contents
]

{ #category : #accessing }
PRRichTextComposer >> subscriptColor [
	^ subscriptColor 
]

{ #category : #accessing }
PRRichTextComposer >> subscriptColor: anObject [
	subscriptColor := anObject
]

{ #category : #accessing }
PRRichTextComposer >> superscriptColor [
	^ superscriptColor 
]

{ #category : #accessing }
PRRichTextComposer >> superscriptColor: anObject [
	superscriptColor := anObject
]

{ #category : #initialization }
PRRichTextComposer >> theme [

	^  Smalltalk ui theme
]

{ #category : #visiting }
PRRichTextComposer >> visit: anObject [
	anObject accept: self
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitAnchor: anObject [
	canvas << '>>> Anchors not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitAnnotatedParagraph: anAnnotatedParagraph [
	
	canvas newLineIfNotAlready.
	canvas newLine.
	canvas
		includeAttribute: self annotatedParagrapAlignment
		in: [ 
			canvas
				includeAttribute: self annotatedParagraphAnnotationColor
				in: [ canvas << anAnnotatedParagraph annotation capitalized asText ].
			canvas
				includeAttribute: self annotatedParagrapAlignment
				in: [ canvas
						includeAttribute: self annotatedParagraphColor
						in: [ self visitParagraph: anAnnotatedParagraph ] ] ].
	canvas newLine.
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitAnnotation: anAnnotation [
	canvas << '>>> Annotations not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitBeginEnvironmentAnnotation: aBeginEnvironmentAnnotation [

	canvas << '>>> Environments not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting -  format' }
PRRichTextComposer >> visitBoldFormat: anObject [
	canvas 
		includeAttribute: TextEmphasis bold 
		in: [self visitFormat: anObject]
	
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitCitation: aCitation [
	canvas << '>>> Citations not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitCitationAnnotation: aCitation [
	canvas << '>>> Citations not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitCodeblock: aCodeBlock [
	canvas newLineIfNotAlready.
	canvas newLine.
	canvas
		indentIn: [  
			canvas
				indentIn: [ 
					canvas << (self class  
						style: aCodeBlock text 
						asLanguage: aCodeBlock language originalName)
			] ].
	canvas newLine.

]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitColumn: aColumn [
	canvas << '>>> Columns not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitColumnAnnotation: aColumnAnnotation [
	canvas << '>>> Columns not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitColumns: aColumns [
	canvas << '>>> Columns not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitColumnsAnnotation: aColumnsAnnotation [
	canvas << '>>> Columns not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - list' }
PRRichTextComposer >> visitDataItem: anItem [
	canvas newLineIfNotAlready.
	self visitDocumentGroup: anItem
]

{ #category : #'visiting - list' }
PRRichTextComposer >> visitDefinitionList: anObject [
	canvas indentIn: [ self visitUnorderedList: anObject ]
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitDocListAnnotation: aPRDocListAnnotation [
	canvas << '>>> DocLists not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitEmptyParagraph: anObject [
	canvas newLine
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitEndColumnsAnnotation: aEndColumnsAnnotation [
	canvas << '>>> Columns not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - unsupported' }
PRRichTextComposer >> visitEndEnvironmentAnnotation: aEndEnvironmentAnnotation [
	canvas << '>>> Environments not supported in RichText Pillar <<<' asText
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitEnvironment: anObject [
	self flag: #fixme.
	"What is this textBlock idea? Clean!"
	anObject name = 'textBlock'
		ifTrue:[
			canvas indentIn: [  
				canvas 
					includeAttribute: TextEmphasis italic  
					in: [self visitFormat: anObject]] ]
		ifFalse: [canvas << ('>>> Environment ' , anObject name , 
						'is not supported in RichText Pillar <<<') asText]
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitExternalLink: aLink [
	| attribute target url |
	target := aLink reference.
	url := target asUrl.
	attribute := nil.
	(#(http https) includes: url scheme )
		ifTrue: [ attribute := "PRExternalLinkTextAction url: target"
			 	TextAction new actOnClickBlock: [WebBrowser openOn: target]].
	url scheme = #browse
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ self class browse: target ] ].
	attribute
		ifNotNil:
			[ canvas includeAttribute: attribute in: [ self visitLink: aLink ] ]
		ifNil: [ self visitLink: aLink ]
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitFigure: aFigure [
	| serverUrl anchoredImage |
	serverUrl := aFigure reference.
	"Try to read a png file (only one supported right now), else use alt text"
	[anchoredImage := (String value: 1) asText
		addAttribute: (TextAnchor new anchoredMorph: (ZnEasy getPng: serverUrl)).
		canvas << anchoredImage ] 
		on: Exception 
		do: [self visitAll: aFigure children].
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitHeader: aHeader [

	canvas newLineIfNotAlready.
	canvas
		includeAttribute: (self class headerLevelFont: aHeader level)
		in: [ self visitDocumentGroup: aHeader ].
	canvas newLine
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitHorizontalRule: anHorizontalLine [

	canvas includeAttribute: TextEmphasis underlined in: [ canvas << ('     ' repeat: 20) asText ].
	canvas newLine.	
]

{ #category : #'visiting -  format' }
PRRichTextComposer >> visitItalicFormat: anObject [
	canvas includeAttribute: TextEmphasis italic in: [ self visitFormat: anObject ]
]

{ #category : #'visiting - list' }
PRRichTextComposer >> visitListItem: anItem [
	| bullet |
	"I stored the counter and bullet type in `visitOrderedList` and `visitUnorderedList`"
	bullet := (anItem propertyAt: #kind) = #ordered
		ifTrue: [ (anItem propertyAt: #counter) asString asText , String tab ]
		ifFalse: [ (anItem propertyAt: #bullet) asText , String tab ].
	bullet addAttribute: (TextIndent tabs: canvas nesting - 1).
	canvas newLineIfNotAlready.
	canvas << bullet.
	self visitDocumentGroup: anItem.
	"canvas newLineIfNotAlready."
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitMathInTextAnnotation: aPRMathInTextAnnotation [ 
	"we could plug some math rendering for Polymath following the implementation of Kasper.
	See PRCodeblockStylerExtensions"
	OffLine 
		ifTrue: [ canvas << '$', aPRMathInTextAnnotation text, '$' ]
		ifFalse: [ canvas << (PRCodeblockStylerExtensions latexMathStylerFor: aPRMathInTextAnnotation text)]
]

{ #category : #'visiting -  format' }
PRRichTextComposer >> visitMonospaceFormat: anObject [
	"Notice - I add a highlight to the backgorund rather than mono-spaced."
	| backgroundColor sem |
	backgroundColor := self monospaceBackgroundColor.
	
	self flag: #fixMe.
	"Right now we stupidly emit TextAction but we should emit TextClassLink and revisit them."
	canvas 
		includeAttribute: (TextBackgroundColor color: backgroundColor) 
		in: [ 
			sem := PRSemanticAction from: anObject text.
			sem hasEntity 
				ifTrue: [ canvas 
								includeAttribute: (TextAction new actOnClickBlock: [ sem entity browse ]) in: [self visitFormat: anObject ] ]
				ifFalse: [ self visitFormat: anObject]].  
]

{ #category : #'visiting - list' }
PRRichTextComposer >> visitOrderedList: anObject [
	| counter |
	canvas indentIn: [counter := 1.
		anObject children
			do: [ :item | 
				item propertyAt: #kind put: #ordered.
				item
					propertyAt: #counter
					put: (self class counterFor: counter atLevel: canvas nesting - 1).
				counter := counter + 1 ].
		super visitOrderedList: anObject ].
	canvas newLine
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitParagraph: anObject [
	"canvas newLineIfNotAlready."
	canvas newLine.
	super visitParagraph: anObject.
	canvas newLine.
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitPreformatted: aPreformatted [

	canvas newLineIfNotAlready.
	canvas newLine.
	canvas
		indentIn: [ 
			aPreformatted children do: [ :each | 
				canvas << (self class textStyler: each text).
				canvas newLine ].
			"This is not really correct since the text should be interpreted."
			"canvas << (PRRichTextCodeblockStyler textStyler: aPreformatted text)"].
		
	canvas newLine
]

{ #category : #'visiting -  format' }
PRRichTextComposer >> visitStrikethroughFormat: anObject [
	canvas includeAttribute: TextEmphasis struckOut in: [ self visitFormat: anObject ]
]

{ #category : #'visiting -  format' }
PRRichTextComposer >> visitSubscriptFormat: anObject [
	canvas
		includeAttribute: self subscriptColor
		in: [ self visitFormat: anObject ]
]

{ #category : #'visiting -  format' }
PRRichTextComposer >> visitSuperscriptFormat: anObject [
	canvas
		includeAttribute: self superscriptColor
		in: [ self visitFormat: anObject ]
]

{ #category : #'visiting - list' }
PRRichTextComposer >> visitTermItem: anItem [
	canvas newLineIfNotAlready.
	canvas
		includeAttribute: (TextIndent tabs: canvas nesting - 1)
		in: [ canvas
				includeAttribute: TextEmphasis bold
				in: [ self visitDocumentGroup: anItem ] ]
]

{ #category : #'visiting - document' }
PRRichTextComposer >> visitText: anObject [
	canvas << anObject text asText
		" - should not be necessary addAttribute: (TextIndent tabs: canvas nesting)"
]

{ #category : #'visiting -  format' }
PRRichTextComposer >> visitUnderlineFormat: anObject [
	canvas includeAttribute: TextEmphasis underlined in: [ self visitFormat: anObject ]
]

{ #category : #'visiting - list' }
PRRichTextComposer >> visitUnorderedList: anObject [
	canvas
		indentIn: [ anObject children
				do: [ :item | 
					item propertyAt: #kind put: #unordered.
					item
						propertyAt: #bullet
						put: (self class bulletForLevel: canvas nesting - 1) ].
			super visitUnorderedList: anObject ].
	canvas newLine
]
