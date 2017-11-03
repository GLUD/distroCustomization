# distroCustomization
Un proyecto para personalizar las distrubuciones GNU/Linux con el sello del GLUD. La idea es generar un conjunto de configuraciones qué sean útiles para todos los miembros del GLUD, generando atajos, alias, instalando aplicaciones y todo tipo de configuradores útiles. LLegando a algo como https://gist.github.com/OliverMichels/967993

Se puede instalar fácilmente ejecutando:
* Si estás en la U
```bash
https_proxy=http://10.20.4.15:3128 curl https://raw.githubusercontent.com/GLUD/distroCustomization/master/instalar.sh | bash
```
* Si estás en casa
```bash
curl https://raw.githubusercontent.com/GLUD/distroCustomization/master/instalar.sh | bash
```

Se puede desinstalar fácilmente ejecutando: ( recuerda poner el proxy :D )
```bash
curl https://raw.githubusercontent.com/GLUD/distroCustomization/master/desinstalar.sh | bash
```

# ¿Cómo lo uso?
Escribe ***proxy*** en la terminal y ejecuta tus programas.
```bash
proxy
```
Cuando ya no lo necesites puedes escribir ***proxyoff***.
```bash
proxyoff
```
