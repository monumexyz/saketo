# Saketo

Saketo is a mobile Monero wallet. It isn't based on any existing wallet and is written from scratch. It is written in Dart and uses the Flutter framework.

The first mobile Monero wallet that uses Rust to handle Monero transactions.

# Building

To build Saketo, you need to have Flutter and Rust installed. You can find instructions on how to install Flutter [here](https://flutter.dev/docs/get-started/install).

1 - Build libsaketo
```bash
cd rust && cargo ndk -t arm64-v8a -t armeabi-v7a -o ./../android/app/src/main/jniLibs build --release
```

2 - Generate `.g.dart` files
```bash
dart run build_runner build
```

3 - Generate localization files
```bash
flutter gen-l10n
```

Then you can build or run the app in Android Studio.