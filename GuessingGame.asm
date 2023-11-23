; Chloe Duncan
; 25 February 2022
; TCSS 371, Professor Fowler
;
; GuessingGame Assembly Language Program
; Simulates guessing game. Stores #4 and asks user
; to guess a number 0-9. Handles invalid input and
; gives user hints. Assumes user gets number right
; in 9 guesses.

                .ORIG      x3000
                LD         R4, STOREDVAL           ; load stored value in R4
                AND        R5, R5, #0              ; num of guesses counter (R5)
                AND        R0, R0, #0              ; clear R0
                LEA        R0, PROMPT              ; load start address of PROMPT in R0
                PUTS                               ; display PROMPT
                GETC                               ; read char into R0
                OUT                                ; write char from R0 to monitor
                AND        R6, R6, #0              ; clear R6
                ADD        R6, R6, R0              ; copy user input to R6
                AND        R0, R0, #0              ; clear R0
                BRnzp      CHECKNUM

;CHECK Input against R4
CHECKNUM        ADD        R5, R5, x0001           ; increment guess counter
	            AND        R2, R2, #0              ; clear R2
	            LD         R2, MAX                 ; ADD (R2 <- R2 + MAX) ; check if ASCII 0-9
	            NOT        R2, R2                  ; 2's comp of R2
	            ADD        R2, R2, #1              
        	    ADD        R2, R2, R6              ; subtract R6 from 34
	            BRp        INVALIDINPUT            ; if pos, invalid input
        	    AND        R2, R2, #0              ; clear R2
	            LD         R2, MIN                 ; add 48 to check if ASCII 0-9
    	        NOT        R2, R2              
	            ADD        R2, R2, #1              ; 2's complement
        	    ADD        R2, R2, R6              ; subtract R6 from 39
	            BRn        INVALIDINPUT            ; if neg, invalid input
        	    NOT        R6, R6              
        	    ADD        R6, R6, #1              ; 2's complement
        	    ADD        R6, R6, R4              ; Subtraction
        	    
        	    BRp        TOOSMALL                ; BR if pos to TOOSMALL
        	    BRn        TOOBIG                  ; BR if neg to TOOBIG
        	    BRz        WIN                     ; BR if zero to WIN

TOOSMALL    	AND        R0, R0, #0              ; clear R0
        	    LEA        R0, SMALLMSG            ; load start address of SMALLMSG in R0
        	    PUTS                               ; display SMALLMSG
        	    BRnzp      GUESSAGAIN              ; BR unconditionally to GUESSAGAIN

TOOBIG    	    AND        R0, R0, #0              ; clear R0
        	    LEA        R0, BIGMSG              ; load start address of BIGMSG in R0
        	    PUTS                               ; display BIGMSG
        	    BRnzp      GUESSAGAIN              ; BR unconditionally to GUESSAGAIN

GUESSAGAIN	    AND        R0, R0, #0              ; clear R0
	            LEA        R0, GUESSAGAINMSG       ; load start address of GUESSAGAINMSG in R0
	            PUTS                               ; display GUESSAGAINMSG
	            GETC                               ; read char into R0
	            OUT                                ; write char from R0 to monitor
	            AND        R6, R6, #0              ; clear R6
	            ADD        R6, R6, R0              ; ADD (R6 <- R6 + R0) ; copy input to R6
	            BRnzp      CHECKNUM                ; BR unconditionally to CHECKNUM

WIN     	    AND        R0, R0, #0              ; clear R0
                LEA        R0, CORRECTMSG          ; load start address of CORRECTMSG
	            PUTS                               ; display CORRECTMSG
	            AND        R0, R0, #0              ; clear R0
	            LD         R0, ZERO                ; load ASCII 0
            	ADD        R0, R0, R5              ; offset ASCII 0 with num of guesses
	            OUT                                ; write num of guesses to monitor
	            LEA        R0, CORRECTMSG2         ; load start address of CORRECTMSG2
	            PUTS                               ; display CORRECTMSG2
	            BRnzp      ENDGAME                 ; BR unconditionally to ENDGAME

INVALIDINPUT    LEA        R0, INVALIDMSG          ; load start address of INVALIDMSG
	            PUTS                               ; display INVALIDMSG
	            BRnzp      GUESSAGAIN              ; BR unconditionally to GUESSAGAIN
;
ENDGAME         HALT                               ; HALT x25
;
STOREDVAL      .FILL       x0034                   ; Stored value 4
PROMPT         .STRINGZ    "Guess a number: "      
SMALLMSG       .STRINGZ    "\nToo small.\n"            
BIGMSG         .STRINGZ    "\nToo big.\n"              
GUESSAGAINMSG  .STRINGZ    "Guess again: "         
CORRECTMSG     .STRINGZ    "\nCorrect! You took "  ; Win message part 1
CORRECTMSG2    .STRINGZ    " guesses."             ; Win message part 2
INVALIDMSG     .STRINGZ    "\nInvalid input.\n"        
ZERO           .fill       x30                     ; ASCII '0' ; used to offset number of guesses
MAX            .fill       #57                     ; Max input value to check ASCII between 0-9
MIN            .fill       #48                     ; Min input value to check ASCII between 0-9
;
               .END
;