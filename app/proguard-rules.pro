# ML Kit & TFLite
-keep class com.google.mlkit.** { *; }
-keep class org.tensorflow.lite.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_label_custom.** { *; }

# Keep native methods and their classes
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}

# Required for TFLite JNI and Reflection
-keepclassmembers class * {
    @org.tensorflow.lite.annotations.UsedByReflection *;
}
-keep class org.tensorflow.lite.NativeInterpreterWrapper { *; }
-keepnames class org.tensorflow.lite.** { *; }

# AdMob
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# uCrop
-keep class com.yalantis.ucrop.** { *; }

# Coil (Image Loading)
-keep class coil.** { *; }

# AndroidX & Compose
-keep class androidx.compose.** { *; }
-keep class androidx.lifecycle.** { *; }
-keep class com.google.android.material.** { *; }

# Suppress warnings from libraries that might have missing dependencies
-dontwarn com.google.android.gms.**
-dontwarn org.tensorflow.lite.**
-dontwarn com.yalantis.ucrop.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**

# Optimization: keep the TFLite model loading working correctly
-keepclassmembers class org.tensorflow.lite.Interpreter { *; }
