# ---------------------------
# ML Kit: Face Detection
# ---------------------------
-keep class com.google.mlkit.vision.face.** { *; }
-keep class com.google.mlkit.vision.common.** { *; }

# ---------------------------
# ML Kit: Text Recognition
# ---------------------------
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }

# ---------------------------
# ML Kit: Common Utilities
# ---------------------------
-keep class com.google.mlkit.common.** { *; }

# ---------------------------
# Keep Flutter plugin generated classes
# ---------------------------
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# ---------------------------
# Optional: Keep Parcelable & Serializable classes
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
