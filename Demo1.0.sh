#!/bin/sh
set -e
set -x
sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
cd /opt
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
sudo tar -xvf prometheus-2.26.0.linux-amd64.tar.gz
cd prometheus-2.26.0.linux-amd64
sudo cp /opt/prometheus-2.26.0.linux-amd64/prometheus /usr/local/bin/
sudo cp /opt/prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo cp -r /opt/prometheus-2.26.0.linux-amd64/consoles /etc/prometheus
sudo cp -r /opt/prometheus-2.26.0.linux-amd64/console_libraries /etc/prometheus
sudo cp -r /opt/prometheus-2.26.0.linux-amd64/prometheus.yml /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown -R prometheus:prometheus /etc/prometheus/prometheus.yml
sudo -u prometheus /usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml  --storage.tsdb.path /var/lib/prometheus  --web.console.templates=/etc/prometheus/consoles   --web.console.libraries=/etc/prometheus/console_libraries
sudo wget https://servermonitoring.s3.amazonaws.com/Prometheusconf.txt
sudo mv Prometheusconf.txt /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.2.0/node_exporter-1.2.0.linux-amd64.tar.gz
sudo tar xvzf node_exporter-1.2.0.linux-amd64.tar.gz
cd node_exporter-1.2.0.linux-amd64
sudo cp node_exporter /usr/local/bin
cd /lib/systemd/system
sudo wget https://servermonitoring.s3.amazonaws.com/NodeExporterConf.txt
sudo mv NodeExporterConf.txt  /lib/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo apt-get update
cd /tmp
sudo wget https://dl.grafana.com/oss/release/grafana_8.5.3_amd64.deb
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_8.5.3_amd64.deb
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
