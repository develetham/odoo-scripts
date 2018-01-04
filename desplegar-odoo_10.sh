#!/bin/bash

# Script for Installation: Odoo 8 server on Debian/Ubuntu
# Based loosely on a script by André Schenkels, ICTSTUDIO 2014
# https://github.com/aschenkels-ictstudio/odoo-install-scripts/blob/master/debian-7/odoo_install.sh
# Rebuilt by Alfredo Sola for Debian 8 and Ubuntu 16.04
# Re-rebuit by Alfredo & Luis Gomez for Debian 9 and Ubunt 16.04 for Odoo 9.0

# Sugerencia gratis by Alfredo Sola <<-- Muy, pero que muy bien!
if [ "$TERM" == "xterm-color" ]; then
 # Cosas Bonitas para el Script
 ROJO='\033[0;31m'
 SROJO='\033[1;31m'
 VERDE='\033[0;32m'
 NC='\033[0m'
else
 ROJO=""
 SROJO=""
 VERDE=""
 NC=""
fi

#Preparamos el archivo de log de instalación
mkdir /var/log/stromic
log_time=`date +%Y%m%d_%H%M%S`
log_file="/var/log/stromic/desplegar_odoo.log"
echo "Se crea archivo de log en ${ROJO} ${log_file} ${NC}" 2>&1 | tee -a $log_file


if [[ $EUID -ne 0 ]] ; then
   echo "${ROJO} ACHTUNG! ESTE SCRIPT DEBE EJECUTARSE COMO root ${NC}"
   exit 1
fi

Distro=`awk -F= '/^ID=/{print $2}' /etc/os-release`
Servidor=`hostname -f`
Odoo_NAME="odoo"
Odoo_ADDONS="/usr/lib/python2.7/dist-packages/openerp/addons"
Odoo_ADDONS_EXTRA="${Odoo_ADDONS}-extra"
# Enter Odoo version for checkout: "9.0" "8.0" for version 8.0, "7.0 (version 7), saas-4, saas-5 (opendays version) and "master" for trunk
Odoo_VERSION="10.0"
echo "---> ${ROJO} Vamos a Instalar Odoo versión ${Odoo_VERSION} Sobre ${Distro} en el server ${Servidor} ${NC}" 2>&1 | tee -a $log_file
Odoo_SUPERADMIN="superduperodooer"
Odoo_CONFIG="/etc/odoo/odoo.conf"
Odoo_INIT="/etc/init.d/${Odoo_NAME}"
LOG_Instalacion="Odoo_inst.log"

apt-get update && apt-get -y install apt-transport-https 2>&1 2>&1 | tee -a $log_file
wget -O - https://nightly.odoo.com/odoo.key | apt-key add - | tee - a $log_file
echo "deb https://nightly.odoo.com/10.0/nightly/deb/ ./" > /etc/apt/sources.list.d/odoo.list  

apt-get update
# Utilidades generales:
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections 2>&1 | tee -a $log_file
echo "postfix postfix/mailname string $Servidor" | debconf-set-selections 2>&1 | tee -a $log_file
apt-get -y install git emacs24-nox sudo less postfix fail2ban chrony rsync unattended-upgrades 2>&1 | tee -a $log_file

# La base de patos, y su autovolcado:
apt-get -y install postgresql autopostgresqlbackup 2>&1 | tee -a $log_file
su - postgres -c "createuser -s $Odoo_NAME" 2> /dev/null || true 2>&1 | tee -a $log_file

# Dependencias de Odoo que no estan resueltas en el propio paquete:
echo "---> ${ROJO} INSTALAMOS Dependencias Adicionales Personalización Odoo ${NC}" 2>&1 | tee -a $log_file
apt-get -y install lib64z1-dev fontconfig libfreetype6 libx11-6 libxext-dev libxrender-dev xfonts-75dpi 2>&1 | tee -a $log_file
apt-get -y install libfontenc1 libxfont1 xfonts-75dpi xfonts-base xfonts-encodings xfonts-utils 2>&1 | tee -a $log_file
apt-get -y install python-gdata python-crypto python-unidecode python-unicodecsv python-requests 2>&1 | tee -a $log_file
apt-get -y install libfontconfig1 libpng12-0 libjpeg62-turbo libx11-6 libxext6 libxrender1


