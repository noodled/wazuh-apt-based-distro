echo install Serverside WAZUH-Suricata Reworked for APT based distros Linux ubuntu20.04 LTS and Mint 20.x Debian11
mkdir -p /download
pushd /download
## centos only  echo Unattended installation all-in-one deployment
## for centos   curl -so ~/unattended-installation.sh https://packages.wazuh.com/resources/4.2/open-distro/unattended-installation/unattended-installation.sh && bash ~/unattended-installation.sh
echo wazuh server all-in-one manual APT-distro installation
curl https://packages.wazuh.com/resources/4.2/open-distro/unattended-installation/unattended-installation.sh -so unattended-installation.sh
apt install curl apt-transport-https unzip wget libcap2-bin software-properties-common lsb-release gnupg
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update
apt-get install wazuh-manager
systemctl daemon-reload
systemctl enable wazuh-manager
systemctl start wazuh-manager
systemctl status wazuh-manager
apt install elasticsearch-oss opendistroforelasticsearch
curl -so /etc/elasticsearch/elasticsearch.yml https://packages.wazuh.com/resources/4.2/open-distro/elasticsearch/7.x/elasticsearch_all_in_one.yml
curl -so /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/roles.yml https://packages.wazuh.com/resources/4.2/open-distro/elasticsearch/roles/roles.yml
curl -so /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/roles_mapping.yml https://packages.wazuh.com/resources/4.2/open-distro/elasticsearch/roles/roles_mapping.yml
curl -so /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/internal_users.yml https://packages.wazuh.com/resources/4.2/open-distro/elasticsearch/roles/internal_users.yml
rm /etc/elasticsearch/esnode-key.pem /etc/elasticsearch/esnode.pem /etc/elasticsearch/kirk-key.pem /etc/elasticsearch/kirk.pem /etc/elasticsearch/root-ca.pem -f
curl -so ~/wazuh-cert-tool.sh https://packages.wazuh.com/resources/4.2/open-distro/tools/certificate-utility/wazuh-cert-tool.sh
curl -so ~/instances.yml https://packages.wazuh.com/resources/4.2/open-distro/tools/certificate-utility/instances_aio.yml
bash ~/wazuh-cert-tool.sh
mkdir /etc/elasticsearch/certs/
mv ~/certs/elasticsearch* /etc/elasticsearch/certs/
mv ~/certs/admin* /etc/elasticsearch/certs/
cp ~/certs/root-ca* /etc/elasticsearch/certs/
mkdir -p /etc/elasticsearch/jvm.options.d
echo '-Dlog4j2.formatMsgNoLookups=true' > /etc/elasticsearch/jvm.options.d/disabledlog4j.options
chmod 2750 /etc/elasticsearch/jvm.options.d/disabledlog4j.options
chown root:elasticsearch /etc/elasticsearch/jvm.options.d/disabledlog4j.options
systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch
export JAVA_HOME=/usr/share/elasticsearch/jdk/ && /usr/share/elasticsearch/plugins/opendistro_security/tools/securityadmin.sh -cd /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/ -nhnv -cacert /etc/elasticsearch/certs/root-ca.pem -cert /etc/elasticsearch/certs/admin.pem -key /etc/elasticsearch/certs/admin-key.pem
curl -XGET https://localhost:9200 -u admin:admin -k
/usr/share/elasticsearch/bin/elasticsearch-plugin remove opendistro-performance-analyzer
curl -so /etc/filebeat/filebeat.yml https://packages.wazuh.com/resources/4.2/open-distro/filebeat/7.x/filebeat_all_in_one.yml
curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/4.2/extensions/elasticsearch/7.x/wazuh-template.json
chmod go+r /etc/filebeat/wazuh-template.json
curl -s https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.1.tar.gz | tar -xvz -C /usr/share/filebeat/module
mkdir /etc/filebeat/certs
cp ~/certs/root-ca.pem /etc/filebeat/certs/
mv ~/certs/filebeat* /etc/filebeat/certs/
systemctl daemon-reload
systemctl enable filebeat
systemctl start filebeat
filebeat test output
apt-get install opendistroforelasticsearch-kibana
curl -so /etc/kibana/kibana.yml https://packages.wazuh.com/resources/4.2/open-distro/kibana/7.x/kibana_all_in_one.yml
mkdir /usr/share/kibana/data
chown -R kibana:kibana /usr/share/kibana/data
cd /usr/share/kibana
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/4.x/ui/kibana/wazuh_kibana-4.2.5_7.10.2-1.zip
mkdir /etc/kibana/certs
cp ~/certs/root-ca.pem /etc/kibana/certs/
mv ~/certs/kibana* /etc/kibana/certs/
chown kibana:kibana /etc/kibana/certs/*
setcap 'cap_net_bind_service=+ep' /usr/share/kibana/node/bin/node
systemctl daemon-reload
systemctl enable kibana
systemctl start kibana
echo https://wazuh_server_ip
echo user: admin
echo password: admin