plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.pajakkkkkk"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // ⚡ Java 8 + desugaring
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    // ⚡ Kotlin juga di 1.8 supaya konsisten
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        applicationId = "com.example.pajakkkkkk"
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

dependencies {
    // ⚡ Upgrade core library desugaring supaya compatible flutter_local_notifications terbaru
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Tambahkan dependency lain sesuai kebutuhan project
    // implementation("...")
}

flutter {
    source = "../.."
}
