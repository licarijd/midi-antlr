grammar MIDee;

@header {
package cas.cs4tb3.parser;

import cas.cs4tb3.MIDIHelper;
}

@members {
private MIDIHelper midi = new MIDIHelper();

double time;
int currentInstrument = 0;
int currentTempo = 120;

}

//Start rule
program
    :   (instrumentBlock
    	)* EOF

    	{
    		midi.saveSequence();
    	}
    ;

scopeHeader
    :   INSTRUMENT 
    	( '@'
    	NUMBER
    	)?

    	this.instrumentID = midi.getInstrumentId($instrumentvalue.val);
    ;

instrumentBlock
    :   scopeHeader 
    	'{'
    	( playStatement
    	| waitStatement
    	)*
    	'}'
    ;

playStatement
    :   'play'
    	note
    	( ','
    	note
    	)*
    	'for'
    	duration
    	';'
    ;

waitStatement
    :   'wait'
    	'for'
    	duration
    	';'
    ;

duration
    :   NUMBER
    	| FLOATING_NUMBER
    ;

note
    :   NOTENAME
    	( '#'
    	| '_'
    	) ?
    	NUMBER
    ;

NOTENAME : [a-g];
NUMBER: ([0-9]|'10');
FLOATING_NUMBER: '0.'[0-9]*;
INSTRUMENT : [a-zA-Z]+;

/* We're going to ignore all white space characters */
WS 
