#!/bin/bash

PROX=$(gsettings get org.gnome.system.proxy mode)
if [ "$PROX" = "'none'" ]; then
    echo "Encendiendo el proxy-sat"
    gsettings set org.gnome.system.proxy mode 'manual'
else
    echo "Quitando el proxy-sat, A-F-O-R-T-U-N-A-D-A-M-E-N-T-E"
    gsettings set org.gnome.system.proxy mode 'none'
fi
