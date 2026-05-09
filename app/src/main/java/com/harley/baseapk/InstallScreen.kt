package com.harley.baseapk

import android.net.Uri
import android.content.Intent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Build
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun InstallScreen(externalApkUri: Uri?) {
    val context = LocalContext.current
    // Ruta fija para cuando programas en AndroidIDE
    val rutaLocal = "/storage/internal_new/project/baseapk/outputs/MiApp.apk"

    Column(
        modifier = Modifier.fillMaxSize().padding(24.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon(
            imageVector = Icons.Default.Build,
            contentDescription = null,
            modifier = Modifier.size(100.dp),
            tint = MaterialTheme.colorScheme.primary
        )
        
        Spacer(modifier = Modifier.height(24.dp))
        
        Text(
            text = "APK Installer Pro",
            fontSize = 28.sp,
            fontWeight = FontWeight.Bold
        )
        
        Text(
            text = if (externalApkUri != null) "Instalando app externa..." else "Instalación desde la nube",
            color = MaterialTheme.colorScheme.outline
        )

        Spacer(modifier = Modifier.height(48.dp))

        Button(
            onClick = { 
                if (externalApkUri != null) {
                    // Si tocaste un juego en ZArchiver, instalamos ese juego
                    val intent = Intent(Intent.ACTION_VIEW).apply {
                        setDataAndType(externalApkUri, "application/vnd.android.package-archive")
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
                    context.startActivity(intent)
                } else {
                    // Si abriste la app normal, instalamos tu proyecto de AndroidIDE
                    InstallLogic.installApk(context, rutaLocal)
                }
            },
            modifier = Modifier.fillMaxWidth().height(60.dp),
            shape = RoundedCornerShape(16.dp),
            colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.primary)
        ) {
            Text("INSTALAR", fontWeight = FontWeight.ExtraBold)
        }
    }
}
