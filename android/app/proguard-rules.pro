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
# https://stackoverflow.com/questions/76800185/how-to-keep-classes-reported-missing-by-r8-during-a-release-build-of-a-flutter-a/
# https://github.com/DealORound/Deal-O-Round/issues/28
#-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
#-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

-keep class com.ryanheise.audioservice.** { *; }
-keepclassmembernames class com.ryanheise.audioservice.** { *; }
-keep class com.ryanheise.audio_session.** { *; }
-keepclassmembernames class com.ryanheise.audio_session.** { *; }
-keep class com.abedalkareem.games_services.** { *; }
-keepclassmembernames class com.abedalkareem.games_services.** { *; }
-keep class com.ryanheise.just_audio.** { *; }
-keepclassmembernames class com.ryanheise.just_audio.** { *; }
-keep class dev.fluttercommunity.plus.packageinfo.** { *; }
-keepclassmembernames class dev.fluttercommunity.plus.packageinfo.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keepclassmembernames class io.flutter.plugins.pathprovider.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keepclassmembernames class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.tekartik.sqflite.** { *; }
-keepclassmembernames class com.tekartik.sqflite.** { *; }
-keep class io.flutter.plugins.urllauncher.** { *; }
-keepclassmembernames class io.flutter.plugins.urllauncher.** { *; }
-keep class dev.fluttercommunity.plus.wakelock.** { *; }
-keepclassmembernames class dev.fluttercommunity.plus.wakelock.** { *; }

-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod

-keep class * extends com.google.protobuf.** { *; }
-keepclassmembernames class * extends com.google.protobuf.** { *; }
