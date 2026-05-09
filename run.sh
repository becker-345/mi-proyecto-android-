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
sleep 3
RUN_ID=$(gh run list -L 1 --json databaseId -q '.[0].databaseId')

gh run watch $RUN_ID --exit-status

if [ $? -ne 0 ]; then
    echo -e "\n${ROJO}❌ SE ENCONTRÓ UN ERROR EN TU CÓDIGO.${NC}"
    gh run view $RUN_ID --log-failed
    exit 1
fi

echo -e "${AZUL}📥 3. Descargando APK...${NC}"
rm -rf ./temp_apk
gh run download $RUN_ID -n mi-apk-listo --dir ./temp_apk

# --- GUARDAMOS DENTRO DEL PROYECTO ACTUAL DE ANDROIDIDE ---
CARPETA_DESTINO="$PWD/outputs"
APK_FINAL="$CARPETA_DESTINO/MiApp.apk"

mkdir -p "$CARPETA_DESTINO"
rm -f "$APK_FINAL"
mv ./temp_apk/*.apk "$APK_FINAL"
rm -rf ./temp_apk

echo -e "${VERDE}📱 4. Intentando abrir el instalador...${NC}"
# Intentamos forzar la instalación
termux-open "$APK_FINAL" 2>/dev/null || xdg-open "$APK_FINAL" 2>/dev/null || am start -a android.intent.action.VIEW -d "file://$APK_FINAL" -t "application/vnd.android.package-archive" 2>/dev/null

echo -e "${VERDE}✅ ¡Listo! APK guardado en la carpeta 'outputs' de tu proyecto.${NC}"
