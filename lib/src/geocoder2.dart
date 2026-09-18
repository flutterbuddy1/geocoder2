import 'package:geocoder2/src/modal/data.dart';
import 'package:geocoder2/src/modal/fetch_geocoder.dart';
import 'package:geocoder2/src/modal/geocoder2_exception.dart';
import 'package:http/http.dart' as http;

class Geocoder2 {
  /// Get City, Country, postalCode, state, streetNumber and countryCode from latitude and longitude.
  ///
  /// Throws a [Geocoder2Exception] if the Google Geocoding API returns an error status
  /// (e.g. `REQUEST_DENIED`, `ZERO_RESULTS`, `OVER_QUERY_LIMIT`) or if the HTTP request fails.
  static Future<GeoData> getDataFromCoordinates({
    required double latitude,
    required double longitude,
    required String googleMapApiKey,
    String? language,
    http.Client? client,
  }) async {
    final results = await getAllDataFromCoordinates(
      latitude: latitude,
      longitude: longitude,
      googleMapApiKey: googleMapApiKey,
      language: language,
      client: client,
    );
    if (results.isEmpty) {
      throw const Geocoder2Exception(
        'No geocoding results found for the given coordinates.',
        status: 'ZERO_RESULTS',
      );
    }
    return results.first;
  }

  /// Get City, Country, postalCode, state, streetNumber and countryCode from coordinates,
  /// or `null` if no results were found (`ZERO_RESULTS`).
  ///
  /// Throws [Geocoder2Exception] for authorization failures, invalid requests, or quota issues.
  static Future<GeoData?> getDataFromCoordinatesOrNull({
    required double latitude,
    required double longitude,
    required String googleMapApiKey,
    String? language,
    http.Client? client,
  }) async {
    try {
      final results = await getAllDataFromCoordinates(
        latitude: latitude,
        longitude: longitude,
        googleMapApiKey: googleMapApiKey,
        language: language,
        client: client,
      );
      return results.isNotEmpty ? results.first : null;
    } on Geocoder2Exception catch (e) {
      if (e.status == 'ZERO_RESULTS') {
        return null;
      }
      rethrow;
    }
  }

  /// Returns all matching [GeoData] addresses for the given coordinates.
  static Future<List<GeoData>> getAllDataFromCoordinates({
    required double latitude,
    required double longitude,
    required String googleMapApiKey,
    String? language,
    http.Client? client,
  }) async {
    final queryParameters = <String, String>{
      'latlng': '$latitude,$longitude',
      'key': googleMapApiKey,
      if (language != null && language.isNotEmpty) 'language': language,
    };

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      queryParameters,
    );

