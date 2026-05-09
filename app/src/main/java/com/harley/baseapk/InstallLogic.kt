package com.harley.baseapk

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInstaller
import android.net.Uri
import android.widget.Toast
import java.io.File

object InstallLogic {
    
    // Para cuando le des al botón en tu IDE
    fun installLocalApk(context: Context, apkPath: String) {
        val file = File(apkPath)
        if (!file.exists()) {
            Toast.makeText(context, "No hay APK compilado en outputs", Toast.LENGTH_SHORT).show()
            return
        }
        installFromStream(context, Uri.fromFile(file))
    }

    // Para cuando toques un juego desde ZArchiver
    fun installExternalApk(context: Context, apkUri: Uri) {
        Toast.makeText(context, "Procesando paquete...", Toast.LENGTH_SHORT).show()
        installFromStream(context, apkUri)
    }

    // El núcleo nativo de instalación de Android
    private fun installFromStream(context: Context, uri: Uri) {
        val packageInstaller = context.packageManager.packageInstaller
        val params = PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL)
        
        try {
            val sessionId = packageInstaller.createSession(params)
            val session = packageInstaller.openSession(sessionId)

            // Copiamos el archivo directamente a la memoria del instalador de Android
            context.contentResolver.openInputStream(uri)?.use { inputStream ->
                session.openWrite("app_install", 0, -1).use { outputStream ->
                    inputStream.copyTo(outputStream)
                    session.fsync(outputStream)
                }
            }

            // Obligamos al sistema a mostrar la ventana emergente nativa
            val intent = Intent()
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                sessionId,
                intent,
                // FLAG_MUTABLE es obligatorio en Android 12+ para instalaciones
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            
            session.commit(pendingIntent.intentSender)
            session.close()
            
        } catch (e: Exception) {
            e.printStackTrace()
            Toast.makeText(context, "Error interno al leer el APK", Toast.LENGTH_LONG).show()
        }
    }
}
