% Besturingssystemen: Linux
% HoGent Bedrijf en Organisatie
% 2017-2018

# Hoofdstuk 1. Linux installeren

# Les 1. Linux installeren

# Hoofdstuk 2. Linux leren kennen

# Les 2. Werking van de command line

# Les 3. Bestanden en directories

# Hoofdstuk 3. Werken met tekst

# Les 4. De Vim-editor, I/O Redirection

## Vim survival guide

- Bij opstarten van Vim kom je terecht in *normal mode*.
- Als je tekst wil invoeren moet je naar *insert mode*.

| Taak                       | Commando |
| :---                       | :---     |
| Normal mode -> insert mode | `i`      |
| Insert mode -> normal mode | `<Esc>`  |
| Opslaan                    | `:w`     |
| Opslaan en afsluiten       | `:wq`    |
| Afsluiten zonder opslaan   | `:q!`    |

## I/O redirection

## Streams

- *stdin*, standard input
    - vgl. Java `System.in`
- *stdout*, standard output
    - vgl. `System.out`
- *stderr*, standard error
    - vgl. `System.err`

## Syntax

| Syntax        | Betekenis                                          |
| :---          | :---                                               |
| `cmd > file`  | schrijf uitvoer van `cmd` weg naar `file`          |
| `cmd >> file` | voeg toe aan einde van `file`                      |
| `cmd 2> file` | schrijf foutboodschappen van `cmd` weg naar `file` |
| `cmd < file`  | gebruik inhoud van `file` als invoer voor `cmd`    |
| `cmd1 | cmd2` | gebruik uitvoer van `cmd1` als invoer voor `cmd2`  |

## Combineren

```bash
# stdout en stderr apart wegschrijven
find / -type d > directories.txt 2> errors.txt

# stdout en stderr samen wegschrijven
find / -type d > all.txt 2>&1

# stdin/stdout en stderr omleiden
sort < unsorted.txt > sorted.txt 2> errors.txt
```

## Foutboodschappen afdrukken

(Equivalent van `System.err.println()`)

```bash
echo "Error: ${dir} is not a directory" >&2
```

## Here documents

Als je meer dan één lijn wil afdrukken:


```bash
cat << _EOF_
Usage: ${0} [OPT]... [ARG]..

OPTIONS:
  -h, --help  Print this help message

_EOF_
```

*Let op:* geen whitespace toegelaten voor de eindemarkering

## Here documents

Dit kan bv. ook:

```bash
mysql -uroot -p"${db_password}" mysql << _EOF_
DROP DATABASE IF EXISTS drupal;
CREATE DATABASE drupal;
GRANT ALL PRIVILEGES ON drupal TO ${drupal_usr}@localhost
  IDENTIFIED BY ${drupal_password};
_EOF_
```

# Les 5. Filters

# Hoofdstuk 4. Een webserver installeren

# Les 6. Een webserver installeren

# Les 7. Netwerkinstellingen controleren

# Hoofdstuk 5. Gebruikers, groepen en permissies

# Les 8. Gebruikers en groepen

## Commando's

- Gebruikers: `useradd`, `usermod`, `userdel`
- Groepen: `groupadd`, `groupmod`, `groupdel`
- Info opvragen: `who`, `groups`, `id`

## Configuratiebestanden

- Gebruikers: `/etc/passwd`, `/etc/shadow`
- Groepen: `/etc/group`, (`/etc/gshadow`, van weinig belang)

## Primaire vs aanvullende groepen

- Primaire groep: 4e veld van `/etc/passwd` (group ID)
- Aanvullende groepen: in `/etc/group`. Gebruiker staat niet vermeld in de primaire groep!

---

- *primaire* groep aanpassen

    ```bash
    $ usermod -g groep gebruiker
    ```

- gebruiker toevoegen aan opgegeven groepen *en verwijderen uit alle andere groepen*

    ```bash
    $ usermod -G groep1,groep2 gebruiker 
    ```

- gebruiker toevoegen aan opgegeven groep, blijft lid van andere groepen

    ```bash
    $ usermod -aG groep gebruiker
    ```