    return _executeRequest(
      uri,
      client: client,
      fallbackLat: latitude,
      fallbackLng: longitude,
    );
  }

  /// Get City, Country, postalCode, state, streetNumber and countryCode from an address string
  /// like "277 Bedford Ave, Brooklyn, NY 11211, USA".
  ///
  /// Throws a [Geocoder2Exception] if the Google Geocoding API returns an error status
  /// (e.g. `REQUEST_DENIED`, `ZERO_RESULTS`, `OVER_QUERY_LIMIT`) or if the HTTP request fails.
  static Future<GeoData> getDataFromAddress({
    required String address,
    required String googleMapApiKey,
    String? language,
    http.Client? client,
  }) async {
    final results = await getAllDataFromAddress(
      address: address,
      googleMapApiKey: googleMapApiKey,
      language: language,
      client: client,
    );
    if (results.isEmpty) {
      throw const Geocoder2Exception(
        'No geocoding results found for the given address.',
        status: 'ZERO_RESULTS',
      );
    }
    return results.first;
  }

  /// Get City, Country, postalCode, state, streetNumber and countryCode from an address,
  /// or `null` if no results were found (`ZERO_RESULTS`).
  ///
  /// Throws [Geocoder2Exception] for authorization failures, invalid requests, or quota issues.
  static Future<GeoData?> getDataFromAddressOrNull({
    required String address,
    required String googleMapApiKey,
    String? language,
    http.Client? client,
  }) async {
    try {
      final results = await getAllDataFromAddress(
        address: address,
        googleMapApiKey: googleMapApiKey,
        language: language,
        client: client,
      );
      return results.isNotEmpty ? results.first : null;
    } on Geocoder2Exception catch (e) {
      if (e.status == 'ZERO_RESULTS') {
        return null;
      }
      rethrow;
    }
  }

  /// Returns all matching [GeoData] addresses for the given address query.
  static Future<List<GeoData>> getAllDataFromAddress({
    required String address,
    required String googleMapApiKey,
    String? language,
    http.Client? client,
  }) async {
    final queryParameters = <String, String>{
      'address': address,
      'key': googleMapApiKey,
      if (language != null && language.isNotEmpty) 'language': language,
    };

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      queryParameters,
    );

    return _executeRequest(uri, client: client);
  }

  /// Convenience alias for [getDataFromAddress].
  static Future<GeoData> getCoordinatesFromAddress({
    required String address,
    required String googleMapApiKey,
    String? language,
    http.Client? client,
  }) =>
      getDataFromAddress(
        address: address,
        googleMapApiKey: googleMapApiKey,
        language: language,
        client: client,
      );

  /// Convenience alias for [getDataFromCoordinates].
  static Future<GeoData> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
    required String googleMapApiKey,
    String? language,
    http.Client? client,
  }) =>
      getDataFromCoordinates(
        latitude: latitude,
        longitude: longitude,
        googleMapApiKey: googleMapApiKey,
        language: language,
        client: client,
      );

  static Future<List<GeoData>> _executeRequest(
    Uri uri, {
    http.Client? client,
    double? fallbackLat,
    double? fallbackLng,
  }) async {
    final httpClient = client ?? http.Client();
    final bool shouldClose = client == null;

    try {
      final response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw Geocoder2Exception(
          'HTTP request failed with status code ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final fetch = fetchGeocoderFromJson(response.body);

      if (fetch.status == 'OK') {
        return fetch.results
            .map((r) => _parseResultToGeoData(
                  r,
                  fallbackLat: fallbackLat,
                  fallbackLng: fallbackLng,
                ))
            .toList();
      } else if (fetch.status == 'ZERO_RESULTS') {
        return <GeoData>[];
      } else {
        final message = fetch.errorMessage != null && fetch.errorMessage!.isNotEmpty
            ? fetch.errorMessage!
            : 'Google Maps Geocoding API returned status: ${fetch.status}';
        throw Geocoder2Exception(
          message,
          status: fetch.status,
          statusCode: response.statusCode,
        );
      }
    } finally {
      if (shouldClose) {
        httpClient.close();
      }
    }
  }

  static GeoData _parseResultToGeoData(
    Result result, {
    double? fallbackLat,
    double? fallbackLng,
  }) {
    String city = '';
    String country = '';
    String postalCode = '';
    String state = '';
    String streetNumber = '';
    String countryCode = '';

    String? locality;
    String? sublocality;
    String? postalTown;
    String? adminArea2;
    String? adminArea3;

    for (final component in result.addressComponents) {
      final types = component.types;
      if (types.contains('locality')) {
        locality = component.longName;
      }
      if (types.contains('sublocality') ||
          types.contains('sublocality_level_1')) {
        sublocality = component.longName;
      }
      if (types.contains('postal_town')) {
        postalTown = component.longName;
      }
      if (types.contains('administrative_area_level_2')) {
        adminArea2 = component.longName;
      }
      if (types.contains('administrative_area_level_3')) {
        adminArea3 = component.longName;
      }
      if (types.contains('country')) {
        country = component.longName;
        countryCode = component.shortName;
      }
      if (types.contains('postal_code')) {
        postalCode = component.longName;
      }
      if (types.contains('administrative_area_level_1')) {
        state = component.longName;
      }
      if (types.contains('street_number')) {
        streetNumber = component.longName;
      }
    }

    // Google Geocoding city resolution hierarchy:
    city = locality ??
        sublocality ??
        postalTown ??
        adminArea2 ??
        adminArea3 ??
        '';

    final lat = result.geometry.location.lat != 0.0
        ? result.geometry.location.lat
        : (fallbackLat ?? 0.0);
    final lng = result.geometry.location.lng != 0.0
        ? result.geometry.location.lng
        : (fallbackLng ?? 0.0);

    return GeoData(
      address: result.formattedAddress,
      city: city,
      country: country,
      latitude: lat,
      longitude: lng,
      postalCode: postalCode,
      state: state,
      streetNumber: streetNumber,
      countryCode: countryCode,
      addressComponents: result.addressComponents,
      types: result.types,
      placeId: result.placeId,
    );
  }
}
