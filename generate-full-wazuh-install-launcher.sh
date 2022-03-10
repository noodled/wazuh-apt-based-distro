mkdir -p /download
pushd /download
wget https://raw.githubusercontent.com/noodled/wazuh-apt-based-distro/main/wazuh-unattended-APT-installation.sh -O wazuh-unattended-APT-installation.sh
wget https://raw.githubusercontent.com/noodled/wazuh-apt-based-distro/main/owlhsuricata508.sh -O owlhsuricata508.sh
wget https://raw.githubusercontent.com/noodled/wazuh-apt-based-distro/main/owlhzeek420.sh -O owlhzeek420.sh
wget https://raw.githubusercontent.com/noodled/wazuh-apt-based-distro/main/set-ufw-4-elk.sh -O set-ufw-4-elk.sh
ufw disable
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install -y build-essential gcc g++ make cmake flex bison mc nmap openssh-server fail2ban dos2unix
echo -e "withing 3 min WAZUH Suricata owlhzeek will install" > inst-fullwazuh.sh
echo -e "This can be very timeconsuming for the compile of Zeek" >> inst-fullwazuh.sh
echo -e "sleep 180" >> inst-fullwazuh.sh
echo -e "wazuh-unattended-APT-installation.sh" >> inst-fullwazuh.sh
echo -e "owlhsuricata508.sh" >> inst-fullwazuh.sh
echo -e "owlhzeek420.sh" >> inst-fullwazuh.sh
echo -e "set-ufw-4-elk.sh" >> inst-fullwazuh.sh
dos2unix /download/*.sh
chmod og+rx /download/*.sh
echo it is recommended to reboot now
echo This machines curreny IP addr is :
hostname -I
echo after reboot launch /download/inst-fullwazuh.sh