# Aplicamos versión compatible de whthmldopdf para Odoo

echo "---> ${ROJO} INSTALAMOS whtmltopdf ${NC}" 2>&1 | tee -a $log_file
if [ "$Distro" = "debian" ] ; then
	wget http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb 2>&1 | tee -a $log_file
	dpkg -i wkhtmltox-0.12.1.2_linux-jessie-amd64.deb 2>&1 | tee -a $log_file
	sudo cp /usr/local/bin/wkhtmlto* /usr/bin/ 2>&1 | tee -a $log_file
elif [ "$Distro" = "ubuntu" ] ; then
	#código no probado en ubuntu
	wget https://downloads.wkhtmltopdf.org/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
	dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb
	sudo cp /usr/local/bin/wkhtmlto* /usr/bin/
fi


# Y, finalmente:
echo "---> ${ROJO} INSTALAMOS Odoo ${NC}" 2>&1 | tee -a $log_file
apt-get -y install odoo 2>&1 | tee -a $log_file

echo "---> ${ROJO} INSTALAMOS Extra Addons Odoo ${NC}" 2>&1 | tee -a $log_file
apt-get -y install unzip 2>&1 | tee -a $log_file
#mkdir $Odoo_ADDONS_EXTRA  ---> Al final lo colocamos en el maestro de addons < - Migrado ver. 9
#cd $Odoo_ADDONS
#git clone --branch $Odoo_VERSION https://github.com/OCA/l10n-spain.git 2>&1 | tee -a $log_file

#wget https://apps.odoo.com/loempia/download/base_location_geonames_import/10.0.1.0.1/61eSvJhe3xXWHteoH7MuUt.zip?deps
#mv 61eSvJhe3xXWHteoH7MuUt.zip?deps base_geonames_import.zip
#unzip base_geonames_import.zip 2>&1 | tee -a $log_file

#Limpiamos los restos
#rm -rf 61eSvJhe3xXWHteoH7MuUt.zip?deps


# Let's Encrypt:
if [ "$Distro" = "debian" ] ; then
	 echo "---> ${ROJO} INSTALAMOS Let's Encrypt para Debian ${NC}" 2>&1 | tee -a $log_file    
    apt-get -y install dehydrated  2>&1 | tee -a $log_file
    echo "${Servidor}" > /etc/dehydrated/domains.txt 2>&1 | tee -a $log_file
    rutaCertificados=/var/lib/dehydrated/certs/${Servidor}
elif [ "$Distro" = "ubuntu" ] ; then
	 echo "---> ${ROJO} INSTALAMOS Let's Encrypt para Ubuntu ${NC}" 2>&1 | tee -a $log_file    
    apt-get -y install letsencrypt 
    letsencrypt certonly 
    rutaCertificados=/etc/letsencrypt/live/${Servidor}
fi

echo "---> ${ROJO} INSTALAMOS Nginx ${NC}" 2>&1 | tee -a $log_file
apt-get -y install nginx 2>&1 | tee -a $log_file
# sed -i "s/db_user = .*/db_user = $Odoo_NAME/g" $Odoo_CONFIG
# sed -i "s/admin_passwd.*/admin_passwd = $Odoo_SUPERADMIN/g" $Odoo_CONFIG
# echo "logfile = /var/log/$Odoo_NAME.log" >> $Odoo_CONFIG
# echo "addons_path=$Odoo_HOME_EXT/addons,$Odoo_HOME/custom/addons" >> $Odoo_CONFIG
 
