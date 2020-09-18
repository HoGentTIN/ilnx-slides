---
title: Werken met de Fedora VM
---

# Inhoud

## Inhoud

- Configuratie UI
- Bestanden kopiëren
- Werken met Git

# Configuratie UI

## Beeldscherminstellingen

- Settings > Displays > Resolution
- Settings > Privacy > Screen Lock
    - Blank screen delay: Never
    - Automatic Screen Lock: uitschakelen

## Extra instellingen

- `sudo dnf install gnome-tweaks`
- Start Tweaks op
- Windows Titlebars
    - Maximize en Minimize aanzetten
- Optioneel:
    - Windows > Window Focus > Focus on Hover

# Bestanden kopiëren tussen VM en fysiek systeem

## Zet SSH aan

```console
sudo systemctl start sshd
```

## FileZilla

- Installeer zo nodig FileZilla op je fysieke systeem
- Zoek het IP-adres van je VM (begint met 192.168.56)
    - `ip a`
- Open FileZilla, vul bovenaan in:
    - Host: IP-adres van jouw VM (vaak 192.168.56.101)
    - Username: jouw gebruikersnaam op de VM
    - Password: jouw wachtwoord om in te loggen op de VM
    - Port: 22 (staat voor SSH)
    - Druk op QuickConnect

# Werken met Git

## Installeer en configureer Git

```console
sudo dnf install git

git config --global user.name 'Jouw Naam'
git config --global user.email 'jouw.naam@student.hogent.be'
git config --global push.default simple
git config --global core.autocrlf input
git config --global pull.rebase true
```

## Maak een SSH sleutelpaar aan

```console
ssh-keygen
```

- Blijf ENTER drukken
- Open `~/.ssh/id_rsa.pub` met teksteditor
- Kopieer de gehele inhoud

## Voeg sleutel toe aan Github

- Log binnen je VM in op Github
- Klik rechtsboven op je avatar, ga naar Settings
- Kies SSH and GPG keys
- Voeg nieuwe SSH-sleutel toe
    - Geef een geschikte naam (optioneel)
    - Plak inhoud `id_rsa.pub` in het tekstveld

## Maak Github-repo aan voor labo-nota's

- Ga naar Chamilo
- Volg link voor aanmaken persoonlijke repository
- Eens de repo aangemaakt, druk op groene knop "Code"
- kies "SSH" en kopieer de URL
- In de terminal, doe (met de URL naar jouw repo)

```console
git clone git@github.com:HoGentTIN/ilnx-labos-2021-GEBRUIKER.git
```

## Intermezzo

Maak nu eventueel een snapshot aan van je VM!

## Markdown

- Labo-opgaven en nota's zijn in Markdown-formaat
- Tekstformaat, te bewerken in editor
- Op Github omgezet naar en getoond als HTML!
- In VS Code, druk Ctrl+Shift+V => preview

## Wijzigingen registreren in Git

- Bewerk bestanden met editor
- In terminal ga naar je lokale kopie van de repo

```console
cd ilnx-labos-2021-GEBRUIKER
git status
git add .
git commit -m "Labo 1 uitgevoerd"
git push
```

Bekijk je wijzigingen op Github!

## Wijzigingen op Github naar VM downloaden

```console
cd ilnx-labos-2021-GEBRUIKER
git pull --rebase
```

Vermijd om zowel in VM als op Github wijzigingen te committen in eenzelfde bestand!

## That's it!