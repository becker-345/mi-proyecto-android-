#!/bin/bash

# Colores
VERDE='\033[0;32m'
ROJO='\033[0;31m'
AZUL='\033[0;34m'
NC='\033[0m'

echo -e "${AZUL}🚀 1. Subiendo código...${NC}"
git add .
git commit -m "Auto-Build" > /dev/null 2>&1
git push origin master > /dev/null 2>&1

echo -e "${AZUL}☁️ 2. Compilando en la nube...${NC}"
# Esperamos 3 segundos para que GitHub registre el proceso
sleep 3

# Obtenemos el ID exacto automáticamente. ¡ESTO EVITA QUE TE PIDA DAR ENTER!
RUN_ID=$(gh run list -L 1 --json databaseId -q '.[0].databaseId')

# Mostramos el progreso en vivo (Se detendrá solo, sin congelarse)
gh run watch $RUN_ID --exit-status

# Verificamos si hubo un error en tu código Kotlin/XML
if [ $? -ne 0 ]; then
    echo -e "\n${ROJO}❌ SE ENCONTRÓ UN ERROR EN TU CÓDIGO. Aquí está el detalle:${NC}"
    # Imprime el error exacto y se queda en pantalla para que lo leas
    gh run view $RUN_ID --log-failed
    exit 1
fi

echo -e "${AZUL}📥 3. Descargando APK al teléfono...${NC}"
rm -rf ./temp_apk
gh run download $RUN_ID -n mi-apk-listo --dir ./temp_apk

APK_FINAL="/storage/emulated/0/Download/MiApp.apk"
rm -f $APK_FINAL
mv ./temp_apk/*.apk "$APK_FINAL"

echo -e "${VERDE}📱 4. Abriendo instalador de Android...${NC}"
# Esto forzará a tu teléfono a abrir la pantalla de "Instalar Aplicación" automáticamente
termux-open "$APK_FINAL" 2>/dev/null || xdg-open "$APK_FINAL" 2>/dev/null || am start -a android.intent.action.VIEW -d "file://$APK_FINAL" -t "application/vnd.android.package-archive" 2>/dev/null

echo -e "${VERDE}✅ ¡Proceso terminado con éxito!${NC}"
