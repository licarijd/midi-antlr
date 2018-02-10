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
private String instrumentID = "";
private int number = 0;
private long totalTime = 0;

 private int convertToMidiNote(String chord) {
            if (chord == null)
                throw new NullPointerException("Note is empty!");

            // Multiplies last chord number value by 12 (pattern followed from online chart)
            int midiNote = Integer.parseInt(chord.replaceAll("[^0-9]", "")) * 12;

            switch (chord.charAt(0)) {
                 case 'c':
                    midiNote += 0;
                    break;
                 case 'd':
                    midiNote += 2;
                    break;
                 case 'e':
                    midiNote += + 4;
                    break;
                 case 'f':
                    midiNote += 5;
                    break;
                 case 'g':
                    midiNote += + 7;
                    break;
                 case 'a':
                    midiNote += 9;
                    break;
                 case 'b':
                    midiNote += 11;
                    break;
            }

            // Increments or decrements depending on sharp or flat
            if (Character.toString(chord.charAt(1)).equals("+")) {
                 midiNote += 1;
            } else if (Character.toString(chord.charAt(1)).equals("_")) {
                 midiNote -= 1;
            }

            // Error handling
            if (midiNote < 0) {
                midiNote = 0;
                System.err.println("Warning invalid note -- rounding to 0");
            } else if (midiNote > 127) {
                midiNote = 127;
                System.err.println("Warning invalid note -- rounding to 127");
            }

           return midiNote;
        }
}

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

    	{
            this.instrumentID = midi.getInstrumentId($INSTRUMENT.val);
            if ($NUMBER.ctx != null)
                this.number = midi.getInstrumentId($NUMBER.val);


            this.midi.setInstrument(this.instrumentID, this.totalTime);
            this.midi.setTempo(this.number, this.totalTime);

        }
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
