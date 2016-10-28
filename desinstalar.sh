#!/bin/bash

aplicacion=/usr/local/bin/glud.sh
sudoersfile=/etc/sudoers.d/glud

# rationale: esta es una desinstalación parcial, falta quitar de los .bashrc
sudo rm -rf $aplicacion $sudoersfile
