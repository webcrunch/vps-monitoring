# Infrastructure Observability Stack

[🇸🇪 Svenska](#-svenska) | [🇬🇧 English](#-english)

---

## 🇸🇪 Svenska

En centraliserad monitorerings- och loggningsstack byggd med **Docker Compose**, **Prometheus**, **cAdvisor** och **Grafana**. Detta projekt ger full synlighet och prestandamätning (CPU, minne, nätverk och disk) för alla fristående containers som körs på en self-hosted VPS – helt utan att kräva kodändringar i de existerande applikationerna.

### 🏗️ Arkitektur
* **cAdvisor:** Analyserar och exporterar resursanvändning från alla rullande containers på servern genom att läsa av Docker-demonen i read-only-läge.
* **Prometheus:** En tidsdatabas som hämtar (skrapar) mätvärden från cAdvisor var 15:e sekund.
* **Grafana:** Visualiseringslagret som kopplas till Prometheus för att rita upp interaktiva realtids-dashboards.

### 🔒 Inget är öppet mot internet
Alla tre portar är bundna till `127.0.0.1`. Docker går förbi brandväggen (ufw) för publicerade portar, så en port utan `127.0.0.1:` är öppen för alla. Nå dem via en SSH-tunnel.

### 🚀 Kom igång snabbt
1. Klona repot till din VPS.
2. Kör `docker compose up -d`.
3. Öppna en SSH-tunnel (`ssh -L 3000:127.0.0.1:3000 user@server`) och logga in på Grafana på http://localhost:3000. Byt admin-lösenordet direkt (standard är admin/admin). Lägg till Prometheus (`http://prometheus:9090`) som datakälla och importera dashboard ID `14282`.

---

## 🇬🇧 English

A centralized, production-ready monitoring and logging stack built with **Docker Compose**, **Prometheus**, **cAdvisor**, and **Grafana**. This project provides global resource visibility and performance metrics across all standalone containers running on a self-hosted VPS, without requiring code modifications to existing applications.

### 🏗️ Architecture
* **cAdvisor (Container Advisor):** Analyzes and exposes resource usage and performance characteristics of all running containers.
* **Prometheus:** A time-series database that scrapes metrics from cAdvisor at regular intervals (15s).
* **Grafana:** The visualization layer that connects to Prometheus to render real-time, interactive dashboards.

### 🔒 Nothing is open to the internet
All three ports are bound to `127.0.0.1`. Docker bypasses the host firewall (ufw) for published ports, so a port without `127.0.0.1:` is open to everyone. Reach them through an SSH tunnel.

### 🚀 Quick Start
1. Clone the repository to your VPS.
2. Run `docker compose up -d`.
3. Open an SSH tunnel (`ssh -L 3000:127.0.0.1:3000 user@server`) and log in to Grafana at http://localhost:3000. Change the admin password at once (the default is admin/admin). Add Prometheus (`http://prometheus:9090`) as a data source, and import dashboard ID `14282`.

---