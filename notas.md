# Klasnota's Besturingssystemen/Linux

## Gebruikers en groepen

- Commando's:
    - Gebruikers: `useradd`, `usermod`, `userdel`
    - Groepen: `groupadd`, `groupmod`, `groupdel`
    - Info opvragen: `who`, `groups`, `id`
- Configuratiebestanden:
    - Gebruikers: `/etc/passwd`, `/etc/shadow`
    - Groepen: `/etc/group`, (`/etc/gshadow`, van weinig belang)
- Opmerkingen:
    - Primaire groep: 4e veld van `/etc/passwd` (group ID)
    - Aanvullende groepen: in `/etc/group`. Gebruiker staat niet vermeld in de primaire groep!
    - `usermod -g groep gebruiker`: *primaire* groep aanpassen
    - `usermod -G groep1,groep2 gebruiker`: gebruiker toevoegen aan opgegeven groepen *en verwijderen uit alle andere groepen*
    - `usermod -aG groep gebruiker`: gebruiker toevoegen aan opgegeven groep, blijft lid van andere groepen

## Permissies

- *Permissies* = toegangsrechten voor bestanden en directories
    - Bestanden zijn eigendom van een gebruiker en groep
    - cfr. `ls -l` voor een overzicht
- Instelbaar op niveau van:
    - `u`: gebruiker, user
    - `g`: groep, group
    - `o`: andere gebruikers, others
    - `a`: iedereen, all
- Soorten permissies:
    - `r`: lezen, read
    - `w`: schrijven, write
    - `x`: uitvoeren als commando (file), toegang met `cd` (directory)
- permissies instellen met `chmod`, symbolische notatie

    ```
    chmod MODUS FILE
    chmod u+r FILE
          g-w
          o=x
          a
    ```
- permissies in octale notatie: beschouw permissies in `ls -l` als bitpatroon

    ```
      u      g      o
    r w x  r - x  - - -
    1 1 1  1 0 1  0 0 0
    4+2+1  4+0+1  0+0+0
      7      5      0
    ```

- Opmerkingen:
    - sommige permissie-combinaties komen nooit voor in de praktijk, bv. 1, 2, 3
    - gebruiker heeft altijd meer rechten dan groep/others
    - `root` negeert bestandspermissies (mag alles), vb. `/etc/shadow`

- `umask` bepaalt standaard-permissies van bestand/directory bij aanmaken
    - huidige waarde opvragen met `umask` zonder opties
    - opgegeven in octale notatie
    - "welke permissies afnemen"

    ```
      file      directory
      0 6 6 6     0 7 7 7
    - 0 0 0 2   - 0 0 0 2
    ---------   ---------
      0 6 6 4     0 7 7 5
    ```

    - Enkel 0, 2 en 7 zijn zinvol!

- Speciale permissies:
    - `u+s`: set user ID (setUID)
        - op bestanden met execute-permissies
        - tijdens uitvoeren krijgt de gebruiker de rechten van de eigenaar van het bestand
    - `g+s`: set group ID (setGID)
        - tijdens uitvoeren krijgt de gebruiker de rechten van de groep van het bestand
    - `+t`: restricted deletion, of "sticky bit"
        - toegepast op directories
        - een bestand mag in zo'n directory enkel door de eigenaar verwijderd worden

- Eigenaar/groep veranderen:
    - root-rechten nodig

    ```
    chown user file
    chown user:group file
    chgrp group file
    ```

## Scripts (1)

### Variabelen

- Bash-variabelen zijn (vrijwel altijd) strings.

- Declaratie:

    ```bash
    variabele=waarde
    ```

- Waarde oproepen:

    ```bash
    ${variable}
    ```

- Gebruik in strings (met dubbele aanhalingstekens):

    ```bash
    echo "Hello ${USER}"
    ```

    - Gebruik zoveel mogelijk de notatie `${var}` (accolades rond variabelenaam)
    - Gebruik dubbele aanhalingstekens: `"${var}"` (vermijden splitsen van woorden)

- Onbestaande variabele wordt beschouwd als lege string.
    - Dit is een oorzaak van veel fouten in shell-scripts!
    - Gebruik `set -o nounset`, dan zal script meteen stoppen met foutboodschap

- Scope van een variabele: binnen zelfde "shell", niet binnen "subshells"
    - Een script of functie oproepen creëert een subshells
    - Maak "globale", of *omgevingsvariabele* met `export`:

      ```bash
      export VARIABLE1=value
      VARIABLE2=value
      export VARIABLE2
      ```

- Conventie naamgeving:
    - Lokale variabelen: kleine letters, bv: `foo_bar`
    - Omgevingsvariabelen: hoofdletters, bv. `FOO_BAR`


### Positionele parameters

Bij uitvoeren van script zijn opties en argumenten beschikbaar via variabelen, *positionele parameters*

| Variabele           | Betekenis                                  |
|:--------------------|:-------------------------------------------|
| `${0}`              | Naam script                                |
| `${1}`, `${2}`, ... | Eerste, tweede, ... argument               |
| `${10}`             | Tiende argument (accolades verplicht!)     |
| `${*}`              | Alle argumenten: `${1} ${2} ${3}...`       |
| `${@}`              | Alle argumenten: `"${1}" "${2}" "${3}"...` |

Het commando `shift` schuift positionele parameters op:

- `${1}` verdwijnt
- `${2}` wordt `${1}`
- `${3}` wordt `${2}`
- enz.

### Exit-status en logische operatoren

- Elk commando heeft een exit-status, numerieke waarde
    - Opvragen met `echo "$?"`
    - 0 => commando geslaagd, logische TRUE
    - 1-255 => commando gefaald, logische FALSE
- Logische operatoren in Bash zijn gebaseerd op exit-status
- Booleaanse variabelen *bestaan niet*

```bash
if COMMANDO; then
  # A
else
  # B
fi
```

- `A`-blok wordt uitgevoerd als exit-status van `COMMANDO` 0 is (geslaagd, TRUE)
- `B`-blok wordt uitgevoerd als exit-status van `COMMANDO` verschillend is van 0 (gefaald, FALSE)

- Commando `test` wordt gebruikt voor het evalueren van logische expressies, geeft geschikte exit-status
    - 0 = TRUE
    - 1 = FALSE
- Alias voor `test` is `[`
    - `[` is een *commando*, geen "haakje" in de traditionele betekenis
    - spaties vóór en na!

```bash
# Fout:
if[$#-eq 0]; then
  echo "Expected at least one argument"
fi

# Juist:
if [ "${#}" -eq "0" ]; then
  echo "Expected at least one argument"
fi
```
