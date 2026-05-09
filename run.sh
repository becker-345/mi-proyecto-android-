#!/bin/bash

echo "🚀 Ejecutando build..."
git add .
git commit -m "Auto-Build" > /dev/null 2>&1
git push origin master > /dev/null 2>&1

# Esperar ID
sleep 3
RUN_ID=$(gh run list -L 1 --json databaseId -q '.[0].databaseId')

# Ejecutar
gh run watch $RUN_ID --exit-status > build_log.txt 2>&1

if [ $? -ne 0 ]; then
    echo "❌ Error detectado. Extrayendo detalles..."
    # Extraemos solo las líneas de error (lo que dice FAILURE o ERROR)
    grep -E "FAILURE|error|Exception|Parsing" build_log.txt > error_log.txt
    
    # Copiar al portapapeles (si el dispositivo lo permite)
    cat error_log.txt | termux-clipboard-set 2>/dev/null
    
    echo "------------------------------------------------"
    cat error_log.txt
    echo "------------------------------------------------"
    echo "✅ Error copiado al portapapeles y guardado en error_log.txt"
    exit 1
fi

echo "✅ Build exitoso. Descargando..."
# (Aquí sigue tu lógica de descarga igual que antes)
