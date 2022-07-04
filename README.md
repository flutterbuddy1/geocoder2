# geocoder2

**Easy forward and reverse geocodeing From google maps api**
make sure to activate Maps SDK for android and ios and geocode api from <a GCP href="(https://console.cloud.google.com)">


## Features

* Easy To Use
* No Errors

## Code Example
```dart
import 'package:geocoder2/geocoder2.dart';
```

## Get Data Form Coordinates
```dart
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: 40.714224,
        longitude: -73.961452,
        googleMapApiKey: "GOOGLE_MAP_API_KEY");
    
    //Formated Address
    print(data.address);
    //City Name
    print(data.city);
    //Country Name
    print(data.country);
    //Country Code
    print(data.countryCode);
    //Latitude
    print(data.latitude);
    //Longitude
    print(data.longitude);
    //Postal Code
    print(data.postalCode);
    //State
    print(data.state);
    //Street Number
    print(data.street_number);

```
## Get Data From Address
```dart
    GeoData data = await Geocoder2.getDataFromAddress(
        address: "277 Bedford Ave, Brooklyn, NY 11211, USA",
        googleMapApiKey: "GOOGLE_MAP_API_KEY");
    
    //Formated Address
    print(data.address);
    //City Name
    print(data.city);
    //Country Name
    print(data.country);
    //Country Code
    print(data.countryCode);
    //Latitude
    print(data.latitude);
    //Longitude
    print(data.longitude);
    //Postal Code
    print(data.postalCode);
    //State
    print(data.state);
    //Street Number
    print(data.street_number);
```

### Buy Me A Coffee

<a href="https://www.buymeacoffee.com/flutterbuddy">
<img src="https://www.buymeacoffee.com/assets/img/guidelines/download-assets-1.svg" height="50" target="_flutterbuddy">
</a>

### Buy Me A Coffee Using PhonePe
<img src="https://flutterbuddy.in/payment.jpg" height="200">
