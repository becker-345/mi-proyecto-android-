package com.harley.baseapk

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.harley.baseapk.ui.theme.BaseapkTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        val externalUri = intent.data 
        
        // 1. MODO SILENCIOSO: Si tocaste un APK desde afuera (ZArchiver)
        if (externalUri != null && intent.action == Intent.ACTION_VIEW) {
            InstallLogic.installExternalApk(this, externalUri)
            // Cerramos nuestra app al instante. Solo quedará el instalador del sistema.
            finish()
            return
        }
        
        // 2. MODO DASHBOARD: Si abriste la app tocando el ícono en el Inicio
        setContent {
            BaseapkTheme {
                InstallScreen()
            }
        }
    }
}
