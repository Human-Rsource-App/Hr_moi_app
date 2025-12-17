# ---------------------------
# ML Kit: Face Detection
# ---------------------------
-keep class com.google.mlkit.vision.face.** { *; }
-keep class com.google.mlkit.vision.common.** { *; }

# ---------------------------
# ML Kit: Text Recognition (Latin only)
# ---------------------------
-keep class com.google.mlkit.vision.text.** { *; }

# IMPORTANT: Do NOT keep these if you are not using these scripts.
# Otherwise R8 will look for their classes and break the build.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-dontwarn com.google.mlkit.vision.text.devanagari.**

# ---------------------------
# ML Kit: Common
# ---------------------------
-keep class com.google.mlkit.common.** { *; }

# ---------------------------
# Play Core (fixes SplitInstall errors)
# ---------------------------
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# ---------------------------
# Flutter generated & plugin classes
# ---------------------------
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# ---------------------------
# Parcelable & Serializable
# ---------------------------
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object readResolve();
}
