package com.harley.baseapk

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.harley.baseapk.ui.theme.BaseapkTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        // Atrapamos la ruta del APK externo si alguien abrió nuestra app tocando un archivo
        val externalApkUri = intent.data 
        
        setContent {
            BaseapkTheme {
                InstallScreen(externalApkUri)
            }
        }
    }
}
