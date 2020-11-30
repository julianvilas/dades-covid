# Grafana Dashboard for Salut/Dades COVID

The Catalonia Government (Generalitat de Catalunya) [publishes](https://dadescovid.cat) COVID-19 data in a regular basis. This repository provides a Docker service (orchestrated with [Docker Compose](https://docs.docker.com/compose/)) that automates the download of the data feeding a Grafana dashboard with some metrics:

* 14-day Cumulative Incidence
* Outbreak Risk
* Disease Reproduction Rate
* Cases
* Hospilatized vs. ICU vs. Deaths

To run the service (pre-requisites Docker and Docker Compose) just clone the repo and run:
```
docker-compose up
```

After all the metrics are pushed log into Grafana (http://localhost:3000) using the default credentials (admin/admin) and check the Dades Covid Dashboard.

![Dades Covid Dashboard](https://github.com/julianvilas/dades-covid/blob/master/dashboard.jpg?raw=true)
