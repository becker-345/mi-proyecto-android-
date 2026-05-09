#!/bin/bash

# Colores
VERDE='\033[0;32m'
ROJO='\033[0;31m'
AZUL='\033[0;34m'
NC='\033[0m'

echo -e "${AZUL}🚀 1. Subiendo código a la nube...${NC}"
git add .
git commit -m "Auto-Build" > /dev/null 2>&1
git push origin master > /dev/null 2>&1

echo -e "${AZUL}☁️ 2. Compilando en la nube (silencioso)...${NC}"
sleep 3
RUN_ID=$(gh run list -L 1 --json databaseId -q '.[0].databaseId')

# Ocultamos el progreso
gh run watch $RUN_ID --exit-status > /dev/null 2>&1

# Si falla (exit code != 0)
if [ $? -ne 0 ]; then
    echo -e "\n${ROJO}❌ LA COMPILACIÓN FALLÓ.${NC}"
    
    # Extrae el error y lo guarda (pero NO lo muestra en terminal)
    gh run view $RUN_ID --log-failed > error_log.txt
    
    # Intenta copiar al portapapeles
    cat error_log.txt | termux-clipboard-set 2>/dev/null
    
    echo -e "${VERDE}✅ El reporte detallado está en tu portapapeles y en 'error_log.txt'.${NC}"
    exit 1
fi

echo -e "${AZUL}📥 3. Todo correcto. Descargando APK...${NC}"
rm -rf ./temp_apk
gh run download $RUN_ID -n mi-apk-listo --dir ./temp_apk

CARPETA_DESTINO="$PWD/outputs"
APK_FINAL="$CARPETA_DESTINO/MiApp.apk"

mkdir -p "$CARPETA_DESTINO"
rm -f "$APK_FINAL"
mv ./temp_apk/*.apk "$APK_FINAL"
rm -rf ./temp_apk

echo -e "${VERDE}📱 4. Abriendo instalador de Android...${NC}"
termux-open "$APK_FINAL" 2>/dev/null || xdg-open "$APK_FINAL" 2>/dev/null || am start -a android.intent.action.VIEW -d "file://$APK_FINAL" -t "application/vnd.android.package-archive" 2>/dev/null

echo -e "${VERDE}✅ ¡Listo! APK guardado en la carpeta 'outputs'.${NC}"
