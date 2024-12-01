# Advent of COBOL - Tag 1

Der Rätseltext ist des [Advent of Code, Tag 1](https://adventofcode.com/2024/day/1) hat auch dieses Jahr wieder zwei Aufgaben für uns. Diese Seite gibt nur die eigentlichen Lösungswege nicht die schöne Geschichte dahinter wieder.

## Vormittag

Der Anwendungsfall also das Rätsel ist wie gemacht für einen Cobold. 

1. Wir haben also zwei Spalten in einer strukturierten Datei mit Zahlen. Die Datei selbst ist zeilenweise aufgebaut. Die Zahlen sind dabei immer genau 5-stellig und an festen Positionen in der Datei.
2. Die Zahlen in den jeweiligen Spalten müssen zunächst sortiert werden. 
3. Wir sollen den Abstand zwischen zwei sich gegenüberstehenden Zahlen ermitteln.
4. Die Summe aller Abstände ist das Ergebnis für unser Rätsel.

### COBOL Programmaufbau

COBOL ist strukturiert und das bedeutet, dass wir alles in einer Reihenfolge machen. Der *Entry Point* häufig als *main* Methode benannt ist ebensowenig irgendwo im Programmcode versteckt und Variablen werden auch nicht mittendrin definiert. Jedes COBOL Programm besteht aus dem gleichen Aufbau.

    IDENTIFICATION DIVISION.
    ENVIRONMENT DIVISION.
    DATA DIVISION.
    PROCEDURE DIVISION.

Und so sind ein strukturiertes Program aus! Hast du auch zunächst eine etwas modernere Programmiersprache gelernt, dann öle dein <span title="nicht das wir bei VI ein Scollrad bräuchten, aber es geht">Scrollrad der Maus</span> um immer wieder an den Anfang zu springen um eigentlich lokal benutzte Variablen zu definieren.

### Dateizugriff mit COBOL deklarieren

Der Dateizugriff ist je nach Betriebssystem ein bisschen "anders". Bei COBOL auf Hauptrechner wird die Datei außerhalb definiert, in der PC und Serverwelt können wir einfach den Dateinamen zuweisen (**5.** *Assign to*). Um Dateien zu kontrollieren (**3.** *File-Control*) ist es wichtig zu beachten, dass Dateien zur Umgebung (**1.** *Environment*) des COBOL Programms gehören und ... trommelwirbel... der Eingabe und Ausgabe (**2.** *Input-Output*) dienen.

Wir wählen (**4.** *select*) also für unsere zeilenweisen organisierten (** 6.** *organization is line sequential*) Eingabedaten die Umgebung. Und damit haben wir auch schon alles benannt und muss nur noch sortiert aufgeschrieben werden.

    ENVIRONMENT DIVISION.                      *> 1.
      INPUT-OUTPUT SECTION.                    *> 2.
        FILE-CONTROL.                          *> 3.
          SELECT PUZZLE-FILE                   *> 4.
              ASSIGN TO 'puzzle.am'            *> 5.
              ORGANIZATION IS LINE SEQUENTIAL  *> 6.
          .

Wie viele der kleinen *dots* in COBOL ist auch hier der Punkt `.` Wichtig - Wichtig mit einem großen W! Compiliert dein Programm nicht gleich richtig, kaufe noch ein *dot* und löse (das Problem) auf. Und nun können wir über den Bezeichner `PUZZLE-FILE` auf unsere Datei zugreifen.

Anm.: Wer das Zeienendezeichen in der Datei kennt, kann auch SEQUENTIAL nutzen, ohne LINE. 

Ist dir aufgefallen, dass die Überschrift *deklarieren* nicht *definieren* verwendet hat?

### Datendeklaration mit COBOL

Auch in COBOL bekommen Variablen Namen, wobei wir uns auf <span title="und es macht Spaß den Fehler zu suchen, wenn in generierten Quelltext die Namen länger werden">29 Zeichen</span> für den Variablennamen beschränken sollten. Wir erinnern uns, dass COBOL strukturiert ist: Datenelemente werden vor dem Algorithmus definiert. Dafür gibt es die `DATA DIVISION`.

    IDENTIFICATION DIVISION.
    ENVIRONMENT DIVISION.
    DATA DIVISION.
    PROCEDURE DIVISION.

Kommen wir zurück auf unsere Datei, die wir ja *nur deklariert* haben. Schauen wir uns den Aufbau im Einzelnen an: 

* `wc -L puzzle.am` ermittelt die maximale Zeilenlänge von 13 Zeichen für uns.
* `wc -l puzzle.am` ermittelt die Anzahl der Zeilen mit 1000 Zeichen

Windows Nutzer haben sicher bereits die Unix-Tools, Cygwin oder ähnliches installiert und können auch mit dem Wordcount (*wc*) die Ergebnisse ermitteln oder nutzen ein Alternativwerkzeug.

Jetzt gilt für die Daten der Datei (*File Section*) die Dateibeschreibung (*File Descriptor*) anzulegen. Für unsere zeilenweise Datei also jede Zeile mit 13 beliebigen Zeichen (*X*).

    DATA DIVISION.
    FILE SECTION.
    FD PUZZLE-FILE.
      01 PUZZLE-LINE PIC X(13).

Was soll aber die `01`? In COBOL werden Daten zunächst in <ins title="Was zur Hölle sind Stufen?">Stufen</ins> unterteilt. Abgesehen von ein paar Spezialstufen (`66`, `77`, `78`, `88`) gibt die Zahl die Detaillierungsstufe an. Je höher die Zahl, desto detailierter ist unsere Beschreibung - ruhig Brauner, wir lösen die Fragezeichen gleich auf. Unsere Detaillierung für die Dateizeile ist jetzt ganz allgemein mit es sind 13 beliebige Zeichen in einer Zeile bevor ein oder zwei Zeilenendezeichen kommen (*CR/LF*).   

Das es ein beliebiges Zeichen ist, geben wir mit der `PICTURE` Klausel an. Diese besteht aus der Angabe was für ein Zeichen, der Anzahl wie oft und ggf. auch noch das Format. Beispiele:

    01 EINE-VIERSTELLIGE-ZAHL        PIC 9(4).
    01 EINE-AUCH-VIERSTRELLIGE-ZAHL  PIC 9999.
    01 EINE-ZAHL-MIT-KOMMASTELLEN    PIC 9(2)V999.
    01 EIN-TEXT-MIT-VIER-ZEICHEN     PIC XXXX.

Jetzt brauchen wir aber auch noch Daten zum Arbeiten (*Working-Storage Section*).

    DATA DIVISION.
    FILE SECTION.
    FD PUZZLE-FILE.
      01 PUZZLE-LINE PIC X(13).

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

In dem Bereich der *Dateisteuerung* haben wir jetzt eine Variable `FILE-END` mit dem Wert `Y` aufgenommen. `77`er Stufen können wir **nicht** weiter detailieren.

Darüber hinaus haben wir eine `88`er Stufe aufgenommen. `88`er Stufen sind ein eleganter Vergleich des Inhalts und können geprüft werden, wie wir noch später implementieren. Diese können sowohl <span title="88er Stufen sind die Regulären Ausdrücke für Arme">einzelne, mehrere oder auch Wertebereiche</span> umfassen. 

Bei unseren eigentlichen Fachdaten haben wir jetzt 13 Zeichen in drei Gruppen unterteilt, die X-Position mit 5 Ziffern, 3 Zeichen die wir ignorieren (*filler*) und die Y-Position mit 5 Ziffen. Eine klar strukturierte Zeile.

Und zum Schluss haben wir noch drei Tabellen mit nur einer Spalte und je 1000 Zeilen definiert - wird wohl kein Zufall sein, dass dies mit den Zeilen unserer Datei übereinstimmt. Damit wir "dynamisch" darauf zugreifen können, definieren wir uns noch einen Index (*table-index*). Und das Ergebnis wird zum Schluss in `SUM-OF-ALL-DIFFENRENTS` abgelegt.
Da wir ja <ins title="ja klar, jeder Normalo programmiert ja auch in COBOL">keine Nerds</ins> sind, sondern Business-Developer beginnen wir die Tabellennummerierung natürlich natürlich mit <span title="Bitte keine Hochrufe auf VBA!">1 statt 0</span>. 

Anm. Natürlich könnte man einen Großteil der Dateindefinition auch zusammenziehen, aber es geht hier mehr um die Lösung als die Eleganz der Lösung. **Erst muss es funktionieren**, *dann darf es auch noch gut aussehen.*

Wie man sieht kann man also die Variablen so bezeichnen, dass weitergehend ein schöner lesbarer Quelltext entsteht. Dieser ist dann von sich aus <span title="wer den Unterschied zwischen Wartung und Pflege nicht kennt, darf Deutsch wie wir sind in gesetzen nachschauen - dem KONSENS-Gesetz">wartbar und pflegbar</span>, wäre da nicht die Historie. In einer Zeit wo 8 Zeichen für Dateinamen und Variablen schon viel waren und man um jedes Halbbit gerungen hat wurden selten sprechende Namen verwendet. Und obwohl es ein leichtes wäre ein bisschen Refactoring zum machen... - das ist doch langweilig für Businessentwickler wie uns.

### Der Algorithmus ruft

Noch im Kopf, wie ein strukturiertes Programm aussieht?

    IDENTIFICATION DIVISION.
    ENVIRONMENT DIVISION.
    DATA DIVISION.
    PROCEDURE DIVISION.

`PROCEDURE DIVISION` - die Handlungsanweisung - und damit auch hier wieder ein sprechender Name, kann nur aus Anweisungen bestehen und <span title="oder sehr beliebt die Endlosschleife">endet mit einem Rücksprung zum Aufrufer oder der Beendigung des Programms</span>. Wahlweise können wir auch noch ein den numerischen Rückgabewert mitgeben. Die Anweisungen `GOBACK` und `STOP RUN` und der abschließende Wichtige, Wichtig mit großem W, Punkt beenden das Programm.

Wir können den Programmablauf noch unterteilen in `SECTION` und Paragraphen. Dein Compiler sollte bei Fehlern dir immer auch die Section und den Paragraphen angeben. Wichtig, Wichtig mit großem W, sind hier wieder unsere Punkte. 

Sehr typisch ist der Aufbau einer Hauptsection oder Hauptparagraph. Anders als Unterprogramme oder Funktionen, Methoden, etc. in anderen Prgrammiersprachen fällt man von einem Paragraph in den nächsten. Jeder Paragraph und jede Section hat immer mindestens eine Anweisung. 

Schauen wir uns den ersten Abschnitt in der `PROCEDURE DIVISION` an:

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

Der Ablauf des Programms selbst ist dabei mit dem Start in der Procedure Division

1. Betrete die `MASTER SECTION`.
2. Betrete den `INIT` Paragraph, wobei anders als bei einer Section hier kein Schlüsselwort sondern nur die Bezeichnung `INIT` gefolgt von einem Wichtigen Punkt.
3. Verlasse den `INIT` Paragraph, welcher nur durch den `.` beendet wird.
4. Betrete den `MAIN` Paragraph.
5. Spring (*perform*) in die `READ-LOOP` Section bis die 88er Stufe `FILE-END-TRUE` wahr ist.
6. Verlasse den `MAIN` Paragraph.
7. Betrete den `DEINIT` Paragraph.
8. Verlasse den `DEINIT` Paragraph.
9. Gehe zum Aufrufer (oder beende das Programm) mit `GOBACK`.
10. Beende das Programm mit `STOP-RUN`.
11. Beende die `MASTER` Section mit dem abschließenden Wichtigen Punkt. Ja, natürlich ist dieser nicht relevant für die `MASTER` Section, jedoch für die anderen Abschnitte (in COBOL eben Section nicht Methode oder Funktionen genannt) ist dieser Punkt Wichtig, Wichtig mit einem großen W!

Der Aufbau selbst mit einem Vorbereitungsabschnitt (*INIT*), der eigentlichen Programmlogik (*MAIN*) und einem Aufräumabschnitt (*DEINIT*) ist in COBOL durchaus verbreitet auch wenn die Namen variieren. Das frühe Öffnen von Dateien und späte Schließen dieser gehört dazu und ist zumindest auf PC und Serverebene eher zu vermeiden. 
Fehlerbehandlungen sind hier bewusst nicht enthalten um das Beispiel einfach zu halten. 


Das Puzzle Nr. 1 von Tag 1 kann einen guten Überblick über die Struktur eines COBOL Programmes geben. Wir können das Programm compilieren und starten.

```bash
cobc -x -free -o 2Dam.exe today-am.cob
./2Dam.exe
```

Im Programm enthalten sind auch der konkrete Dateizugriff, eine Schleife, Zugriff auf Tabellen Elemente, Berechnungen und der Aufruf von Funktionen (*section*). Nicht alles wurde angesprochen oder ausführlich erklärt aber dies ist auch nur der Einstieg und die Lesbarkeit des Programms ermöglicht auch das eigene Studium. 


Das vollständige Beispiel:

```cobol
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
```
