plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.notnavaja.infusioncalc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.notnavaja.infusioncalc"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

}

androidComponents {
    onVariants { variant ->
        if (variant.buildType == "release") {
            variant.outputs.forEach { output ->
                val apkOutput = output as? com.android.build.api.variant.impl.VariantOutputImpl
                
                val abiName = apkOutput?.filters?.firstOrNull { 
                    it.filterType == com.android.build.api.variant.FilterConfiguration.FilterType.ABI 
                }?.identifier

                // Safely query the dynamic version string directly from the active variant configuration
                val appVersion = apkOutput?.versionName?.get() ?: "1.0.0"

                if (abiName != null) {
                    apkOutput?.outputFileName?.set("InfusionCalc_${appVersion}_${abiName}.apk")
                } else {
                    apkOutput?.outputFileName?.set("InfusionCalc_${appVersion}_universal.apk")
                }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
