#!/bin/bash

# Script para la instalación de los módulos esenciales
# para una funcionamiento molón del Odoo.
# Desarrollado por etham 
# twitter :: @wearestromic
# Diciembre 2017

# Algo de Florituras. Le damos color
#
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

# Averiguamos en que distro estamos trabajando.
#
Distro=`awk -F= '/^ID=/{print $2}' /etc/os-release`

# Capturamos el nombre del server
#
Servidor=`hostname -f`

# Trabajamos para Odoo
#
Odoo_VERSION="10.0"
Odoo_Addons_Raw="/opt/odoo"
Odoo_Addons_Base="$Odoo_Addons_Raw/extra-addons"
Odoo_Addons_Path="addonspath="

# Odoo tiene sus directorios en
#
Odoo_CONFIG="/etc/odoo/odoo.conf"

# Al turrón.
# Primero necesitamos el directorio donde alojar todos los downloads.
## Comprobamos si existe el directorio raiz

if [ ! -d "$Odoo_Addons_Raw" ]; then
  # Lo creamos
  echo "## No existe el directorio $Odoo_Addons_Raw y lo creamos ##"
  mkdir $Odoo_Addons_Raw
  mkdir $Odoo_Addons_Raw/extra-addons 
elif [ ! -d "$Odoo_Addons_Base" ]; then
	# Creamos extra-addons	
	echo "## No existe el directorio $Odoo_Addons_Raw/extra-addons"
	mkdir $Odoo_Addons_Base 
fi

## Herramientas que nos hacen falta
#
apt-get update
apt-get -y install python-pip

## Actualizamos Pip. Suele venir bastante obsoleto.
#
pip install --upgrade pip

## Instalamos setuptools. Lo necesitan las dependencias de los requerimientos.
#
sudo pip install -U setuptools



# Empezamos por los repositorios de la OCA
#
cd $Odoo_Addons_Base
## Módulos de la OCA
echo "## Instalando Módulos OCA ##"
## Localización es
git clone -b $Odoo_VERSION https://github.com/OCA/l10n-spain.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/l10n-spain"
cd ./l10n-spain
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base
## Server Tools
git clone -b $Odoo_VERSION https://github.com/OCA/server-tools.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/server-tools"
cd ./server-tools
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base
## WebSite
git clone -b $Odoo_VERSION https://github.com/OCA/website.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/website"
cd ./website
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base
## Web
git clone -b $Odoo_VERSION https://github.com/OCA/web.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/web"
cd ./web
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base
## Social
git clone -b $Odoo_VERSION https://github.com/OCA/social.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/social"
cd ./social
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base
## e-commerce
git clone -b $Odoo_VERSION https://github.com/OCA/e-commerce.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/e-commerce"
cd ./e-commerce
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base
## product-attribute
git clone -b $Odoo_VERSION https://github.com/OCA/product-attribute.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/product-attribute"
cd ./product-attribute
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base
## Partner-Contact
git clone -b $Odoo_VERSION https://github.com/OCA/partner-contact.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/partner-contact"
cd ./partner-contact
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base
## Bank Payment
git clone -b $Odoo_VERSION https://github.com/OCA/bank-payment.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/bank-payment"
cd ./bank-payment
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base

## account-reporting
git clone -b $Odoo_VERSION https://github.com/OCA/account-financial-reporting.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/account-financial-reporting"
cd ./account-financial-reporting
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base
## Módulos Third Party (mola ponerlo asi)

## MUK Addons -- Cositas bonitas para la web
git clone -b $Odoo_VERSION https://github.com/muk-it/muk_web.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/muk_web"
cd ./muk_web
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base

## Bistray odoo-apps
git clone -b $Odoo_VERSION https://github.com/bistaray/odoo-apps.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/odoo-apps"
cd ./odoo-apps
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base

## Cybrosys. Unos indios muy majos con un set de addons muy interesantes
git clone -b $Odoo_VERSION https://github.com/CybroOdoo/CybroAddons.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/CybroAddons"
cd ./CybroAddons
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base

## Serpent. Otros chicos muy majos haciendo contribuciones interesantes
git clone -b $Odoo_VERSION https://github.com/JayVora-SerpentCS/SerpentCS_Contributions.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/SerpentCS_Contributions"
cd ./SerpentCS_Contributions
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base

## It-Projects
git clone -b $Odoo_VERSION https://github.com/it-projects-llc/website-addons.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/website-addons"
cd ./website-addons
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base

## It-Projects Misc-Addons
git clone -b $Odoo_VERSION https://github.com/it-projects-llc/misc-addons.git
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/misc-addons"
cd ./misc-addons
Odoo_Req="requirements.txt"
if [ -f "$Odoo_Req" ]
then
	echo "$file found."
	pip install -r $Odoo_Req
else
	echo "Sin Requerimientos solicitados"
fi
cd $Odoo_Addons_Base

## It Project -- Telegram Bot -- Experimental. Falta acabar de hacer las pruebas. (killTheMailAction)
#git clone -b $Odoo_VERSION https://github.com/it-projects-llc/odoo-telegram.git
#Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/odoo-telegram"


# Ahora vamos con los addons que necesitamos complementarios de Third Party
mkdir $Odoo_Addons_Base/StromicAddons
cd $Odoo_Addons_Base/StromicAddons
Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/StromicAddons"

## Mejoras para el website
### Cuenta Atrás
git clone -b $Odoo_VERSION https://github.com/tpa-odoo/website_countdown.git
###
#git clone -b $Odoo_VERSION 
# Hay que añadir el módulo https://apps.odoo.com/loempia/download/report_xlsx/10.0.0.2/2s6KJKBdomLmxfKrGpdgva.zip?deps report_xlsx de Cybrosis.
# Falta una dependencia que se monta con pip install httpagentparser
# Da un pequeño problema con pyOpenSSL que habrá que revisar

echo "Añade la siguiente linea en /opt/odoo/odoo.conf"
echo "(Crtl+C) --> ${Odoo_Addons_Path}"


