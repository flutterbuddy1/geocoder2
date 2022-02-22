import 'package:geocoder2/src/modal/data.dart';
import 'package:geocoder2/src/modal/fetch_geocoder.dart';
import 'package:http/http.dart' as http;

class Geocoder2 {
  static Future<GeoData> getDataFromCoordinates(
      {required double latitude,
      required double longitude,
      required String googleMapApiKey}) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude},${longitude}&key=${googleMapApiKey}'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      FetchGeocoder fetch = fetchGeocoderFromJson(data);
      String city = "";
      String country = "";
      String postalCode = "";
      String state = "";
      double street_number = 0;
      var addressComponent = fetch.results.first.addressComponents;
      for (var i = 0; i < addressComponent.length; i++) {
        if (addressComponent[i].types.contains("administrative_area_level_2")) {
          city = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("country")) {
          country = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("postal_code")) {
          postalCode = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("administrative_area_level_1")) {
          state = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("street_number")) {
          street_number = double.parse(addressComponent[i].longName);
        }
      }

      return GeoData(
          address: fetch.results.first.formattedAddress,
          city: city,
          country: country,
          latitude: latitude,
          longitude: longitude,
          postalCode: postalCode,
          state: state,
          street_number: street_number);
    } else {
      return null as GeoData;
    }
  }

  static Future<GeoData> getDataFromAddress({
    required String address,
    required String googleMapApiKey,
  }) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=${googleMapApiKey}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      FetchGeocoder fetch = fetchGeocoderFromJson(data);
      String city = "";
      String country = "";
      String postalCode = "";
      String state = "";
      double street_number = 0;
      var addressComponent = fetch.results.first.addressComponents;
      for (var i = 0; i < addressComponent.length; i++) {
        if (addressComponent[i].types.contains("administrative_area_level_2")) {
          city = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("country")) {
          country = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("postal_code")) {
          postalCode = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("administrative_area_level_1")) {
          state = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("street_number")) {
          street_number = double.parse(addressComponent[i].longName);
        }
      }

      return GeoData(
          address: fetch.results.first.formattedAddress,
          city: city,
          country: country,
          latitude: fetch.results.first.geometry.location.lat,
          longitude: fetch.results.first.geometry.location.lng,
          postalCode: postalCode,
          state: state,
          street_number: street_number);
    } else {
      return null as GeoData;
    }
  }
}
