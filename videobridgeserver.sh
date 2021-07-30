#! /bin/sh
#video bridge installation
sudo apt update -y
sudo apt upgrade -y
sudo apt install apt-transport-https
sudo  ufw allow ssh 
sudo ufw allow 443/tcp 
sudo ufw allow 4443/tcp 
sudo ufw allow 10000:20000/udp 
sudo ufw allow 5222/tcp
sudo ufw allow OpenSSH
sudo ufw allow http
sudo ufw allow https
sudo ufw allow in 10000:20000/udp
sudo ufw enable -y
echo 'deb https://download.jitsi.org stable/' >> /etc/apt/sources.list.d/jitsi-stable.list
wget -qO -  https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -
sudo apt update -y
sudo apt upgrade -y
apt install jitsi-videobridge2 -y
sed -i '$d' /etc/jitsi/videobridge/sip-communicator.properties
echo 'org.jitsi.videobridge.DISABLE_TCP_HARVESTER=true' >> /etc/jitsi/videobridge/sip-communicator.properties
echo 'org.jitsi.videobridge.xmpp.user.shard.DISABLE_CERTIFICATE_VERIFICATION=true' >> /etc/jitsi/videobridge/sip-communicator.properties
echo 'org.jitsi.videobridge.xmpp.user.shard.MUC_NICKNAME=jvb1' >> /etc/jitsi/videobridge/sip-communicator.properties
echo Please enter nickname for video bridge
read name
sed -i -e s/jvb1/"$name"/g /etc/jitsi/videobridge/sip-communicator.properties
echo Please enter ipaddress for jitsi server
read ip
sed -i -e s/localhost/"$ip"/g /etc/jitsi/videobridge/sip-communicator.properties
sed -i '13d' /etc/jitsi/videobridge/config
echo -e "\n" >> /etc/jitsi/videobridge/config
echo '# sets the shared secret used to authenticate to the XMPP server' >> /etc/jitsi/videobridge/config
echo 'JVB_SECRET=grammer' >> /etc/jitsi/videobridge/config
sed -i '8d' /etc/jitsi/videobridge/sip-communicator.properties
echo 'org.jitsi.videobridge.xmpp.user.shard.PASSWORD=sundirect' >> /etc/jitsi/videobridge/sip-communicator.properties
echo On the Jitsi server, please open the file /etc/jitsi/videobridge/config and find the line JVB_SECRET and enter that value here
read secret
sed -i -e s/grammer/"$secret"/g /etc/jitsi/videobridge/config
sed -i -e s/sundirect/"$secret"/g /etc/jitsi/videobridge/sip-communicator.properties
sed -i -e 's/JVB_OPTS="--apis=,"/JVB_OPTS="--apis=rest,xmpp"/g' /etc/jitsi/videobridge/config 
sed -i -e 's/muc/muc,colibri/g' /etc/jitsi/videobridge/sip-communicator.properties
service jitsi-videobridge2 restart
echo "Jitsi video bridge installation completed, rebooting system now..."
sleep 5
reboot







