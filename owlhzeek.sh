# Zeek
# Main packages 
sudo apt-get install -y cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev git libnss3-dev liblua5.1-dev libnspr4-dev liblz4-dev python3-yaml
mkdir -p /download
cd /download
apt-get install -y python3-dev libpcap0.8-dev libcaf-dev librocksdb-dev
wget https://download.zeek.org/zeek-4.2.0.tar.gz
#wget https://old.zeek.org/downloads/zeek-3.0.3.tar.gz
#tar xzvf zeek-3.0.3.tar.gz
tar xzvf zeek-4.2.0.tar.gz
cd /download/zeek-4.2.0
rm -f build/CMakeCache.txt 
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
rm -f build/CMakeCache.txt
make distclean
## ./configure --with-rocksdb=/usr/local/lib/librocksdb.so
./configure
make -j $NUMPROC
sudo make install


if [ ! -d "/usr/local/zeek" ]; then
    echo -e "\e[91mThere was a problem installing Zeek, /usr/local/zeek path doesn't exist\e[0m"
    exit 1
fi

cat >> /usr/local/zeek/share/zeek/site/local.zeek <<\EOF
@load policy/tuning/json-logs.zeek
@load owlh.zeek
EOF

cat >> /usr/local/zeek/share/zeek/site/owlh.zeek <<\EOF
redef record DNS::Info += {
    bro_engine:    string    &default="DNS"    &log;
};
redef record Conn::Info += {
    bro_engine:    string    &default="CONN"    &log;
};
redef record Weird::Info += {
    bro_engine:    string    &default="WEIRD"    &log;
};
redef record SSL::Info += {
    bro_engine:    string    &default="SSL"    &log;
};
redef record SSH::Info += {
    bro_engine:    string    &default="SSH"    &log;
};
EOF

/usr/local/zeek/bin/zeekctl deploy

(sudo crontab -l ; echo "*/5 * * * * /usr/local/zeek/bin/zeekctl cron ") | crontab -

