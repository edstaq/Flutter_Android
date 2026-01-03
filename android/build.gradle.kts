    buildscript {
        repositories {
            google() // For Google-specific dependencies like Android Gradle Plugin
            mavenCentral() // For general Maven Central artifacts
        }
        // ...
        dependencies {
            classpath("com.android.tools.build:gradle:8.5.1") // Example: Android Gradle Plugin
            classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.0") // Example: Kotlin Gradle Plugin
            classpath("com.google.gms:google-services:4.4.2") // Example: Kotlin Gradle Plugin
            classpath("com.google.firebase:firebase-crashlytics-gradle:2.9.9") // Example: Kotlin Gradle Plugin
        }
    }

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
