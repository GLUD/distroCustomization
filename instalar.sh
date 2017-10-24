#!/bin/bash

aplicacion=/usr/local/bin/glud.sh
if [ -f $aplicacion ]
then
  echo "El script ya está instalado en $aplicacion."
else

sudo tee $aplicacion << 'EOF'
usuario=${USER^^}
echo "  /\\_/\\  Hola $usuario"
echo ' ( o.o ) Bienvenid@ al Grupo GNU/Linux UD '
echo '  > ^ < '

# rationale: se una una única variable de entorno para establecer el proxy
# si no existe se pone una predeterminada
if [ -z "$PROXY_DIR" ]; then
  PROXY_DIR=http://10.20.4.15:3128
fi

# rationale: agregar proxy a "apt-key adv"
# link: https://unix.stackexchange.com/questions/361213/unable-to-add-gpg-key-with-apt-key-behind-a-proxy
function proxy_apt_key {
if [ "$1" != "off" ]; then
  alias apt-key="apt-key --keyserver-options http-proxy=$PROXY_DIR"
else
  unalias apt-key
fi
}
# rationale: agrega todas las variables de entorno conocidas
# si desea agregar proxy a aplicaciones, puede generar nuevas funciones
# que validen la existencia del programa y establezcan su proxy con alias
# u otras técnicas (falta agregar un ejemplo)
# link: https://www.arin.net/knowledge/address_filters.html
# link: https://wiki.archlinux.org/index.php/proxy_settings
function proxy {
export {HTTP,HTTPS,FTP,ALL,SOCKS,RSYNC}_PROXY=$PROXY_DIR
export {http,https,ftp,all,socks,rsync}_proxy=$PROXY_DIR
export {NO_PROXY,no_proxy}="localhost,127.0.0.1,localaddress,.localdomain.com,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12"
proxy_apt_key
env | grep -i proxy
}

function proxyoff {
unset {HTTP,HTTPS,FTP,ALL,SOCKS,RSYNC,NO}_PROXY
unset {http,https,ftp,all,socks,rsync,no}_proxy
proxy_apt_key off
env | grep -i proxy
}

function proxystat {
env | grep -i proxy
}
function glud {
echo '                                               -  '
echo '                                            ..*@. '
echo '     ..---...                            ..o||so. '
echo '  .o*$$$$$$$%$s..                .:+.:---..       '
echo '    ..-:.++..o*@%@$|s+-.      .:o%@@$.            '
echo '  ..|@@*|||$@%%@@@@@@@%%*: -.:...$$@|             '
echo ' .$$o--+s**%@@@@@@@@@@@@@@       o*.$.            '
echo ' .-..|%*o.:o@@@@@@@@@@@@%:       +@ -%.           '
echo '   -@*-...|@@@@@@@@@@@@*-       .$@.+o.           '
echo '  .@+..s@@*||$@@@@@@@@@+   .  -s%@$+.             '
echo '  :: +@*:+|$*s+.:--:+|@%*|*@$$%@|-.               '
echo '    +%o.|%|-.         .+@@@@@@@@o                 '
echo '    |. *%+              .s@@@@@@@+                '
echo '    . .$.                 .%@@@@@%-               '
echo '       .                   .@@@@@@*               '
echo '                            $@@@@@@               '
echo '                            |@@@@@@.              '
echo '                            *@@@@@@.              '
echo '                           -%@@@@@%               '
echo '                          :%@@@@@@o               '
echo '                        .o@@@@@@@$.               '
echo '                        o@@@@@@@@.                '
echo '                        o@@@@@%*.                 '
echo '                  -:.   o@@%o.-                   '
echo '                 .%@@s-.$%@o                      '
echo '                 .@%-:oss+@:                      '
echo '                 o@+    .$*                       '
echo '                 .:    -@%.                       '
echo '                      .%@%$*|o:                   '
echo '                       -os|||s.                   '
}

EOF

fi

# rationale: aumentar tamaño del historial
# link: https://stackoverflow.com/questions/19454837/bash-histsize-vs-histfilesize#19454838
# link: https://gist.github.com/OliverMichels/967993
# link: https://bbs.archlinux.org/viewtopic.php?id=150992
HISTBASHRC_CONTENT=$(cat << 'EOF'
export HISTCONTROL=ignoredups
export HISTSIZE=500000
export HISTFILESIZE=1000000
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear"
shopt -s histappend # Append to history rather than overwrite
EOF
)

# rationale: se adiciona una línea en los .bashrc que hace un source al glud.sh
# para el futuro se planea hacerlo para /etc/profile.d ?
# la decisión fue NO, es mejor dejarlo en el directorio de usuario debido a qué
# es más fácil realizar un backup de estos y no de todos los archivos del sistema
archivos=(
~/.bashrc
"/root/.bashrc"
)

BASHRC_CONTENT=$(cat << EOF
# begin distroCustomization
source $aplicacion
$HISTBASHRC_CONTENT
# end distroCustomization
EOF
)

for i in "${archivos[@]}"
do
  if sudo grep -i "$aplicacion" $i &> /dev/null
  then
    echo "El archivo $i ya está modificado."
  else
    sudo cp $i{,.bak}
    echo "${BASHRC_CONTENT}" | sudo tee -a $i
  fi
done

# rationale: chekcea a través de un comando como root, si el archivo existe
# este por lo general tiene permisos 760, por tanto no se puede como usuario normal
# comprobar si existe
sudoersfile=/etc/sudoers.d/glud
if sudo ls "$sudoersfile" &> /dev/null
then
  echo "Ya está creado archivo sudoers $sudoersfile."
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

# rationale: Mostrar al usuario qué hay que hacer
echo
echo 'Para usar ejecuta el comando:'
echo "source $aplicacion"
