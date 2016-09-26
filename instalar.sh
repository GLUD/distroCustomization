#!/bin/bash

usuario=${USER^^}
echo "  /\\_/\\  Hola $usuario"
echo ' ( o.o ) Bienvenid@ al Grupo GNU/Linux UD '
echo '  > ^ < '

#https://wiki.archlinux.org/index.php/proxy_settings
function proxy {
export {HTTP,HTTPS,FPT,ALL,SOCKS,RSYNC}_PROXY=http://10.20.4.15:3128
export {http,https,ftp,all,socks,rsync}_proxy=http://10.20.4.15:3128
export {NO_PROXY,no_proxy}="localhost,127.0.0.1,localaddress,.localdomain.com,10.20.0.0/16"

env | grep -i proxy
}

function proxyoff {
unset {HTTP,HTTPS,FPT,ALL,SOCKS,NO}_PROXY
unset {http,https,ftp,all,socks,no}_proxy

env | grep -i proxy 
}
