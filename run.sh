#!/bin/bash

# Colores para que se vea bien en la terminal
VERDE='\033[0;32m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
NC='\033[0m' # Sin Color

echo -e "${AZUL}🚀 Paso 1: Sincronizando cambios con la nube...${NC}"
git add .
# El commit solo se hace si hay cambios reales
git commit -m "Build: $(date +'%d-%m-%y %H:%M:%S')" || echo "No hay cambios nuevos, reintentando compilación..."
git push origin master

echo -e "${AZUL}☁️  Paso 2: Iniciando compilación en GitHub...${NC}"
echo -e "${VERDE}TIP: Presiona ENTER cuando aparezca el menú para ver los logs en vivo.${NC}"
gh run watch

echo -e "${AZUL}📥 Paso 3: Descargando APK resultante...${NC}"
# Limpiamos descargas viejas para no llenar la memoria
rm -rf ./temp_apk
gh run download -n mi-apk-listo --dir ./temp_apk

# Movemos el APK a la carpeta de descargas real del teléfono
echo -e "${AZUL}📱 Paso 4: Moviendo APK a tu carpeta de Descargas...${NC}"
FECHA=$(date +'%H_%M_%S')
mv ./temp_apk/*.apk /storage/emulated/0/Download/App_Debug_${FECHA}.apk

echo -e "${VERDE}✅ ¡TODO LISTO!${NC}"
echo -e "Tu APK está en: ${VERDE}/Descargas/App_Debug_${FECHA}.apk${NC}"
