-verbose
-keep class androidx.lifecycle.** { *; }
-keepclassmembernames class androidx.lifecycle.* { *; }
-keepclassmembers class * implements androidx.lifecycle.LifecycleObserver {
    <init>(...);
}
-keepclassmembers class * extends androidx.lifecycle.ViewModel {
    <init>(...);
}
-keepclassmembers class androidx.lifecycle.Lifecycle$State { *; }
-keepclassmembers class androidx.lifecycle.Lifecycle$Event { *; }
-keepclassmembers class * {
    @androidx.lifecycle.OnLifecycleEvent *;
}

# https://github.com/flutter/flutter/issues/78625#issuecomment-804164524
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

-keep class com.github.florent37.assets_audio_player.** { *; }
-keepclassmembernames class com.github.florent37.assets_audio_player.* { *; }
-keep class com.abedalkareem.games_services.** { *; }
-keepclassmembernames class com.abedalkareem.games_services.** { *; }
-keep class dev.fluttercommunity.plus.packageinfo.** { *; }
-keepclassmembernames class dev.fluttercommunity.plus.packageinfo.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keepclassmembernames class io.flutter.plugins.pathprovider.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keepclassmembernames class io.flutter.plugins.sharedpreferences.** { *; }
-keep class pl.ukaszapps.soundpool.SoundpoolPlugin.** { *; }
-keepclassmembernames class pl.ukaszapps.soundpool.SoundpoolPlugin.** { *; }
-keep class io.flutter.plugins.urllauncher.** { *; }
-keepclassmembernames class io.flutter.plugins.urllauncher.** { *; }
-keep class dev.fluttercommunity.plus.wakelock.** { *; }
-keepclassmembernames class dev.fluttercommunity.plus.wakelock.** { *; }

-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod

-keep class * extends com.google.protobuf.** { *; }
-keepclassmembernames class * extends com.google.protobuf.** { *; }
