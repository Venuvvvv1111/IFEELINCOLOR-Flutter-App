# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.** { *; }

# Keep Firebase and Google Play Services classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.gms.measurement.** { *; }
-keep class com.google.android.gms.tasks.** { *; }

# Keep your application classes
-keep class com.ifeelin_color.ifeelin_color.** { *; }

# Keep Razorpay classes and avoid warnings
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep ProGuard annotations used by Razorpay
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers
-keepattributes *Annotation*

# Keep all classes extending Activity or using AndroidX
-keep class * extends android.app.Activity
-keep class * extends androidx.** { *; }

# Prevent warnings from common libraries
-dontwarn okhttp3.**
-dontwarn javax.annotation.**

# Keep Parcelable classes intact
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
