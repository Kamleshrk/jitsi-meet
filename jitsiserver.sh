#! /bin/sh
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
sudo apt install -y gnupg
sudo apt install -y openjdk-8-jre-headless
echo "JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" | sudo tee -a /etc/profile
source /etc/profile
sudo ufw enable -y
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y nginx
sudo systemctl start nginx.service
sudo systemctl enable nginx.service
sudo apt update -y
sudo apt upgrade -y
cd
wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | sudo apt-key add -
sudo sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list"
sudo apt update -y
sudo apt install -y jitsi-meet
sudo /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
sed -i '$d' /etc/jitsi/videobridge/sip-communicator.properties
echo 'org.jitsi.videobridge.DISABLE_TCP_HARVESTER=true' >> /etc/jitsi/videobridge/sip-communicator.properties
echo 'org.jitsi.videobridge.xmpp.user.shard.DISABLE_CERTIFICATE_VERIFICATION=true' >> /etc/jitsi/videobridge/sip-communicator.properties
echo 'org.jitsi.videobridge.xmpp.user.shard.MUC_NICKNAME=jvb1' >> /etc/jitsi/videobridge/sip-communicator.properties
sed -i -e 's/JVB_OPTS="--apis=,"/JVB_OPTS="--apis=rest,xmpp"/g' /etc/jitsi/videobridge/config 
sed -i -e 's/muc/muc,colibri/g' /etc/jitsi/videobridge/sip-communicator.properties
service jitsi-videobridge2 restart
sed 's/JVB_OPTS="--apis=,"/JVB_OPTS="--apis=rest,xmpp"/g' /etc/jitsi/videobridge/config
echo "Jitsi installation completed, rebooting system now..."
sleep 5
reboot