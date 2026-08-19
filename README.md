# Aufbau und Administration einer virtuellen Unternehmens-IT-Infrastruktur


## Projektübersicht 

Ziel des Projektes war es, praktische Kenntnisse in den Bereichen Systemadministration in Linux und Windows, 
Netzwerke, Virtualisierung, Containerisierung mit Docker, Backup und Skripting anzuwenden. 

Die Infrastruktur wurde lokal in VMware schrittweise aufgebaut.


## Infrastruktur

| Name | Betriebssystem | Funktion |
|:---:|:---:|:---:|
| DC-01 | Windows Server 2022 | Domain Controller / DNS |
| Client-01 | Windows 11 Pro | Domänen-Client |
| APP-01 | Ubuntu Server 24.04 LTS | Applikations- und Monitoringserver |
| BACKUP-01 | Ubuntu Server 24.04 LTS | Backupserver |


## Verwendete Technologien

- VMware
- Windows Server
- Active Directory
- DNS
- Ubuntu Server
- SSH
- Bash
- Powershell
- Docker
- Portainer
- Prometheus
- Node Exporter
- Grafana
- rsync


## Projektbereiche

### Windows Server 2022 

Aufbau eines Domain Controllers mit Active Directory Domain Services,
DNS, Benutzer- und Gruppenverwaltung sowie eine automatische Gruppenorientierte Ordnerfreigabe. 

Zusätzlich: ein selbst geschriebenes Powershell Skript, welches das erstellen von Benutzern vereinfacht. [Siehe "Create-User.ps1"]
 
### Linux Administration

Administration von Ubuntu Server über die Kommandozeile, 
einschließlich Netzwerk, DNS, SSH, Dateisystemen und Berechtigungen.

### Containerisierung & Monitoring

Aufbau einer Docker Umgebung mit Docker-Compose und Portainer.

Für das Monitoring wurden Node Exporter, Prometheus und Grafana eingesetzt.

### Backup & Automatisierung

Aufbau eines Backupservers und automatisierte Sicherung
der Docker Umgebung von APP-01 mittels rsync, Bash und systemd.


## Dokumentation

Eine ausführlichere Projektdokumentation und Skripte befinden sich in den 
entsprechenden Verzeichnissen dieses Repositories.













