# Installatie Wordpress op Fedora: procedure

## Installatie Software

We installeren meteen alle nodige packages:

```bash
sudo dnf install -y httpd wordpress mariadb-server phpMyAdmin
```

## Opstarten Apache en MariaDB

```bash
sudo systemctl start httpd
sudo systemctl start mariadb
sudo systemctl enable httpd
sudo systemctl enable mariadb
```

Testen:

- Draait de service?
    - `systemctl status httpd`
    - `systemctl status mariadb`
- Is de website zichtbaar?
    - Open webbrowser (op de VM!)
    - Surf naar "localhost"
- Werkt PHP?
    - Maak bestand `/var/www/html/info.php` aan:

        ```php
        <?php phpinfo(); ?>
        ```
    - Surf naar <http://localhost/info.php>

## Configuratie firewall

```bash
sudo firewall-cmd --list-all # controleer regels
sudo firewall-cmd --add-service http --permanent
sudo firewall-cmd --add-service https --permanent
sudo firewall-cmd --reload
```

Testen

- Is de VM bereikbaar vanop het fysieke systeem?
    - Controleer IP-adres van de VM: `ip a`
        - wschl: 192.168.56.101
    - In Windows CMD/PowerShell/(Git) Bash:
        - `ping 192.168.56.101`
    - In Terminal op de VM:
        - `ping 192.168.56.1` (= IP-adres fysiek systeem)
        - opm. werkt enkel als fysieke systeem ICMP-verkeer doorlaat
- Is de website zichtbaar vanop het fysieke systeem?
    - Open webbrowser
    - Surf naar <http://192.168.56.101/>

## Configuratie database

```bash
sudo mysql_secure_installation
```

Volg de instructies! Kies een wachtwoord voor de root-gebruiker van de database (= verschillend van de Linux root-gebruiker!) en bevestig de andere vragen. Hou het wachtwoord goed bij!

Testen:

- Via de terminal (log in als root met wachtwoord `letmein` op de `mysql` systeemdatabank):

    ```bash
    mysql -uroot -pletmein mysql
    ```
- Surf op de VM naar <http://localhost/phpmyadmin>

## Database voor Wordpress aanmaken

Via PHPMyAdmin:

- Klik op "User Accounts" > Add user account:
    - User name: `wordpress`
    - Host name: Local / `localhost`
    - Password: kies er een of "Generate"
- Create database with same name and grant all privileges: **aanvinken**
- Ga naar onderaan de pagina, klik rechtsonder op "Go"

## Configuratie Wordpress

In `/etc/httpd/conf.d/wordpress.conf`:

```apache
# Zoek naar
Require local
# Vervang door
Require all granted
```

In `/etc/wordpress/wp-config.php`:

```php
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpress');

/** MySQL database password */
define('DB_PASSWORD', 'R2rrbLV02TA1hAjN');

// Surf naar https://api.wordpress.org/secret-key/1.1/salt/ en kopieer resultaat in wp-config.php

define('AUTH_KEY',         'hvhu`5-Pr,ro=^$[_xgr+%b|AmZ&LYLK1oxejK}-?:0<uEMN{w[8O }$B?bwG^?9');
define('SECURE_AUTH_KEY',  'B*1}XgLH!#A|@l+4QUgaAJ+Ea}84GMuw31c+Tv.d7qYOO!63$5iPtz++5%]`x}H=');
define('LOGGED_IN_KEY',    '}N|S+)76O~tZ6u|j*>[^M/^_ZGzFz6-:AtyY =8Y91C0yX[ AYasbv02^*Q9Uy`0');
define('NONCE_KEY',        '%fK@T#7oM2v+OvMSX4e5%Q.~,g^vgpOI#=cMIy-/InQ9-y%}md[qx-5c|$QYKz=3');
define('AUTH_SALT',        'TJu|kz7`;HK%;a|CVXEGa2bA|-v-fp#=q%FY3#5!?s|vU_D5wfM,gE0H.tm1`Ya2');
define('SECURE_AUTH_SALT', 'S*O?o-$6:;<9x/d0|[v=MW!y.BA8w}P~b-#rd5VtmW .eXJYORd{*@K,[+[X68!1');
define('LOGGED_IN_SALT',   '4~t)q26nkJqU!X|d]=`wJ+YOr_euUFC&<)9NE2cPDTr5;?OQbC26gHAI$K_Yx/*C');
define('NONCE_SALT',       'AK@3kp)sq2^H7hMt;A*d,@@tSo5_Ydj&wyRgTS6HhHQq-kO2FHQIpBqG{;P<Vq!y');

/* Disable all file change, as RPM base installation are read-only */
define('DISALLOW_FILE_MODS', false);
  
/* Disable automatic updater, in case you want to allow
   above FILE_MODS for plugins, themes, ... */
define('AUTOMATIC_UPDATER_DISABLED', false);

```

