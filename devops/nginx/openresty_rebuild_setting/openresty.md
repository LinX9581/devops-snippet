
wget -qO - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/openresty.list
sudo apt-get update
sudo apt-get install openresty
sudo apt-get install openresty-opm openresty-resty
sudo systemctl start openresty
sudo systemctl status openresty

/usr/local/openresty/nginx/sbin/nginx -V

sudo /usr/local/openresty/nginx/sbin/nginx -t
sudo systemctl restart openresty

/etc/openresty/nginx.conf