# Les 9. Bestandspermissies

## Permissies

- = toegangsrechten voor bestanden en directories
    - Bestanden zijn eigendom van een gebruiker en groep
    - cfr. `ls -l` voor een overzicht

## Permissies

Instelbaar op niveau van:

- `u`: gebruiker, user
- `g`: groep, group
- `o`: andere gebruikers, others
- `a`: iedereen, all


## Soorten permissies

- `r`: lezen, read
- `w`: schrijven, write
- `x`: execute
    - uitvoeren als commando (file)
    - toegang met `cd` (directory)

## Instellen met symbolische notatie

permissies instellen met `chmod`, symbolische notatie

```
chmod MODUS FILE
chmod u+r FILE
      g-w
      o=x
      a
```

Voorbeelden:

- `chmod g+rw bestand`
- `chmod +x bestand`
- `chmod u+rw,g+r,o-rw bestand`
- `chmod a=r bestand`

## Instellen met octale notatie


```
  u      g      o
r w x  r - x  - - -
1 1 1  1 0 1  0 0 0
4+2+1  4+0+1  0+0+0
  7      5      0
```

Voorbeelden:

- `chmod 755 script`
- `chmod 600 file`
- `chmod 644 file`
- `chmod 775 dir`

## Merk op

- sommige permissie-combinaties komen nooit voor in de praktijk, bv. 1, 2, 3
- directories: altijd lezen (r) en execute (x) *samen* toekennen of afnemen
- gebruiker heeft altijd meer rechten dan groep/others
- `root` negeert bestandspermissies (mag alles), vb. `/etc/shadow`

## Permissies van nieuwe bestanden: `umask`

- `umask` bepaalt permissies van bestand/directory bij aanmaken
- huidige waarde opvragen: `umask` zonder opties
- opgegeven in octale notatie
    - enkel 0, 2 en 7 zijn zinvol
- welke permissies *afnemen*
    - bestand krijgt nooit execute-permissie

## Voorbeeld `umask`

`umask 0002`, wat worden de permissies?

```
  file      directory

  0 6 6 6     0 7 7 7      basis
- 0 0 0 2   - 0 0 0 2      umask
---------   ---------
  0 6 6 4     0 7 7 5      permissies
```

## Speciale permissies: *SUID*

- set user ID (*SUID*)
- op bestanden met execute-permissies
- tijdens uitvoeren krijgt de gebruiker de rechten van de eigenaar van het bestand
- symbolisch: `u+s`
- octaal: 4

```bash
$ ls -l /bin/passwd
-rwsr-xr-x. 1 root root 28k 2017-02-11 12:02 /bin/passwd
```

## Speciale permissies: *SGID*

- set group ID (*SGID*)
- op bestanden met execute-permissies
- tijdens uitvoeren krijgt de gebruiker de rechten van de groep van het bestand
- symbolisch: `g+s`
- octaal: 2

```bash
$ ls -l /usr/bin/write 
-rwxr-sr-x. 1 root tty 20k 2017-09-22 10:55 /usr/bin/write
```

## Speciale permissies: restricted deletion

- restricted deletion, of *sticky bit*
- toegepast op directories
- een bestand mag in zo'n directory enkel door de eigenaar verwijderd worden
- symbolisch: `+t`
- octaal: 1

```bash
ls -ld /tmp
drwxrwxrwt. 16 root root 360 2017-12-04 13:05 /tmp/
```

## Eigenaar/groep veranderen:

Merk op: root-rechten nodig

```
chown user file
chown user:group file
chgrp group file
```

# Hoofdstuk 6. scripts

# Les 10. Variabelen, positionele parameters, logische operatoren

## Variabelen

Bash-variabelen zijn (vrijwel altijd) strings.

Declaratie:

```bash
variabele=waarde
```

Waarde v/e variabele opvragen:

```bash
${variable}
```

Gebruik in strings (met dubbele aanhalingstekens):

```bash
echo "Hello ${USER}"
```

## Variabelen

- Gebruik zoveel mogelijk de notatie `${var}`
    - *accolades*
