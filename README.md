# geocoder2
**Forward and reverse geocodeing is easy now**

## Features

* Easy To Use
* No Errors

## Code Example
```dart
import 'package:geocoder2/geocoder2.dart';
```

## Get Address
```dart
    FetchGeocoder fetchGeocoder = await Geocoder2.getAddressFromCoordinates(
        latitude: 40.714224,
        longitude: -73.961452,
        googleMapApiKey: "GOOGLE_MAP_API_KEY");
    var first = fetchGeocoder.results.first;
    print(first.formattedAddress);
```
## Get Coordinates
```dart
    FetchGeocoder fetchGeocoder = await Geocoder2.getCoordinatesFromAddress(
        address: "277 Bedford Ave, Brooklyn, NY 11211, USA",
        googleMapApiKey: "GOOGLE_MAP_API_KEY");
    var first = fetchGeocoder.results.first;
    print("${first.geometry.location.lat} , ${first.geometry.location.lng}");
```