echo "---> ${ROJO} CONFIGURAMOS Nginx ${NC}" 2>&1 | tee -a $log_file
cat > /etc/nginx/sites-available/${Servidor}.conf << FIN
server {
        listen 80;
	server_name ${Servidor};
	location /.well-known/acme-challenge/ {
      		 alias /var/lib/dehydrated/acme-challenges/;
	}
	location / {
		return 301 https://\$server_name\$request_uri;
	}
}

FIN

if [ -f "/etc/nginx/sites-enabled/${Servidor}.conf" ] ; then
   rm /etc/nginx/sites-enabled/${Servidor}.conf
fi
ln -s /etc/nginx/sites-available/${Servidor}.conf /etc/nginx/sites-enabled/${Servidor}.conf
echo "---> ${ROJO} REINICIAMOS Nginx ${NC}"
service nginx restart 2>&1 | tee -a $log_file


# Renovar Letsencrypt (Debian)
# Este bloque sólo funciona si se ejecuta el script como root. Si no hay que ponerlo a mano
echo "---> ${ROJO} CREAMOS CRON para renovación Letsencrypt ${NC}" 2>&1 | tee -a $log_file
if [ "$Distro" = "debian" ] ; then
	 echo "---> ${ROJO} CREAMOS CRON para renovación Letsencrypt para DEBIAN ${NC}" 2>&1 | tee -a $log_file
    cat > /etc/cron.monthly/renovar-letsencrypt << FIN
#!/bin/dash

/usr/bin/dehydrated -c
FIN
    chmod 755 /etc/cron.monthly/renovar-letsencrypt
    /etc/cron.monthly/renovar-letsencrypt
elif [ "$Distro" = "ubuntu" ] ; then
	 echo "---> ${ROJO} CREAMOS CRON para renovación Letsencrypt para UBUNTU ${NC}" 2>&1 | tee -a $log_file
    cat > /etc/cron.monthly/renovar-letsencrypt << FIN
#!/bin/dash

/usr/sbin/service nginx stop
/usr/bin/letsencrypt renew --agree-tos
/usr/sbin/service nginx start
FIN
fi
chmod 755 /etc/cron.monthly/renovar-letsencrypt

## Fin del bloque que hemos visto que solo se ejecuta bajo root

echo "---> ${ROJO} AÑADIMOS datos para SSL ${NC}" 2>&1 | tee -a $log_file
cat >> /etc/nginx/sites-available/${Servidor}.conf << FIN
upstream odoo {
	server 127.0.0.1:8069;
}

server {
	listen 443 ssl default_server;

	ssl on;
	ssl_certificate         ${rutaCertificados}/cert.pem;
	ssl_certificate_key	${rutaCertificados}/privkey.pem;
	ssl_trusted_certificate	${rutaCertificados}/fullchain.pem;

	server_name ${Servidor};

	location / {
		proxy_pass http://odoo;
	        proxy_set_header Host \$host;
		proxy_set_header X-Real-IP \$remote_addr;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto \$scheme;
      proxy_connect_timeout       1200;
      proxy_send_timeout          1200;
      proxy_read_timeout         20000;
      send_timeout                1200;
	}

}
FIN

echo "---> ${ROJO} REINICIAMOS SERVER NGINX ${NC}" 2>&1 | tee -a $log_file
service nginx restart 2>&1 | tee -a $log_file

echo "---> ${ROJO} DETALLES ULTIMOS de odoo-server.conf" 2>&1 | tee -a $log_file
echo "xmlrpc_interface = 127.0.0.1" >> $Odoo_CONFIG

echo "---> ${ROJO} AHORA AÑADIREMOS EN${NC} ${VERDE} ${Odoo_CONFIG} ${ROJO} LA SIGUIENTE SENTENCIA" 2>&1 | tee -a $log_file
echo "--------> ${VERDE} addonspath=${Odoo_ADDONS}/l10n_es,${Odoo_ADDONS_EXTRA},${Odoo_ADDONS}"

service odoo restart | echo "---> ${ROJO} ARRANCAMOS odoo${NC}" 2>&1 | tee -a $log_file


