import 'package:geocoder2/src/modal/fetch_geocoder.dart';

/// Model class representing geocoded address data.
class GeoData {
  GeoData({
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
    required this.state,
    required this.countryCode,
    required this.streetNumber,
    this.addressComponents,
    this.types,
    this.placeId,
  });

  String address;
  String city;
  String country;
  double latitude;
  double longitude;
  String postalCode;
  String state;
  String countryCode;
  String streetNumber;

  /// Full list of raw address components returned by Google Maps Geocoding API.
  final List<AddressComponent>? addressComponents;

  /// Types of the geocoded location (e.g. 'street_address', 'premise').
  final List<String>? types;

  /// Unique place ID assigned by Google Maps.
  final String? placeId;

  /// Backward-compatible alias for [streetNumber] as documented in earlier README examples.
  // ignore: non_constant_identifier_names
  String get street_number => streetNumber;

  // ignore: non_constant_identifier_names
  set street_number(String value) {
    streetNumber = value;
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'city': city,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'postalCode': postalCode,
        'state': state,
        'countryCode': countryCode,
        'streetNumber': streetNumber,
        if (placeId != null) 'placeId': placeId,
        if (types != null) 'types': types,
      };

  @override
  String toString() =>
      'GeoData(address: $address, city: $city, country: $country, countryCode: $countryCode, latitude: $latitude, longitude: $longitude, postalCode: $postalCode, state: $state, streetNumber: $streetNumber)';
}
