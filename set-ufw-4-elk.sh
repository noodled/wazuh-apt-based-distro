# ELK simple rules
#sudo ufw allow 9200
#sudo ufw allow 5044
#sudo ufw allow 8888
#sudo ufw allow 5010
IPSUBN=`ip addr | grep "inet " | awk '{print $2}' | tail -1`
IPSUBN=10.20.30.0/24
# route -4 | grep -v -e'vmnet*.' -e'docker*.' -e'link-local' -e'default'
NETWid=`route -4 | grep -vE  'vmnet*.|docker*.|link-local|default' | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" | head -1`
SNMask=`route -4 | grep -vE  'vmnet*.|docker*.|link-local|default' | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" | tail -1`
CIDR=${SNMask/#255.255.255.252/30}
CIDR=${SNMask/#255.255.255.224/27}
CIDR=${SNMask/#255.255.255.128/25}
CIDR=${SNMask/#255.255.255.0/24}
CIDR=${SNMask/#255.255.254.0/23}
CIDR=${SNMask/#255.255.252.0/22}
CIDR=${SNMask/#255.255.248.0/21}
CIDR=${SNMask/#255.255.240.0/20}
CIDR=${SNMask/#255.255.224.0/19}
CIDR=${SNMask/#255.255.192.0/18}
CIDR=${SNMask/#255.255.128.0/17}
CIDR=${SNMask/#255.255.0.0/16}
echo $NETWid '/' $SNMask in CIDR $NETWid '/' $CIDR
echo $IPSUBN
IPSUBN=$NETWid/$CIDR
echo allowing tcp 53 for dns secure further with tcpd
sudo ufw allow 53/tcp
sudo ufw deny 53/udp
# allow tcp 80
sudo ufw allow 80/tcp
sudo ufw deny 80/udp
sudo ufw allow 123/tcp
sudo ufw deny 123/udp
sudo ufw allow from $IPSUBN to any port 443 proto tcp
echo udp 443 for mosh  secure with tcpd
sudo ufw allow 443/udp
echo allowing squid proxy 3128 and 8080 to this subnet only $IPSUBN
sudo ufw allow from $IPSUBN to any port 3128 proto tcp
sudo ufw allow from $IPSUBN to any port 8080 proto tcp
echo ELK allowed to this own subnet only $IPSUBN
sudo ufw allow from $IPSUBN to any port 9200 proto tcp
sudo ufw allow from $IPSUBN to any port 9200 proto tcp
sudo ufw allow from $IPSUBN to any port 5044 proto tcp
sudo ufw allow from $IPSUBN to any port 8888 proto tcp
sudo ufw allow from $IPSUBN to any port 5010 proto tcp
#sudo /opt/bitnami/apache2/bin/htpasswd -c /opt/bitnami/elasticsearch/apache-conf/password user
sleep 20