# Reglas para Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }

# Reglas para paquetes comunes
-keep class com.google.** { *; }
-keep class androidx.** { *; }

# Reglas para tu aplicación
-keep class com.example.** { *; }

# Evita que ProGuard ofusque las clases que usan reflexión
-keepattributes *Annotation*
-keepattributes Signature