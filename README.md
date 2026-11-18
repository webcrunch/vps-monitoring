# Infrastructure Observability Stack

[🇸🇪 Svenska](#-svenska) | [🇬🇧 English](#-english)

---

## 🇸🇪 Svenska

En centraliserad monitorerings- och loggningsstack byggd med **Docker Compose**, **Prometheus**, **cAdvisor**, **Grafana**, **Loki** och **Promtail**. Den ger full synlighet och prestandamätning (CPU, minne, nätverk och disk) och samlar loggarna från alla containers på en self-hosted VPS, utan kodändringar i de existerande applikationerna.

### 🏗️ Arkitektur
* **cAdvisor:** Läser resursanvändningen för alla containers på servern från Docker-demonen, i read-only-läge.
* **Prometheus:** En tidsdatabas som hämtar (skrapar) mätvärden var 5:e sekund: från sig själv, från cAdvisor och från predictor-appen (`predictor_api_prod:8000` via `traefik-net`).
* **Loki:** Lagrar loggarna. Som Prometheus fast för loggrader.
* **Promtail:** Läser varje containers loggfil och skickar raderna till Loki.
* **Grafana:** Ritar dashboards från Prometheus (mätvärden) och Loki (loggar).

### 🔒 Inget är öppet mot internet
Alla portar är bundna till `127.0.0.1`. Docker går förbi brandväggen (ufw) för publicerade portar, så en port utan `127.0.0.1:` är öppen för alla. Nå dem via en SSH-tunnel. CI stoppar en port som inte är bunden till `127.0.0.1`.

### 🔁 CI/CD
* **CI** (varje PR): compose-filen och Prometheus-configen kontrolleras, och ingen port får vara publik.
* **Deploy** (Actions → Deploy → Run workflow): kopierar filerna till `/home/vps-monitoring` med SSH-uppgifter från Vault, startar om stacken, kontrollerar att allt svarar (annars rullas den tillbaka) och att ingen port svarar utifrån.

### 🚀 Kom igång
1. Klona repot till din VPS (nätverket `traefik-net` måste finnas).
2. Kör `docker compose up -d`.
3. Öppna en SSH-tunnel (`ssh -L 3000:127.0.0.1:3000 user@server`) och logga in på Grafana på http://localhost:3000. Byt admin-lösenordet direkt (standard är admin/admin). Lägg till Prometheus (`http://prometheus:9090`) och Loki (`http://loki:3100`) som datakällor och importera dashboard ID `14282`.

---

## 🇬🇧 English

A centralized monitoring and logging stack built with **Docker Compose**, **Prometheus**, **cAdvisor**, **Grafana**, **Loki**, and **Promtail**. It provides resource visibility and performance metrics across all standalone containers on a self-hosted VPS, and collects their logs, without code changes to the existing applications.

### 🏗️ Architecture
* **cAdvisor (Container Advisor):** Reads resource usage of all running containers from the Docker daemon, read-only.
* **Prometheus:** A time-series database that scrapes metrics every 5 seconds: itself, cAdvisor, and the predictor app (`predictor_api_prod:8000` over `traefik-net`).
* **Loki:** Stores the logs. Like Prometheus, but for log lines.
* **Promtail:** Tails each container's log file and ships the lines to Loki.
* **Grafana:** Renders dashboards from Prometheus (metrics) and Loki (logs).

### 🔒 Nothing is open to the internet
All ports are bound to `127.0.0.1`. Docker bypasses the host firewall (ufw) for published ports, so a port without `127.0.0.1:` is open to everyone. Reach them through an SSH tunnel. CI refuses a port that is not bound to `127.0.0.1`.

### 🔁 CI/CD
* **CI** (every PR): the compose file and the Prometheus config are validated, and no port may be public.
* **Deploy** (Actions → Deploy → Run workflow): copies the files to `/home/vps-monitoring` with SSH credentials from Vault, restarts the stack, checks that everything answers (rolling back if not), and that no port answers from outside.

### 🚀 Quick Start
1. Clone the repository to your VPS (the `traefik-net` network must exist).
2. Run `docker compose up -d`.
3. Open an SSH tunnel (`ssh -L 3000:127.0.0.1:3000 user@server`) and log in to Grafana at http://localhost:3000. Change the admin password at once (the default is admin/admin). Add Prometheus (`http://prometheus:9090`) and Loki (`http://loki:3100`) as data sources, and import dashboard ID `14282`.

---
