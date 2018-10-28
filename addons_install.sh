#!/bin/bash

# Script para la instalación de los módulos esenciales
# para una funcionamiento molón del Odoo.
# Desarrollado por etham 

# Algo de Florituras. Le damos color

while read addon
    do echo "Hoy tenemos un $addon"
done < addons_list.txt