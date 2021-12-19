import 'package:geocoder2/src/modal/fetch_geocoder.dart';
import 'package:http/http.dart' as http;

class Geocoder2 {
  static Future<FetchGeocoder> getAddressFromCoordinates(
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
      return fetchGeocoderFromJson(data);
    } else {
      return null as FetchGeocoder;
    }
  }

  static Future<FetchGeocoder> getCoordinatesFromAddress({
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
      return fetchGeocoderFromJson(data);
    } else {
      return null as FetchGeocoder;
    }
  }
}
