#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class androidx.lifecycle.** { *; } 
-keep @interface com.google.gson.annotations.SerializedName
-keep @interface com.google.gson.annotations.Expose
-keepattributes *Annotation*
#FlutterConfig 
-keep class com.billionants.p2pbookshare.BuildConfig { *; }