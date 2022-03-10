echo this will install WAZUH Suricata owlhzeek
echo This can be very timeconsuming for the compile of Zeek
sleep 180
./wazuh-unattended-APT-installation.sh
./owlhsuricata508.sh
./owlhzeek420.sh
./set-ufw-4-elk.sh
