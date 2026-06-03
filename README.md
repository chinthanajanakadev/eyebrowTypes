# Eyebrow Type (Kotlin Compose)

This project is a high-performance native Android application for eyebrow type classification, featuring advanced AI processing, a refined sharing engine, and comprehensive ad integration.

## Features
- **AI Eyebrow Classification**: Uses Google ML Kit with a custom TFLite model for real-time eyebrow shape detection.
- **Modern UI/UX**:
    - Built with **Jetpack Compose** and **Material 3**.
    - Stylish **Pink Theme** (`#FFFF4081`) matching the app's aesthetic.
    - Full-screen image preview and interactive confidence charts.
- **Advanced Sharing Engine**:
    - Generates 1080p high-resolution result images.
    - Custom-drawn layout including a vertical confidence chart with pill-shaped bars, 0-50-100 scale, and the original photo.
- **Image Processing**:
    - Camera and Gallery integration with runtime permission handling.
    - Integrated **uCrop** with custom theme matching for precise image editing.
- **AdMob Monetization**:
    - **App Open Ads**: Shown on app start (with a 30-second background delay logic).
    - **Native Ads**: Integrated with a custom template featuring a 120x120 MediaView for image and video support.
    - **Interstitial Ads**: Displayed before sharing results.
- **MVVM Architecture**: Clean, maintainable code using StateFlow and ViewModels.

## Technical Details
- **Language**: Kotlin
- **UI Framework**: Jetpack Compose
- **SDK Version**:
    - Minimum SDK: 24
    - Target SDK: 36
    - Compile SDK: 36
- **Key Libraries**:
    - `com.google.mlkit:image-labeling-custom`: AI classification.
    - `com.google.android.gms:play-services-ads`: AdMob integration (Native, App Open, Interstitial).
    - `androidx.lifecycle:lifecycle-process`: Lifecycle-aware ad management.
    - `com.github.yalantis:ucrop`: Customized image cropping.
    - `io.coil-kt:coil-compose`: Image loading.

## Getting Started
1. Open this project in Android Studio.
2. Ensure you have the `model.tflite` and `eye.jpg` assets in the `assets` folder.
3. AdMob IDs are centralized in `res/values/strings.xml` for easy configuration.
4. Sync Gradle and run the application.

## Privacy Policy
The app's privacy policy can be found [here](https://simpleappcreator.blogspot.com/p/privacy-policy-eyebrow-type_16.html).
