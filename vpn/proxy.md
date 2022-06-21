apt install squid -y

/etc/squid/squid.conf
acl Safe_ports port 443		# https
#acl our_networks src 0.0.0.0/0
acl all_networks src all
http_access allow all_networks

sudo /etc/init.d/squid restart
