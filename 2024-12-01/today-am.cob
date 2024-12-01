IDENTIFICATION DIVISION.
PROGRAM-ID. DAY01-PUZZLE1.
AUTHOR. Sebastian Ritter <bastie@users.noreply.github.com>.

ENVIRONMENT DIVISION.
  INPUT-OUTPUT SECTION.
    FILE-CONTROL.
      SELECT PUZZLE-FILE 
             ASSIGN TO 'puzzle.am'
             ORGANIZATION IS LINE SEQUENTIAL
      .

DATA DIVISION.
FILE SECTION.
FD PUZZLE-FILE.
  01 PUZZLE-LINE    PIC X(13).

WORKING-STORAGE SECTION.
    *> --- Dateisteuerung ---
    77 FILE-END PIC X VALUE 'Y'.
    01 FILE-END-FLAG PIC X VALUE LOW-VALUE.
      88 FILE-END-TRUE VALUE 'Y'.
    *> --- Businessdaten ---
    01 LOCATION-ID.
      05 X-POSITION         PIC 9(5).
      05 FILLER             PIC X(3).
      05 Y-POSITION         PIC 9(5).
      
    01 ALL-X                PIC 9(5)   OCCURS 1000.
    01 ALL-Y                PIC 9(5)   OCCURS 1000.

    77 TABLE-INDEX          PIC 9(4).

    01 DIFFERENT-BETWEEN-X-AND-Y   PIC 9(5)  OCCURS 1000.
    77 SUM-OF-ALL-DIFFERENTS       PIC 9999999.

*> =============================================== <*
   PROCEDURE DIVISION.
*> =============================================== <*
    MASTER SECTION.
    
      INIT. *> PARAGRAPH -------------------------
        OPEN INPUT PUZZLE-FILE
        MOVE ZERO TO TABLE-INDEX
      . *> END PARAGRAPH
    
      MAIN. *> PARAGRAPH -------------------------
        PERFORM READ-LOOP UNTIL FILE-END-TRUE

        SORT ALL-X ASCENDING KEY ALL-X
        SORT ALL-Y ASCENDING KEY ALL-Y 

        MOVE 0 TO TABLE-INDEX
        PERFORM UNTIL TABLE-INDEX GREATER THAN 1000
          ADD 1 TO TABLE-INDEX

          COMPUTE DIFFERENT-BETWEEN-X-AND-Y (TABLE-INDEX) =
                  ALL-X (TABLE-INDEX) - ALL-Y (TABLE-INDEX)
          ADD DIFFERENT-BETWEEN-X-AND-Y (TABLE-INDEX) TO SUM-OF-ALL-DIFFERENTS

        END-PERFORM

        DISPLAY "RESULT = " SUM-OF-ALL-DIFFERENTS
      . *> END PARAGRAPH

      DEINIT. *> PARAGRAPH -----------------------
        CLOSE PUZZLE-FILE

      . *> END PARAGRAPH
    
    GOBACK
    STOP RUN
    . *>END SECTION

*> ----------------------------------------------- <*
  READ-LOOP SECTION.
    READ PUZZLE-FILE
      AT END 
        MOVE FILE-END TO FILE-END-FLAG
        MOVE 0 TO TABLE-INDEX
      NOT AT END
        MOVE PUZZLE-LINE TO LOCATION-ID
        PERFORM HANDLE-LINE
  . *>END SECTION

*> ----------------------------------------------- <*
  HANDLE-LINE SECTION.
    ADD 1 TO TABLE-INDEX
    MOVE X-POSITION TO ALL-X (TABLE-INDEX)
    MOVE Y-POSITION TO ALL-Y (TABLE-INDEX)
  . *>END SECTION

*> === EOF ======================================= <*
