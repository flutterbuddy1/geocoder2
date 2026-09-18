# geocoder2

**Easy forward and reverse geocoding from the Google Maps Geocoding API for Flutter & Dart.**

Make sure to enable the **Geocoding API** for your project in the <a href="https://console.cloud.google.com">Google Cloud Console</a>.

---

## Features

- 🚀 **Modern & Compatible**: Supports Flutter 3.x and Dart 3.x with `http: ">=0.13.4 <2.0.0"`.
- 🔍 **Forward Geocoding**: Convert address strings into coordinates and structured location data.
- 📍 **Reverse Geocoding**: Convert latitude and longitude coordinates into human-readable addresses.
- 📋 **Multiple Results Support**: Retrieve all matching address candidates via `getAllDataFromAddress` / `getAllDataFromCoordinates`.
- 🛡️ **Zero Runtime Crashes**: Full null-safety protection against missing fields, unknown location types, and empty results.
- ⚠️ **Clear Exception Handling**: Structured `Geocoder2Exception` provides Google API status codes (`REQUEST_DENIED`, `OVER_QUERY_LIMIT`, `ZERO_RESULTS`, etc.) and error messages.
- 🌐 **Localization**: Request address components in your preferred language using the optional `language` parameter.

---

## Installation

Add `geocoder2` to your `pubspec.yaml`:

```yaml
dependencies:
  geocoder2: ^1.5.0
```

---

## Code Examples

```dart
import 'package:geocoder2/geocoder2.dart';
```

### Reverse Geocoding (Coordinates to Address)

```dart
try {
  GeoData data = await Geocoder2.getDataFromCoordinates(
    latitude: 40.714224,
    longitude: -73.961452,
    googleMapApiKey: "YOUR_GOOGLE_MAP_API_KEY",
    language: "en", // Optional language code
  );

  print("Address: ${data.address}");
  print("City: ${data.city}");
  print("State: ${data.state}");
  print("Country: ${data.country} (${data.countryCode})");
  print("Postal Code: ${data.postalCode}");
  print("Street Number: ${data.streetNumber}");
  print("Latitude: ${data.latitude}");
  print("Longitude: ${data.longitude}");
} on Geocoder2Exception catch (e) {
  print("Geocoding failed: ${e.message} (Status: ${e.status})");
}
```

### Forward Geocoding (Address to Coordinates)

```dart
try {
  GeoData data = await Geocoder2.getDataFromAddress(
    address: "277 Bedford Ave, Brooklyn, NY 11211, USA",
    googleMapApiKey: "YOUR_GOOGLE_MAP_API_KEY",
  );

  print("Formatted Address: ${data.address}");
  print("Latitude: ${data.latitude}");
  print("Longitude: ${data.longitude}");
  print("City: ${data.city}");
} on Geocoder2Exception catch (e) {
  print("Geocoding failed: ${e.message} (Status: ${e.status})");
}
```

### Get Multiple Address Matches

```dart
List<GeoData> results = await Geocoder2.getAllDataFromAddress(
  address: "Springfield",
  googleMapApiKey: "YOUR_GOOGLE_MAP_API_KEY",
);

for (var result in results) {
  print("${result.address} -> (${result.latitude}, ${result.longitude})");
}
```

### Safe Nullable Queries

If you prefer `null` over catching an exception when no results exist:

```dart
GeoData? data = await Geocoder2.getDataFromAddressOrNull(
  address: "Some Rare Location",
  googleMapApiKey: "YOUR_GOOGLE_MAP_API_KEY",
);

if (data != null) {
  print("Found: ${data.address}");
} else {
  print("No address found.");
}
```

---

## Language Support

Both forward and reverse methods support an optional `language` parameter. See the [list of supported Google Maps language codes](https://developers.google.com/maps/faq#languagesupport).

---

## Alternative (OpenStreetMap / No API Key)

If you do not have a Google Maps API Key or want to use free OpenStreetMap Nominatim, check out [geocoder_buddy](https://pub.dev/packages/geocoder_buddy).

---

## Buy Me A Coffee

<a href="https://www.buymeacoffee.com/flutterbuddy">
  <img src="https://www.buymeacoffee.com/assets/img/guidelines/download-assets-1.svg" height="50" alt="Buy Me A Coffee">
</a>
