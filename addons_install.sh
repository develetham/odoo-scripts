#!/bin/bash

# Script para la instalación de los módulos esenciales
# para una funcionamiento molón del Odoo.
# Desarrollado por etham 
# Para poder ejecutar adecuadamente este script sera necesario añadir credenciales de GitHub
# -----------
# Este script lee del archivo addons_list.txt para poder instalar

AddonsFile=addons_list.txt

[ ! -f $AddonsFile ] && { echo "$AddonsFile file not found"; exit 99; }

# Algo de Florituras. Le damos color

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
#Distro=`awk -F= '/^ID=/{print $2}' /etc/os-release`

# Capturamos el nombre del server
#
Servidor=`hostname -f`

# Trabajamos para Odoo
#
Odoo_VERSION="11.0" # Change here for your odoo version. Let´s work for find out which version is installed. Nice to have list (N2H List)
Odoo_Addons_Raw="/odoo"
Odoo_Addons_Base="$Odoo_Addons_Raw/extra-addons"
Odoo_Addons_Path="addonspath=/odoo/odoo-server/addons"
Odoo_Ad_Num=0

#echo $Odoo_VERSION
#echo $Odoo_Addons_Raw
#echo $Odoo_Addons_Base
#echo $Odoo_Addons_Path

pip install -U setuptools
pip install -U httpagentparser
pip install -U cachetools
pip install -U pdfconv

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

while read adName adURL
    
    #do echo "Hoy tenemos un $adName"
    do 
        #echo "$adName"
        #echo "$adURL"
        let "Odoo_Ad_Num += 1"
        
        ## Comienzo de la instalación del módiulo
        cd $Odoo_Addons_Base
        
        echo "${ROJO} $Odoo_Ad_Num Instalando Modulo -> $adName de $adURL ${NC}"
        git clone -b $Odoo_VERSION $adURL
    
        Odoo_Addons_Path="${Odoo_Addons_Path},${Odoo_Addons_Base}/${adName}"
        echo ${Odoo_Addons_Path}
        cd ./${adName}
        Odoo_Req="requirements.txt"
        if [ -f "$Odoo_Req" ]
        then
            echo "$file found."
            pip install -r $Odoo_Req
            pip3 install -r $Odoo_Req
        else
            echo "Sin Requerimientos solicitados"
        fi


done < ${AddonsFile}

cat >> /etc/odoogit .conf << FIN
    [options]
    ; Aqui colocamos los datos de configuración básicos:
    admin_passwd = admin

    ; XML-RPC
    xmlrpcs = True
    xmlrpcs_interface = 127.0.0.1 
    xmlrpcs_port = 8071
    xmlrpc = True
    xmlrpc_interface = 127.0.0.1
    xmlrpc_port = 8069

    ; Archivo de logs
    logfile = /var/log/odoo/odoo-server.log

    ; Otras configuraciones
    workers = 0 

    ; Acceso a los addons
    ${Odoo_Addons_Path}

FIN

echo "Parece estar todo el listado satisfecho"