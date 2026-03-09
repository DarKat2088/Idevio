plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.idea_generator_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.idevio.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

tasks.register("renameApk") {
    doLast {
        val apk = file("build/outputs/flutter-apk/app-release.apk")
        val newApk = file("build/outputs/flutter-apk/Idevio.apk")
        if (apk.exists()) {
            apk.copyTo(newApk, overwrite = true)
            println("APK переименован в Idevio.apk")
        } else {
            println("APK не найден, сначала собери его: flutter build apk --release")
        }
    }
}
