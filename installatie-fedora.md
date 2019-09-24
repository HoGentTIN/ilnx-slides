---
title: Installatie Fedora in VirtualBox
---

# Voorbereiding

## Installatie

- Installeer VirtualBox
- Download Fedora Workstation Live ISO

## Extension pack installeren

- Preferences > Extensions

## Maak een Host-onlynetwerk aan

- Tools > Network > Create
- Controleer instellingen:
    - IP: 192.168.56.1
    - netmask: 255.255.255.0
    - DHCP server: aanvinken
        - Server address: 192.168.56.100
        - Server mask: 255.255.255.0
        - Lower address: 192.168.56.101
        - Upper address: 192.168.56.254

# VM voorbereiden

## Nieuwe VM aanmaken

- Voldoende grote HDD (dynamically allocated)
- Voldoende geheugen (>= 2GiB)
- Graphics controller: **VBoxSVGA**
    - Videogeheugen (128MB)
    - 3D acceleration
- Network: 2 adapters aanzetten
    - Adapter 1: NAT
    - Adapter 2: Host-only

## VM opstarten

- Booten vanaf Fedora Workstation Live ISO

## Installeer naar harde schijf

## Opnieuw opstarten

- ISO verwijderen uit VM!

# Configuratie VM (optioneel)

## Screensaver/-lock uitzetten

## Software installeren/updates

```console
sudo yum install git vim-enhanced
sudo yum upgrade
```

- Upgrades enkel over performante netwerkverbinding!
- Rebooten enkel nodig na kernel update

## VM geconfigureerd naar wens?

- Creëer snapshot
- Correct afsluiten!

# That's it!
