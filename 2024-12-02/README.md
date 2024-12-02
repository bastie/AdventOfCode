# Advent of COBOL - Tag 2

Der Rätseltext ist des [Advent of Code, Tag 1](https://adventofcode.com/2024/day/2) hat auch dieses Jahr wieder zwei Aufgaben für uns. Diese Seite gibt nur die eigentlichen Lösungswege nicht die schöne Geschichte dahinter wieder.

## Vormittag

Diesmal ist es schon etwas komplexer. Hatten wir am ersten Tag eine feste Zeilenlänge ist diese nun nicht mehr gegegen. Auch gibt es eine unterschiedliche Anzahl von zu berücksichtigen `level` pro Zeile. Die Beispieldaten sind also nicht representativ.

1. Die Datei selbst ist wie am Tag 1 zeilenweise aufgebaut. 
2. Die Zahlen müssen zunächst in der Zeile von einander getrennt werden. Die Zahlen sind dabei stets durch ein Leerzeichen getrennt. 
3. Wir sollen ermitteln, ob die Zahlen stets aufsteigend oder stets
   absteigend sortiert sind. Nur diese Zeilen werden als korrekt betrachtet.
4. Die Summe aller korrekten Zeilen ist das Ergebnis für unser Rätsel.

Mit `wc -L puzzle.am` ermitteln wir, dass eine Zeile maximal 23 Zeichen beinhaltet.
