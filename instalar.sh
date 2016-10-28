#!/bin/bash

aplicacion=/usr/local/bin/glud.sh
if [ -f $aplicacion ]
then
  echo 'El script ya está instalado.'
else

sudo tee $aplicacion << 'EOF'
usuario=${USER^^}
echo "  /\\_/\\  Hola $usuario"
echo ' ( o.o ) Bienvenid@ al Grupo GNU/Linux UD '
echo '  > ^ < '

#https://wiki.archlinux.org/index.php/proxy_settings
function proxy {
export {HTTP,HTTPS,FTP,ALL,SOCKS,RSYNC}_PROXY=http://10.20.4.15:3128
export {http,https,ftp,all,socks,rsync}_proxy=http://10.20.4.15:3128
export {NO_PROXY,no_proxy}="localhost,127.0.0.1,localaddress,.localdomain.com,10.20.0.0/16"

env | grep -i proxy
}

function proxyoff {
unset {HTTP,HTTPS,FTP,ALL,SOCKS,RSYNC,NO}_PROXY
unset {http,https,ftp,all,socks,rsync,no}_proxy

env | grep -i proxy 
}
EOF

fi

archivos=(
~/.bashrc
"/root/.bashrc"
)

for i in "${archivos[@]}"
do
  if sudo grep -i "$aplicacion" $i &> /dev/null
  then
    echo "El archivo $i ya está modificado."
  else
    sudo cp $i{,.bak}
    sudo tee -a $i <<< "source $aplicacion" 
  fi
done

# rationale: Mostrar al usuario qué hay que hacer
echo
echo 'Ejecuta el comando:'
echo "source $aplicacion"

sudoersfile=/etc/sudoers.d/glud
if [ -f $sudoersfile ]
then
  echo "Ya está $sudoersfile"
else

sudo tee $sudoersfile << 'EOF'
Defaults  env_keep += "http_proxy"
Defaults  env_keep += "https_proxy"
Defaults  env_keep += "ftp_proxy"
Defaults  env_keep += "all_proxy"
Defaults  env_keep += "socks_proxy"
Defaults  env_keep += "rsync_proxy"
Defaults  env_keep += "no_proxy"
Defaults  env_keep += "HTTP_PROXY"
Defaults  env_keep += "HTTPS_PROXY"
Defaults  env_keep += "FPT_PROXY"
Defaults  env_keep += "ALL_PROXY"
Defaults  env_keep += "SOCKS_PROXY"
Defaults  env_keep += "RSYNC_PROXY"
Defaults  env_keep += "NO_PROXY"
EOF

fi

