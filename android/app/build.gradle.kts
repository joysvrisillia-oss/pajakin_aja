plugins {
    id("com.android.application")
<<<<<<< HEAD
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
=======
    id("org.jetbrains.kotlin.android")
>>>>>>> 1430f5cddce99cb320d408ffac2c47989ea3b856
    id("dev.flutter.flutter-gradle-plugin")
}

android {
<<<<<<< HEAD
    namespace = "com.example.mobileprogramming_aplikasi_kalkulator_digital_pajakin_aja"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.mobileprogramming_aplikasi_kalkulator_digital_pajakin_aja"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
=======
    namespace = "com.example.pajakin_aja"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.pajakin_aja"
        minSdkVersion flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
>>>>>>> 1430f5cddce99cb320d408ffac2c47989ea3b856
    }

    buildTypes {
        release {
<<<<<<< HEAD
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
=======
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
>>>>>>> 1430f5cddce99cb320d408ffac2c47989ea3b856
}

flutter {
    source = "../.."
}
<<<<<<< HEAD
=======

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
}
otlin:kotlin-stdlib")
}
>>>>>>> 1430f5cddce99cb320d408ffac2c47989ea3b856
