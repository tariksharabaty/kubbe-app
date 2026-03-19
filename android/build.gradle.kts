allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    plugins.withId("com.android.library") {
        configureAndroidNamespace()
    }
    plugins.withId("com.android.application") {
        configureAndroidNamespace()
    }
}

fun Project.configureAndroidNamespace() {
    val android = extensions.findByName("android")
    if (android is com.android.build.gradle.BaseExtension) {
        // TR: isar_flutter_libs manifest'te "package" tanımladığı için namespace çakışması olabiliyor.
        // EN: isar_flutter_libs defines "package" in manifest, which might cause namespace collision.
        if (project.name == "isar_flutter_libs") {
            // TR: isar_flutter_libs için varsayılan namespace ata
            // EN: Assign default namespace for isar_flutter_libs
            android.namespace = "dev.isar.isar_flutter_libs"
        } else if (android.namespace == null) {
            android.namespace = "com.kubbe." + project.name.replace("-", ".").replace("_", ".")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
