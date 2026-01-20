# Google Places SDK Plus

A powerful and type-safe Flutter plugin for the Google Places SDK. This plugin wraps the official Google Places SDKs to provide a unified Dart API, making it easy to integrate place search, details, and photos into your Flutter application.

## 🚀 Features

- **Autocomplete Predictions**: Get place suggestions as users type.
- **Fetch Place Details**: Retrieve comprehensive information about a specific place.
- **Text Search**: Search for places using a text query.
- **Nearby Search**: Find places near a specific location.
- **Photo Support**: Fetch and display high-quality photos of places.
- **Type Safety**: Built with [Pigeon](https://pub.dev/packages/pigeon) for robust, type-safe platform communication.

## 🏛 Architecture

`google_places_sdk_plus` is architected as a Flutter plugin that uses **Pigeon** as its core communication layer.

- **Dart Layer**: Provides a clean, object-oriented API for Flutter developers. It uses Pigeon-generated classes to ensure that data passed between Dart and Native code is always valid and consistent.
- **Pigeon Integration**: Defines the API contract in `pigeon/google_places_sdk.dart`. Pigeon generates the glue code for Dart, Kotlin, and Swift (planned), eliminating boilerplate and reducing the risk of runtime errors.
- **Native Implementation (Android)**: Directly interacts with the official Google Places SDK for Android (`com.google.android.libraries.places:places`). It handles complex data mapping between native Android models and Pigeon-generated models.
- **Expansion Ready**: The project is structured to easily add iOS and Web support by implementing the defined Pigeon interfaces on those platforms.

## 📊 Platform Support Matrix

| Feature              | Android | iOS | Web |
| :------------------- | :-----: | :-: | :-: |
| **Initialize SDK**   |   ✅    | 🛠  | 🛠  |
| **Fetch Place**      |   ✅    | 🛠  | 🛠  |
| **Search by Text**   |   ✅    | 🛠  | 🛠  |
| **Search by Nearby** |   ✅    | 🛠  | 🛠  |
| **Fetch Photo**      |   ✅    | 🛠  | 🛠  |
| **Autocomplete**     |   ✅    | 🛠  | 🛠  |

_Legend: ✅ = Supported, 🛠 = In Progress / Planned_

## 🛠 Getting Started

### 1. Requirements

- A Google Cloud Project with the **Places API (New)** enabled.
- An API Key from the Google Cloud Console.

### 2. Installation

Add `google_places_sdk_plus` to your `pubspec.yaml`:

```yaml
dependencies:
  google_places_sdk_plus:
    path: ../google_places_sdk_plus # Use path during development
```

### 3. Platform Setup

#### Android

Ensure your `minSdkVersion` is at least **23** in `android/app/build.gradle`.

```gradle
android {
    defaultConfig {
        minSdkVersion 23
    }
}
```

Add the `INTERNET` permission to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## 📖 Usage

### Initialization

Initialize the SDK with your API key before making any requests.

```dart
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';

final _placesApi = PlacesHostApi();
await _placesApi.initialize("YOUR_GOOGLE_MAPS_API_KEY");
```

### Fetch Place Details

Request specific fields to optimize data usage and costs.

```dart
final response = await _placesApi.fetchPlace(
  FetchPlaceRequest(
    placeId: "ChIJN1t_tDeuEmsRUsoyG83frY4",
    placeFields: [
      PlaceField.DISPLAY_NAME,
      PlaceField.FORMATTED_ADDRESS,
      PlaceField.LOCATION,
      PlaceField.RATING,
    ],
  ),
);

final place = response.place;
print("Place Name: ${place.displayName}");
print("Rating: ${place.rating}");
```

### Search by Text

```dart
final response = await _placesApi.searchByText(
  SearchByTextRequest(
    textQuery: "Pizza in San Francisco",
    placeFields: [PlaceField.DISPLAY_NAME, PlaceField.FORMATTED_ADDRESS],
    maxResultCount: 5,
  ),
);

for (var place in response.places) {
  print("Found: ${place?.displayName}");
}
```

### Autocomplete Predictions

```dart
final response = await _placesApi.findAutocompletePredictions(
  FindAutocompletePredictionsRequest(query: "Goo"),
);

for (var prediction in response.predictions) {
  print("Prediction: ${prediction?.fullText}");
}
```

## 📱 Example Project

The `example` directory contains a complete Flutter application demonstrating all the features of the plugin.

To run the example:

1.  **Clone the repository** (if you haven't already).
2.  **Navigate to the example directory**:
    ```bash
    cd example
    ```
3.  **Run the application**:
    ```bash
    flutter run
    ```
4.  **Enter your API Key** in the app's initialization card to start testing.

### VS Code Launch Setup

For a faster development workflow, you can use the included VS Code launch configuration to pre-populate your API key:

1.  **Create a `.env.json` file** in the root directory of the project:
    ```json
    {
      "GOOGLE_PLACES_API_KEY": "YOUR_API_KEY_HERE"
    }
    ```
2.  In VS Code, go to the **Run and Debug** view (`Ctrl+Shift+D`).
3.  Select **"Example with .env.json"** from the configuration dropdown.
4.  Press **F5** to run.

> Make sure your API key has the **Places API (New)** enabled in the Google Cloud Console.

## 🛠 Development

### Regenerating Pigeon Code

If you modify the Pigeon interface in `pigeon/google_places_sdk.dart`, you need to regenerate the Dart and Native code:

```bash
dart run pigeon --input pigeon/google_places_sdk.dart
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
