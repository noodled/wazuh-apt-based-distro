# wazuh-apt-based-distro

wazuh-apt-based-distro
based on original ALL-IN-ONE step-by-step guide (unattended is for yum based distros)
https://documentation.wazuh.com/current/installation-guide/open-distro/all-in-one-deployment/all-in-one.html
created 2022march07
Log4J workaround Dec2021 included

order to run :
 wazuh-unattended-APT-installation.sh 
 owlhsuricata508.sh
 owlhzeek420.sh 
 set-ufw-4-elk.sh
OR
mkdir -p /download && pushd /download && wget "https://raw.githubusercontent.com/noodled/wazuh-apt-based-distro/main/generate-full-wazuh-install-launcher.sh" -O generate-full-wazuh-install-launcher.sh
echo then launch via
bash /download/generate-full-wazuh-install-launcher.sh
# and have patience 4 core 100+ GB SSD disk and min 12 GB RAM !!



