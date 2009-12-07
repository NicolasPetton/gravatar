Object subclass: Gravatar [
    | emailAddress options |


    <category: 'Gravatar'>
    <comment: nil>

    Gravatar class [
	
	for: aString [
	    <category: 'instance creation'>
	    ^self new 
		emailAddress: aString;
		yourself
	]
    
	hostname [
	    <category: 'accessing'>
	    ^'http://www.gravatar.com/avatar/'
	]
    ]

    emailAddress [
	<category: 'accessing'>
	^emailAddress
    ]

    emailAddress: aString [
	<category: 'accessing'>
	emailAddress := aString
    ]

    hostname [
	<category: 'accessing'>
	^self class hostname
    ]

    gravatarId [
	<category: 'accessing'>
	^MD5 hexDigestOf: self emailAddress
    ]

    url [
	<category: 'accessing'>
	| stream |
	stream := WriteStream on: ''.
	stream 
	    nextPutAll: self hostname;
	    nextPutAll: self gravatarId.
	self options keysAndValuesDo: [:key :value |
	    stream 
		nextPut: $?;
		nextPutAll: key;
		nextPut: $=;
		nextPutAll: (self encode: value)].
	^stream contents
    ]

    contents [
	<category: 'accessing'>
	^(FileStream open: self url mode: FileStream read) contents
    ]

    options [
	<category: 'accessing options'>
	^options ifNil: [options := Dictionary new]
    ]

    size [
	<category: 'accessing options'>
	^self options at: #size ifAbsent: [nil]
    ]

    size: anInteger [
	<category: 'accessing options'>
	self options at: #size put: anInteger printString
    ]

    rating [
	<category: 'accessing options'>
	^self options at: #rating ifAbsent: [nil]
    ]

    rating: aString [
	<category: 'accessing options'>
	self options at: #rating put: aString
    ]

    default [
	<category: 'accessing options'>
	^self options at: #default ifAbsent: [nil]
    ]

    default: aString [
	<category: 'accessing options'>
	self options at: #default put: aString
    ]

    encode: aString [
	<category: 'private'>
	^String streamContents: [:stream |
	    aString do: [:char |
		self encodeChar: char on: stream]]
    ]	

    encodeChar: aCharacter on: aStream [
	<category: 'private'>
	| value |
	('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_."' includes: aCharacter)
	    ifTrue: [^aStream nextPut: aCharacter].
	value := aCharacter asInteger.
	aStream nextPut: $%.
	aStream nextPutAll: ((value radix: 16) copyFrom: 4)
    ]

]
