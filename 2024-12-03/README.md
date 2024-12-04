# Advent of COBOL - Tag 3

Der Rätseltext des [Advent of Code, Tag 3](https://adventofcode.com/2024/day/3) hat auch dieses Jahr wieder zwei Aufgaben für uns. Diese Seite gibt nur die eigentlichen Lösungswege nicht die schöne Geschichte dahinter wieder.

## Vormittag

Dieses mal soll eine Textdatei geparst werden. Ziel ist es zulässige Statements zu finden. Mit einem regulären Ausdruck ist dies natürlich einfach, aber einfach kann jeder und wir können COBOL!

1. Die Datei selbst lesen wir nun Zeichenweise ein. Das ist nicht performant aber erfüllt seinen Zweck. 
2. Anschließend machen wir einen Mustervergleich, wobei wir dazu auf das letzte Zeichen zugreifen 
3. Passt das letzte Zeichen (Vorgänger) nicht zum aktuellen Zeichen, führen wir ein Rollback durch und beginnen die Prüfung von vorn - sprich wir warten wieder auf ein "mul([0-9].,[0-9].)"
4. Haben wir schließlich die schließende Klammer tatsächlich erreicht können wir die gewünschte Berechnung ausführen.

### Einfachverzweigungen und Mehrfachverzweigung

Die Einfachverzweigung `IF bedingung THEN anweisung END-IF` führt die Anweisungen aus, wenn die Bedingung wahr ist. Optional können wir auch noch mit `ELSE` festlegen, welse Anweisungen ausgeführt werden sollen wenn die Bedingung unwahr ist.

```COBOL
IF 1=1 THEN
  DISPLAY "Dies wird ausgebene, weil 1 gleich 1 ist"
ELSE
  CONTINUE
END-IF
```

Das Schlüsselwort `CONTINUE` kann stets zum Einsatz kommen, wenn wir an dieser Stelle "nichts" machen wollen. Dies ist identisch zu

```COBOL
IF 1=1 THEN
  DISPLAY "Dies wird ausgegeben, weil 1 gleich 1 ist"
END-IF
```

Nun gibt es aber auch Fälle wo wir mehr als nur einen Wert prüfen. Dazu stehen die logischen Verknüpfungen zur Verfügung.

```COBOL
IF 1=1 AND 2=2 THEN
  DISPLAY "Dies wird ausgegeben"
END-IF
```

Wenn wir ein einzelnes Feld prüfen wollen müssen gibt es gleich mehrere Möglichkeiten. Neben der `IF` Anweisung gibt es auch die `EVALUATE` als Mehrfachverzweigung. `EVALUATE feld WHEN bedingung anweisung` prüft dabei das angegebene Feld gegen die Bedingung und führt ggf. die nachfolgenden Anweisungen aus.

```COBOL
01 VIELLEICHT-NUMERISCH    PIC X.
*>...
IF VIELLEICHT-NUMERISCH = "1" OR VIELLEICHT-NUMERISCH = "2" OR
   VIELLEICHT-NUMERISCH = "3" OR VIELLEICHT-NUMERISCH = "4" OR
   VIELLEICHT-NUMERISCH = "5" OR VIELLEICHT-NUMERISCH = "6" OR
   VIELLEICHT-NUMERISCH = "7" OR VIELLEICHT-NUMERISCH = "8" OR
   VIELLEICHT-NUMERISCH = "9" OR VIELLEICHT-NUMERISCH = "0
  DISPLAY "tatsächlich numerisch"
ELSE
  DISPLAY "nicht numerisch"
END-IF

EVALUATE VIELLEICHT-NUMERISCH
  WHEN "1"     DISPLAY "tatsächlich numerisch" 
  WHEN "2"     DISPLAY "tatsächlich numerisch" 
  WHEN "3"     DISPLAY "tatsächlich numerisch" 
  WHEN "4"     DISPLAY "tatsächlich numerisch" 
  WHEN "5"     DISPLAY "tatsächlich numerisch" 
  WHEN "6"     DISPLAY "tatsächlich numerisch" 
  WHEN "7"     DISPLAY "tatsächlich numerisch" 
  WHEN "8"     DISPLAY "tatsächlich numerisch" 
  WHEN "9"     DISPLAY "tatsächlich numerisch" 
  WHEN "0"     DISPLAY "tatsächlich numerisch" 
  WHEN OTHER   DISPLAY "nicht numerisch"  
END-EVALUATE
```  
  
Ein Spezialfall ist dabei `EVALUATE TRUE` und dieser ist sehr elegant mit einer 88er Stufe und einer Redefinition nutzbar.  

```COBOL
01 VIELLEICHT-NUMERISCH    PIC X.
01 NUMERISCH REDEFINES VIELLEICHT-NUMERISCH  PIC 9.
  88 TATSAECHLICH-NUMERISCH   VALUE 0 thru 9.
  88 AUCH-TATSAECHLICH-NUMERISCH   VALUE 0, 1, 2, 3, 4, 5, 6, 7, 8 ,9.
*>...
  
EVALUATE TRUE
  WHEN TATSAECHLICH-NUMERISCH    DISPLAY "tatsächlich numerisch"
END-EVALUATE
```


