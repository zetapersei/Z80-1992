  TITLE "Z80 1992"

;*************************
;LABEL:MNEMON.
; EQU DIRETTIVE

CR   EQU    0DH
LF   EQU    0AH
DC1  EQU    011H
DC2  EQU    012H
DC3  EQU    013H
DC4  EQU    014H
SOH  EQU    01H
STX  EQU    02H
ETX  EQU    03H
EOT  EQU    04H
ENQ  EQU    05H
ACK  EQU    06H

 ORG    0
       DI
       LD SP,65535
;------------------------------
;SIO INIT
;------------------------------
         section code

INISIO:  LD A,24
         OUT(2),A
         LD A,20
         OUT(2),A
         LD A,196
         OUT(2),A
         LD A,3
         OUT(2),A
         LD A,225
         OUT(2),A
         LD A,5
         OUT(2),A
         LD A,232
         OUT(2),A
         LD A,17
         OUT(2),A
         LD A,0
         OUT(2),A

;-------------------------------
; PIO INIT
;-------------------------------

         LD A,207
         OUT(6),A
         LD A,7
         OUT(6),A
         LD A,207
         OUT(7),A
         LD A,0
         OUT(7),A
;------------------------------
INGSIO:  IN A,(2)
         BIT 0,A
         JP NZ,RXLOOP

PIOLOP:  IN A,(4)
         BIT 0,A
         JP NZ,STOR1
         BIT 1,A
         JP NZ,STOR2
         BIT 2,A
         JP NZ,STOR3
         JP INGSIO
STOR1:   LD HL,MSG
         LD A,1
         OUT(5),A
         LD B,3
         CALL DELAY
         LD A,0
         OUT(5),A
         CALL RTS1
STOR2:   LD HL,MSG1
         LD A,2
         OUT(5),A
         LD B,3
         CALL DELAY
         LD A,0
         OUT(5),A
         CALL RTS1
STOR3:   LD HL,MSG2
         LD A,4
         OUT(5),A
         LD B,3
         CALL DELAY
         LD A,0
         OUT(5),A
         CALL RTS1
STOR4:   LD HL,MSG3
         LD A,7
         OUT(5),A
         LD B,3
         CALL DELAY
         LD A,0
         OUT(5),A
         CALL RTS1
STOR5:   LD HL,MSG4
         CALL RTS1
RTS1:    LD A,5
         OUT(2),A
         LD A,234
         OUT(2),A
INSIO:   LD A,(HL)
         CP 0
         JP NZ,LOOP2
RTS0:    LD A,5
         OUT(2),A
         LD A,232
         OUT(2),A
         LD B,5
         CALL DELAY
         JP INGSIO
LOOP2:   OUT(0),A
         INC HL
LOOP1:   IN A,(2)
         BIT 2,A
         JP NZ,INSIO
         NOP
         NOP
         NOP
         NOP
         JP LOOP1
         RET
DELAY:   LD C,255
RAT:     LD D,255
RUT:     DEC D
         JP NZ,RUT
         DEC C
         JP NZ,RAT
         DEC B
         JP NZ,DELAY
         RET

         section data

MSG      DB    "              MAIN  MENU'      ",CR,LF
MSGV     DB    "---------------------------------",CR,LF
MSGA     DB    "OUT ACTIVATION  N.1 -----> 1",CR,LF
MSGB     DB    "OUT ACTIVATION N.2 -----> 2",CR,LF
MSGC     DB    "OUT ACTIVATION N.3 -----> 3",CR,LF
MSGD     DB    "HARDWARE CONFIGURATION ----> 4",CR,LF
MSGE     DB    "OUT                  ---->",CR,LF
MSGF     DB    "---------------------------------",CR,LF,0
MSG1     DB    "OUT N.1 ACTIVATED,COMMAND ACK",CR,LF,0
MSG2     DB    "OUT N.2 ACTIVATED,COMMAND ACK",CR,LF,0
MSG3     DB    "OUT N.3 ACTIVATED,COMMAND ACK",CR,LF,0
MSG4     DB    "************   TEST MENU'   ************",CR,LF
MSG4A    DB    "--------------------------------------------",CR,LF
MSG4B    DB    "------> 1  OUTPUTS RECONFIGURATION",CR,LF
MSG4C    DB    "------> 2  MESSAGES CUSTOMIZATION",CR,LF
MSG4D    DB    "------> 3  INPUTS MATCHING",CR,LF
MSG4E    DB    "------> 4  OUTPUTS MATCHING",CR,LF
MSG4F    DB    "------> 5  TIMINGS",CR,LF
MSG4G    DB    "------> 6  COSTANT",CR,LF
MSG4H    DB    "------> 7  EXIT MENU'",CR,LF
MSG4I    DB    "********************************************",CR,LF,0

;------------------------------------------------------------
         section code

RXLOOP:  IN A,(0)
         CP DC1     ;CAR DC1
         JP Z,STOR1
         CP 031H    ;CAR 1
         JP Z,STOR2
         CP 032H    ;CAR 2
         JP Z,STOR3
         CP 033H    ;CAR 3
         JP Z,STOR4
         CP 047H      ;CAR.G
         JP NZ,INGSIO
         CALL LOPIN
         CP 04FH      ;CAR.O
         JP NZ,INGSIO
         CALL LOPIN
         CP 054H      ;CAR.T
         JP NZ,INGSIO
         CALL LOPIN
         CP 04FH      ;CAR.O
         JP NZ,INGSIO
         JP STOR5
LOPIN:   IN A,(2)
         BIT 0,A
         JP Z,LOPIN
         IN A,(0)
         RET
         END
