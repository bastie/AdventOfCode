# Advent Of <strike>Code</strike> Cobol

Einfach mal verrückt sein und mit der wohl einfachsten Programmiersprache überhaupt COBOL [Advent of Code](https://adventofcode.com/2024) Rätsel lösen.

## COBOL
Die **Co**mmon **B**usiness **O**riented **L**anguage (COBOL) ist eine  Programmiersprache, welche mit den Zielen

* standardisiert
* hardwareunabhängig
* lösungsorientiert
* für den kaufmänischen / betriebswirtschaftlichen Bereich

entwickelt wurde. COBOL verschwendet wenig Energie auf elegante Syntaxspielereien, Algorithmen und Klicki<span title="die sollte ruhig englisch interpretiert werden">die</span>bunt-Oberflächen. Dafür wird Wert auf einen lesbaren Programmtext gelegt, welcher sich doch passend an der englischen Sprache orientiert, so dass fast schon Fließtext erkennbar ist. Es liegt also wieder an uns Programmierern durch kryptische Strukturen, Namensgebung und Algorithmen unverzichtbar zu machen. 

Aber hey wir sind Programmierer, wir bekommen das doch in jeder Programmiersprach hin. 

### Installation
Es gibt verschiedenste COBOL Compiler und die Konfiguration des Compiler ist die erste Möglichkeit uns unverzichtbar zu machen. Mit den richtigen Schaltern ob beim Aufruf des Compilers auf der Kommandozeile - ja das ist dieses meist schwarze Fenster liebe GUI-Kinder und das wird hier genutzt - in Konfigurationsdateien oder auch <span title="$set">direkt im Quelltext</span> können wir verschieden COBOL-Dialekte und Sprachversionen einstellen.

Hier wird der GNU-COBOL-Compiler genutzt, ehemals OpenCobol, da er auf den häufig verwendeten <span title="BSD, macOS, Linux und sogar Windows">Betriebssystemen</span> verwendbar ist. Aber auch andere COBOL Compiler Hersteller sind sicher verwendbar, allerdings sind zumindest auf dem Hauptrechnern die abweichenden Art auf Dateien zuzugreifen zu beachten.

Unter <span title="Erst muss es funktionieren, aber dann darf es auch noch gut aussehen">macOS</span> kann man [Homebrew](https://brew.sh) einsetzen und mit `brew info gnucobol` installiert werden. Auf dem zweiten Bildschirm läuft nebenbei der COBOL [Programmers Guide](https://gnucobol.sourceforge.io/guides.html) oder die 42. Wiederholung von Per Anhalter durch die Galaxis.

### Compilieren 
Natürlich können und wer den falschen COBOL Compiler einsetzt muss sogar wir COBOL im Sinne der guten alten Zeit mit 80 Spalten einsetzen und auch auch einen Feuerbohrer einsetzen um dann Kaffee zu kochen. Oder wir nutzen das *<strong title="🎶free your mind">free</strong>-format* und bleiben in diesem Jahrtausend.

    cobc -x -free -o wherearemygifts.exe christmas.cob
 
* `cobc` ist der COBOL Compiler
* `-x` um eine ausführbare Datei zu erstellen
* `-free` wir nutzen das <span title="🎶free as a bird">free-format</span>
* `-o wherearemygifts.exe` die Ausgabe soll in die Yippi.exe erfolgen und das `.exe` ist zwar nur unter Windows notwendig, aber funktioniert auch auf den anderen Betriebssystemen
* `quelltext.cob` die Datei in der wir den COBOL-Quelltext haben mit einer typischen Endung. Gern wird auch `.cbl` verwendet und `.cpy` ist für einen Spezialfall auch gern verwendet.

Der Quelltext für die Datei `christmas.cob`:

           IDENTIFICATION DIVISION.
           PROGRAM-ID. HiSanta.
    
           PROCEDURE DIVISION.
             DISPLAY "Hello Santa"
           STOP RUN.
          *EOF

OK, die Datei wäre auch ohne `-free` compilierbar. 

### Programmieren mit COBOL
Anwendungsprogramme mit COBOL entwickeln ist einfach und Anwenderprogramme mit COBOL entwickeln ist kompliziert. <span title="long long time ago">Es war einmal vor langer Zeit</span>, als Telefone noch mit seltsamen Dräthen an der Wand befestigt waren, da wurde COBOL entworfen. In einer Zeit wo es kein Computer in der Hosentasche oder auf dem Schreibtisch stand, wo auch keine grafischen Oberflächen existierten, war die Verarbeitung von komplexen Berechnungen mit FORTAN oder auch vielen Firmendaten mit COBOL bereits notwendig. Voll ökologisch wurden Programme noch auf kompostierbaren Lochkarten geschrieben.

COBOL wurde ursprünglich rein in Großbuchstaben programmiert und der Compiler erwartet den eigentlichen Quelltext ab Spalte 8. Spalte 7 dient einer besonderen Auszeichnung für die Zeile. Ein Ganzzeilenkommentar hat in der Spalte 7 ein Asterix `*`. Eigentlich ist bei Spalte 72 dann Schluss und <span title="blah blah blah">...</span>  

Zurück zum <strong>free-format</strong>. Alles was wir wissen müssen ist:

* COBOL Quelltext unterteilt sich in Abschnitte als `DIVISION` benannt.
* Eine `DIVISION` können wieder unterteilt sein in `SECTION` Abschnitte.
* Innerhalb der `SECTION` sind weitere Unterteilungen möglich, wie `Paragraphen`.
* Mit dem Asterix gefolgt von einem größer als Zeichen `*>` können wir Kommentare in der Zeile einleiten. 
* COBOL Quelltext ist strukturiert, erst die Daten definieren dann die Algorithmen. 


