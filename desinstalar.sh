#!/bin/bash

aplicacion=/usr/local/bin/glud.sh
sudoersfile=/etc/sudoers.d/glud

# rationale: esta es una desinstalación parcial, falta quitar de los .bashrc
sudo rm -rf $aplicacion $sudoersfile


# rationale: se elimina una línea en los .bashrc para quitar el source al glud.sh
# para el futuro se planea hacerlo para /etc/profile.d ?
archivos=(
~/.bashrc
"/root/.bashrc"
)

for i in "${archivos[@]}"
do
  if sudo grep -i "$aplicacion" $i &> /dev/null
  then
    sudo sed -i.bak "/source \/usr\/local\/bin\/glud.sh/d" $i
  else
    echo "El archivo $i ya está modificado."
  fi
done
