#!/bin/bash
AZUL='\033[0;34m'; VERDE='\033[0;32m'; ROJO='\033[0;31m'; NC='\033[0m'

echo -e "${AZUL}🚀 1. Subiendo archivos...${NC}"
git add . && git commit -m "Auto-Build" > /dev/null 2>&1
git push origin master > /dev/null 2>&1

echo -e "${AZUL}☁️ 2. Procesando en la nube...${NC}"
RUN_ID=$(gh run list -L 1 --json databaseId -q '.[0].databaseId')
gh run watch $RUN_ID --exit-status > /dev/null 2>&1

if [ $? -ne 0 ]; then
    gh run view $RUN_ID --log-failed > error_log.txt
    cat error_log.txt | termux-clipboard-set 2>/dev/null
    echo -e "${ROJO}❌ Error de compilación. Revisa 'error_log.txt' en tu proyecto.${NC}"
    exit 1
fi

echo -e "${AZUL}📥 3. Descargando y moviendo...${NC}"
rm -rf ./temp_apk
gh run download $RUN_ID -n mi-apk-listo --dir ./temp_apk
mkdir -p "$PWD/outputs"
rm -f "$PWD/outputs/MiApp.apk"
mv ./temp_apk/*.apk "$PWD/outputs/MiApp.apk"
rm -rf ./temp_apk

echo -e "${VERDE}✅ ¡Listo! Tu nuevo APK está en la carpeta 'outputs'.${NC}"
