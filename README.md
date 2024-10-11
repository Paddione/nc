# Nextcloud Container Setup Guide

Diese Anleitung beschreibt, wie ein Nextcloud-Container aufgesetzt wird. Die Konfiguration umfasst das Anlegen eines neuen Benutzers, die Anpassung der SSH-Einstellungen, die Installation von Docker und weitere Schritte. Bitte folgen Sie den Anweisungen Schritt für Schritt.

## 1. Neuer Benutzer anlegen: Patrick
Loggen Sie sich als Root-Benutzer ein und führen Sie die folgenden Schritte aus, um einen neuen Benutzer "patrick" zu erstellen:

```bash
adduser patrick
```
Sie werden aufgefordert, ein Passwort für den neuen Benutzer zu vergeben.

Geben Sie dem Benutzer "patrick" sudo-Rechte:

```bash
usermod -aG sudo patrick
```

## 2. SSH-Konfiguration anpassen
Ändern Sie die SSH-Konfiguration so, dass sich der Root-Benutzer nicht mehr per SSH anmelden kann, aber "patrick" sich mit seinem Passwort anmelden kann.

Bearbeiten Sie die Datei `/etc/ssh/sshd_config`:

```bash
nano /etc/ssh/sshd_config
```

Suchen Sie die folgenden Zeilen und ändern Sie sie wie folgt:

```bash
PermitRootLogin no
PasswordAuthentication yes
```

Speichern Sie die Datei und starten Sie den SSH-Dienst neu:

```bash
systemctl restart sshd
```

## 3. Sudo-Passworteingabe für Patrick deaktivieren
Damit der Benutzer "patrick" nicht ständig sein Passwort bei Verwendung von `sudo` eingeben muss, bearbeiten Sie die Sudoers-Datei:

```bash
visudo
```

Fügen Sie folgende Zeile am Ende der Datei hinzu:

```bash
patrick ALL=(ALL) NOPASSWD:ALL
```

Speichern und beenden Sie die Datei.

## 4. Abmelden und als Patrick einloggen
Melden Sie sich jetzt ab und loggen Sie sich als Benutzer "patrick" ein:

```bash
logout
```

Loggen Sie sich dann mit dem Benutzer "patrick" und seinem Passwort ein. Ab jetzt sollten alle Befehle mit `sudo` ausgeführt werden.

## 5. Docker installieren
Führen Sie die folgenden Schritte aus, um Docker zu installieren:

1. Aktualisieren Sie die Paketlisten:

   ```bash
   sudo apt update
   ```

2. Installieren Sie die erforderlichen Pakete:

   ```bash
   sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
   ```

3. Fügen Sie den Docker GPG-Schlüssel hinzu:

   ```bash
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   ```

4. Fügen Sie das Docker-Repository hinzu:

   ```bash
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   ```

5. Aktualisieren Sie erneut die Paketlisten und installieren Sie Docker:

   ```bash
   sudo apt update
   sudo apt install docker-ce -y
   ```

6. Stellen Sie sicher, dass "patrick" Docker-Befehle ohne `sudo` ausführen kann, indem Sie ihn zur Docker-Gruppe hinzufügen:

   ```bash
   sudo usermod -aG docker patrick
   ```

7. Melden Sie sich ab und wieder an, damit die Änderungen wirksam werden:

   ```bash
   logout
   ```

   Loggen Sie sich wieder als "patrick" ein.

## 6. Nextcloud-Container starten
Führen Sie die folgenden Schritte aus, um einen Nextcloud-Container zu starten:

1. Erstellen Sie ein Verzeichnis für die Nextcloud-Daten:

   ```bash
   mkdir ~/nextcloud_data
   ```

2. Starten Sie den Nextcloud-Container mit Docker:

   ```bash
   docker run -d -p 8080:80 -v ~/nextcloud_data:/var/www/html/data --name nextcloud_container nextcloud
   ```

3. Öffnen Sie einen Browser und geben Sie die IP-Adresse Ihres Servers sowie den Port 8080 ein, um auf die Nextcloud-Oberfläche zuzugreifen:

   ```
   http://<server-ip>:8080
   ```

   Folgen Sie den Anweisungen zur Einrichtung.

## 7. Firewall konfigurieren (optional)
Falls eine Firewall aktiviert ist, müssen Sie den Port 8080 freigeben, damit Nextcloud erreichbar ist:

```bash
sudo ufw allow 8080/tcp
```

## 8. Automatisches Starten des Containers (optional)
Damit der Nextcloud-Container bei jedem Neustart des Systems automatisch startet, können Sie folgendes Kommando verwenden:

```bash
sudo docker update --restart unless-stopped nextcloud_container
```

## 9. Abschluss
Die Nextcloud-Instanz sollte jetzt erfolgreich eingerichtet und über den Browser erreichbar sein. Patrick hat alle notwendigen Rechte, um Docker und Systembefehle ohne Einschränkung auszuführen.

Wenn Sie Fragen oder Probleme haben, zögern Sie nicht, nach weiterer Hilfe zu suchen oder zusätzliche Konfigurationsoptionen zu erkunden.