- Gebruik dubbele aanhalingstekens: `"${var}"`
    - vermijd *splitsen* van woorden

```bash
bestand="Mijn bestand.txt"
touch ${bestand}               # Fout
touch "${bestand}"             # Juist
```

- Onbestaande variabele wordt beschouwd als *lege string*.
    - Oorzaak van veel fouten in shell-scripts!
    - `set -o nounset` ⇒ script afgebroken

## Scope

Enkel binnen zelfde "shell", niet binnen "subshells"

- Een script oproepen creëert een subshell
- Maak "globale", of *omgevingsvariabele* met `export`:

```bash
export VARIABLE1=value

VARIABLE2=value
export VARIABLE2
```

Conventie naamgeving:

- Lokale variabelen: kleine letters, bv: `foo_bar`
- Omgevingsvariabelen: hoofdletters, bv. `FOO_BAR`

## Positionele parameters

Bij uitvoeren van script zijn opties en argumenten beschikbaar via variabelen, *positionele parameters*

| Variabele           | Betekenis                                  |
|:--------------------|:-------------------------------------------|
| `${0}`              | Naam script                                |
| `${1}`, `${2}`, ... | Eerste, tweede, ... argument               |
| `${10}`             | Tiende argument (accolades verplicht!)     |
| `${*}`              | Alle argumenten: `${1} ${2} ${3}...`       |
| `${@}`              | Alle argumenten: `"${1}" "${2}" "${3}"...` |

## Positionele parameters

Het commando `shift` schuift positionele parameters op:

- `${1}` verdwijnt
- `${2}` wordt `${1}`
- `${3}` wordt `${2}`
- enz.

## Positionele parameters instellen

```bash
set par1 par2 par3
echo "${1}"  #  => par1
echo "${2}"  #  => par2
echo "${3}"  #  => par3
echo "${4}"  #  =>       (lege string)
```

## Exit-status

- Elk commando heeft een *exit-status*, numerieke waarde
    - Opvragen met `echo "$?"`
    - 0 => commando geslaagd, logische *true*
    - 1-255 => commando gefaald, logische *false*
- Logische operatoren in Bash zijn gebaseerd op exit-status
- Booleaanse variabelen *bestaan niet*

## Logische operatoren

```bash
if COMMANDO; then
  # A
else
  # B
fi
```

- `A`-blok wordt uitgevoerd als exit-status van `COMMANDO` 0 is (geslaagd, TRUE)
- `B`-blok wordt uitgevoerd als exit-status van `COMMANDO` verschillend is van 0 (gefaald, FALSE)

## Het commando `test`

- Evalueren van logische expressies
- Geeft geschikte exit-status
    - 0 = TRUE
    - 1 = FALSE
- Alias voor `test` is `[`
    - `[` is een *commando*, geen "haakje" in de traditionele betekenis
    - spaties vóór en na!

---

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

# Les 11. Logische structuren, functies

## Tekst afdrukken

Wat is het verschil?

```bash
var="world"

echo "Hello ${var}"
echo 'Hello ${var}'
```
---

```bash
var="world"

echo "Hello ${var}"    # Binnen " wordt substitutie toegepast
echo 'Hello ${var}'    # Binnen ' NIET!
```

## Command substitution

```bash
datum=$(date)

echo "${datum}"
```

## Gebruik `printf`

`printf` is beter dan `echo`

```bash
var="world"

printf "Hello %s\n" "${var}"
```

- Het gedrag is beter gedefinieerd over verschillende UNIX-varianten.
- Vgl. `printf()` method in Java!

## Itereren over positionele parameters (`while`)

```bash
while [ "$#" -gt 0 ]; do
  printf "Arg: %s\n" "${1}"
  # ...
  shift
done
```

## Itereren over positionele parameters (`for`)

```bash
for arg in "${@}"; do
  printf "Arg: %s\n" "${arg}"
  # ...
done
```

## Itereren over bestanden

```bash
for file in *.jpg; do
  printf "Processing %s\n" "${file}"
  # ...
done
```
