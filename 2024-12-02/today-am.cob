IDENTIFICATION DIVISION.
PROGRAM-ID. DAY02-PUZZLE1.
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
  01 PUZZLE-LINE    PIC X(23).

WORKING-STORAGE SECTION.
    *> --- Dateisteuerung ---
    77 FILE-END PIC X VALUE 'Y'.
    01 FILE-END-FLAG PIC X VALUE LOW-VALUE.
      88 FILE-END-TRUE VALUE 'Y'.
    *> --- Businessdaten ---
    01 LEVELS.
      05 No-01         PIC 99.
      05 No-02         PIC 99.
      05 No-03         PIC 99.
      05 No-04         PIC 99.
      05 No-05         PIC 99.
      05 No-06         PIC 99.
      05 No-07         PIC 99.
      05 No-08         PIC 99.
      05 No-09         PIC 99.
    01 LEVEL-TABLE REDEFINES LEVELS PIC 99 OCCURS 9.

    77 DIRECTION-FLAG  PIC S9.
      88 DIRECTION-UNKNOW      VALUE ZERO.
      88 DIRECTION-ASCENDING   VALUE 1 THRU 9.
      88 DIRECTION-DECENDING   VALUE -9 THRU -1.   

    77 SUM-OF-CORRECT-LINES    PIC 9999999.

*> =============================================== <*
   PROCEDURE DIVISION.
*> =============================================== <*
  MASTER SECTION.
    
    OPEN INPUT PUZZLE-FILE
    
    PERFORM READ-LOOP UNTIL FILE-END-TRUE
   
    DISPLAY "RESULT = " SUM-OF-CORRECT-LINES
   
    CLOSE PUZZLE-FILE

    
    GOBACK
    STOP RUN
  . *>END SECTION

*> ----------------------------------------------- <*
  CHECK-LEVEL SECTION.
    MOVE ZERO TO DIRECTION-FLAG

    IF No-01 LESS THAN No-02 THEN
      MOVE 1 TO DIRECTION-FLAG
    ELSE
      MOVE -1 TO DIRECTION-FLAG
    END-IF

    
    EVALUATE TRUE
      *> ZERO means no value readed
      *> diff between two neighbors > ZERO and < 4(ASC), if decending > -4
      WHEN DIRECTION-ASCENDING
        IF     ( (No-09 = ZERO) OR (((No-09 - No-08) > ZERO) AND ((No-09 - No-08) < 4)) ) 
           AND ( (No-08 = ZERO) OR (((No-08 - No-07) > ZERO) AND ((No-08 - No-07) < 4)) )   
           AND ( (No-07 = ZERO) OR (((No-07 - No-06) > ZERO) AND ((No-07 - No-06) < 4)) )
           AND ( (No-06 = ZERO) OR (((No-06 - No-05) > ZERO) AND ((No-06 - No-05) < 4)) )
           AND ( (No-05 = ZERO) OR (((No-05 - No-04) > ZERO) AND ((No-05 - No-04) < 4)) )
           AND ( (No-04 = ZERO) OR (((No-04 - No-03) > ZERO) AND ((No-04 - No-03) < 4)) )
           AND ( (No-03 = ZERO) OR (((No-03 - No-02) > ZERO) AND ((No-03 - No-02) < 4)) )
           AND ( (No-02 = ZERO) OR (((No-02 - No-01) > ZERO) AND ((No-02 - No-01) < 4)) )
           THEN
          ADD 1 TO SUM-OF-CORRECT-LINES
        END-IF
      WHEN OTHER
        IF     ( (No-09 = ZERO) OR (((No-09 - No-08) < ZERO) AND ((No-09 - No-08) > -4)) )
           AND ( (No-08 = ZERO) OR (((No-08 - No-07) < ZERO) AND ((No-08 - No-07) > -4)) )
           AND ( (No-07 = ZERO) OR (((No-07 - No-06) < ZERO) AND ((No-07 - No-06) > -4)) )
           AND ( (No-06 = ZERO) OR (((No-06 - No-05) < ZERO) AND ((No-06 - No-05) > -4)) )
           AND ( (No-05 = ZERO) OR (((No-05 - No-04) < ZERO) AND ((No-05 - No-04) > -4)) )
           AND ( (No-04 = ZERO) OR (((No-04 - No-03) < ZERO) AND ((No-04 - No-03) > -4)) )
           AND ( (No-03 = ZERO) OR (((No-03 - No-02) < ZERO) AND ((No-03 - No-02) > -4)) )
           AND ( (No-02 = ZERO) OR (((No-02 - No-01) < ZERO) AND ((No-02 - No-01) > -4)) )
           THEN
          ADD 1 TO SUM-OF-CORRECT-LINES
        END-IF
    END-EVALUATE

  .

*> ----------------------------------------------- <*
  READ-LOOP SECTION.
    READ PUZZLE-FILE
      AT END 
        MOVE FILE-END TO FILE-END-FLAG
      NOT AT END
        PERFORM HANDLE-LINE
  . *>END SECTION

*> ----------------------------------------------- <*
  HANDLE-LINE SECTION.

    UNSTRING PUZZLE-LINE DELIMITED BY SPACE
        INTO No-01
             No-02
             No-03
             No-04
             No-05
             No-06
             No-07
             No-08
             No-09
    END-UNSTRING
    PERFORM CHECK-LEVEL

  . *>END SECTION

*> === EOF ======================================= <*
