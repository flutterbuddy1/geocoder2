import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:http/http.dart' as http;

class MockClient extends http.BaseClient {
  final Future<http.Response> Function(http.Request request) handler;

  MockClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await handler(request as http.Request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
    );
  }
}

void main() {
  const sampleSuccessJson = '''
{
  "results": [
    {
      "address_components": [
        {
          "long_name": "277",
          "short_name": "277",
          "types": ["street_number"]
        },
        {
          "long_name": "Bedford Avenue",
          "short_name": "Bedford Ave",
          "types": ["route"]
        },
        {
          "long_name": "Williamsburg",
          "short_name": "Williamsburg",
          "types": ["neighborhood", "political"]
        },
        {
          "long_name": "Brooklyn",
          "short_name": "Brooklyn",
          "types": ["sublocality", "sublocality_level_1", "political"]
        },
        {
          "long_name": "New York",
          "short_name": "New York",
          "types": ["locality", "political"]
        },
        {
          "long_name": "Kings County",
          "short_name": "Kings County",
          "types": ["administrative_area_level_2", "political"]
        },
        {
          "long_name": "New York",
          "short_name": "NY",
          "types": ["administrative_area_level_1", "political"]
        },
        {
          "long_name": "United States",
          "short_name": "US",
          "types": ["country", "political"]
        },
        {
          "long_name": "11211",
          "short_name": "11211",
          "types": ["postal_code"]
        }
      ],
      "formatted_address": "277 Bedford Ave, Brooklyn, NY 11211, USA",
      "geometry": {
        "location": {
          "lat": 40.714224,
          "lng": -73.961452
        },
        "location_type": "ROOFTOP"
      },
      "place_id": "ChIJd8BlQ2BZwokRAFUEcm_qrcA",
      "types": ["street_address"]
    }
  ],
  "status": "OK"
}
''';

  const sampleMultipleResultsJson = '''
{
  "results": [
    {
      "address_components": [
        {
          "long_name": "Springfield",
          "short_name": "Springfield",
          "types": ["locality"]
        },
        {
          "long_name": "Illinois",
          "short_name": "IL",
          "types": ["administrative_area_level_1"]
        },
        {
          "long_name": "United States",
          "short_name": "US",
          "types": ["country"]
        }
      ],
      "formatted_address": "Springfield, IL, USA",
      "geometry": {
        "location": {
          "lat": 39.7817,
          "lng": -89.6501
        },
        "location_type": "APPROXIMATE"
      },
      "place_id": "ChIJp2t0q-M5d4gR1f5N-8V6Z-A",
      "types": ["locality"]
    },
    {
      "address_components": [
        {
          "long_name": "Springfield",
          "short_name": "Springfield",
          "types": ["locality"]
        },
        {
          "long_name": "Massachusetts",
          "short_name": "MA",
          "types": ["administrative_area_level_1"]
        },
        {
          "long_name": "United States",
          "short_name": "US",
          "types": ["country"]
        }
      ],
      "formatted_address": "Springfield, MA, USA",
      "geometry": {
        "location": {
          "lat": 42.1015,
          "lng": -72.5898
        },
        "location_type": "APPROXIMATE"
      },
      "place_id": "ChIJy-T1YV8W54kRzLzD9vV8H-g",
      "types": ["locality"]
    }
  ],
  "status": "OK"
}
''';

  group('Geocoder2 Successful Requests & Parsing', () {
    test('getDataFromCoordinates parses result correctly', () async {
      final client = MockClient((request) async {
        expect(request.url.host, 'maps.googleapis.com');
        expect(request.url.path, '/maps/api/geocode/json');
        expect(request.url.queryParameters['latlng'], '40.714224,-73.961452');
        expect(request.url.queryParameters['key'], 'TEST_KEY');
        expect(request.url.queryParameters['language'], 'en');
        return http.Response(sampleSuccessJson, 200);
      });

      final data = await Geocoder2.getDataFromCoordinates(
        latitude: 40.714224,
        longitude: -73.961452,
        googleMapApiKey: 'TEST_KEY',
        language: 'en',
        client: client,
      );

      expect(data.address, '277 Bedford Ave, Brooklyn, NY 11211, USA');
      expect(data.city, 'New York');
      expect(data.country, 'United States');
      expect(data.countryCode, 'US');
      expect(data.latitude, 40.714224);
      expect(data.longitude, -73.961452);
      expect(data.postalCode, '11211');
      expect(data.state, 'New York');
      expect(data.streetNumber, '277');
      expect(data.street_number, '277'); // Backwards compatibility for README
      expect(data.placeId, 'ChIJd8BlQ2BZwokRAFUEcm_qrcA');
      expect(data.types, contains('street_address'));
    });

    test('getDataFromAddress parses result correctly', () async {
      final client = MockClient((request) async {
        expect(request.url.queryParameters['address'], '277 Bedford Ave, Brooklyn, NY 11211, USA');
        expect(request.url.queryParameters['key'], 'TEST_KEY');
        return http.Response(sampleSuccessJson, 200);
      });

      final data = await Geocoder2.getDataFromAddress(
        address: '277 Bedford Ave, Brooklyn, NY 11211, USA',
        googleMapApiKey: 'TEST_KEY',
        client: client,
      );

      expect(data.address, '277 Bedford Ave, Brooklyn, NY 11211, USA');
      expect(data.city, 'New York');
      expect(data.streetNumber, '277');
      expect(data.street_number, '277');
    });

    test('Convenience aliases match primary methods', () async {
      final client = MockClient((request) async {
        return http.Response(sampleSuccessJson, 200);
      });

      final fromAddr = await Geocoder2.getCoordinatesFromAddress(
        address: '277 Bedford Ave',
        googleMapApiKey: 'TEST_KEY',
        client: client,
      );
      expect(fromAddr.latitude, 40.714224);

      final fromCoord = await Geocoder2.getAddressFromCoordinates(
        latitude: 40.714224,
        longitude: -73.961452,
        googleMapApiKey: 'TEST_KEY',
        client: client,
      );
      expect(fromCoord.address, '277 Bedford Ave, Brooklyn, NY 11211, USA');
    });

    test('getAllDataFromAddress returns multiple results (Fixes #15, #9)', () async {
      final client = MockClient((request) async {
        return http.Response(sampleMultipleResultsJson, 200);
      });

      final results = await Geocoder2.getAllDataFromAddress(
        address: 'Springfield',
        googleMapApiKey: 'TEST_KEY',
        client: client,
      );

      expect(results.length, 2);
      expect(results[0].address, 'Springfield, IL, USA');
      expect(results[0].state, 'Illinois');
      expect(results[1].address, 'Springfield, MA, USA');
      expect(results[1].state, 'Massachusetts');
    });

    test('Properly URL encodes query parameters with spaces and special symbols (Fixes #11)', () async {
      late Uri capturedUri;
      final client = MockClient((request) async {
        capturedUri = request.url;
        return http.Response(sampleSuccessJson, 200);
      });

      await Geocoder2.getDataFromAddress(
        address: 'Café & Restaurant #42, Avenue Montaigne',
        googleMapApiKey: 'KEY_123',
        language: 'fr',
        client: client,
      );

      expect(capturedUri.queryParameters['address'], 'Café & Restaurant #42, Avenue Montaigne');
      expect(capturedUri.queryParameters['language'], 'fr');
      // The raw query string must not contain unencoded illegal chars
      expect(capturedUri.toString(), contains('Caf%C3%A9'));
    });
  });

  group('Error Handling and Zero Results (Fixes #1, #2, #3, #17, #20)', () {
    test('Throws Geocoder2Exception on ZERO_RESULTS without Bad state: No element crash', () async {
      final client = MockClient((request) async {
        return http.Response(json.encode({"results": [], "status": "ZERO_RESULTS"}), 200);
      });

      expect(
        () => Geocoder2.getDataFromCoordinates(
          latitude: 0.0,
          longitude: 0.0,
          googleMapApiKey: 'KEY',
          client: client,
        ),
        throwsA(isA<Geocoder2Exception>().having((e) => e.status, 'status', 'ZERO_RESULTS')),
      );

      expect(
        () => Geocoder2.getDataFromAddress(
          address: 'Non-existent Address 99999999',
          googleMapApiKey: 'KEY',
          client: client,
        ),
        throwsA(isA<Geocoder2Exception>().having((e) => e.status, 'status', 'ZERO_RESULTS')),
      );
    });

    test('getAllDataFromAddress returns empty list on ZERO_RESULTS without throwing', () async {
      final client = MockClient((request) async {
        return http.Response(json.encode({"results": [], "status": "ZERO_RESULTS"}), 200);
      });

      final results = await Geocoder2.getAllDataFromAddress(
        address: 'Non-existent',
        googleMapApiKey: 'KEY',
        client: client,
      );

      expect(results, isEmpty);
    });

    test('getDataFromAddressOrNull returns null on ZERO_RESULTS without throwing', () async {
      final client = MockClient((request) async {
        return http.Response(json.encode({"results": [], "status": "ZERO_RESULTS"}), 200);
      });

      final result = await Geocoder2.getDataFromAddressOrNull(
        address: 'Non-existent',
        googleMapApiKey: 'KEY',
        client: client,
      );

      expect(result, isNull);
    });

    test('REQUEST_DENIED throws Geocoder2Exception with error message from Google (Fixes #1)', () async {
      final client = MockClient((request) async {
        return http.Response(
          json.encode({
            "error_message": "The provided API key is invalid.",
            "results": [],
            "status": "REQUEST_DENIED"
          }),
          200,
        );
      });

      expect(
        () => Geocoder2.getDataFromAddress(
          address: '277 Bedford Ave',
          googleMapApiKey: 'INVALID_KEY',
          client: client,
        ),
        throwsA(
          isA<Geocoder2Exception>()
              .having((e) => e.status, 'status', 'REQUEST_DENIED')
              .having((e) => e.message, 'message', contains('The provided API key is invalid')),
        ),
      );
    });

    test('OVER_QUERY_LIMIT throws Geocoder2Exception', () async {
      final client = MockClient((request) async {
        return http.Response(
          json.encode({
            "error_message": "You have exceeded your request quota for this API.",
            "results": [],
            "status": "OVER_QUERY_LIMIT"
          }),
          200,
        );
      });

      expect(
        () => Geocoder2.getDataFromCoordinates(
          latitude: 10.0,
          longitude: 20.0,
          googleMapApiKey: 'KEY',
          client: client,
        ),
        throwsA(
          isA<Geocoder2Exception>().having((e) => e.status, 'status', 'OVER_QUERY_LIMIT'),
        ),
      );
    });

    test('HTTP non-200 status code throws Geocoder2Exception with statusCode (no null cast)', () async {
      final client = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      expect(
        () => Geocoder2.getDataFromCoordinates(
          latitude: 10.0,
          longitude: 20.0,
          googleMapApiKey: 'KEY',
          client: client,
        ),
        throwsA(
          isA<Geocoder2Exception>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });
  });

  group('LocationType and Component Resilience (Fixes #4, #5, #16)', () {
    test('Unknown LocationType falls back safely to LocationType.UNKNOWN without throwing', () {
      final jsonWithUnknownType = {
        "results": [
          {
            "address_components": [],
            "formatted_address": "Ocean Point",
            "geometry": {
              "location": {"lat": 1.1, "lng": 45.5},
              "location_type": "SOME_NEW_FUTURE_GOOGLE_TYPE"
            },
            "place_id": "test_id",
            "types": ["natural_feature"]
          }
        ],
        "status": "OK"
      };

      final parsed = FetchGeocoder.fromJson(jsonWithUnknownType);
      expect(parsed.results.first.geometry.locationType, LocationType.UNKNOWN);
    });

    test('Null LocationType falls back safely to LocationType.UNKNOWN', () {
      final jsonWithNullType = {
        "results": [
          {
            "address_components": [],
            "formatted_address": "Ocean Point",
            "geometry": {
              "location": {"lat": 1.1, "lng": 45.5},
              "location_type": null
            },
            "place_id": "test_id",
            "types": []
          }
        ],
        "status": "OK"
      };

      final parsed = FetchGeocoder.fromJson(jsonWithNullType);
      expect(parsed.results.first.geometry.locationType, LocationType.UNKNOWN);
    });

    test('Ocean coordinate with plus code parses without crashing (Fixes #4)', () async {
      final client = MockClient((request) async {
        return http.Response(
          json.encode({
            "results": [
              {
                "address_components": [
                  {
                    "long_name": "Indian Ocean",
                    "short_name": "Indian Ocean",
                    "types": ["natural_feature", "establishment"]
                  }
                ],
                "formatted_address": "6HH73GX2+X2",
                "geometry": {
                  "location": {"lat": 1.10, "lng": 45.50},
                  "location_type": "APPROXIMATE"
                },
                "place_id": "GhIJmZmZmZmZ8T8RAAAAAADARkA",
                "types": ["plus_code"]
              }
            ],
            "status": "OK"
          }),
          200,
        );
      });

      final data = await Geocoder2.getDataFromCoordinates(
        latitude: 1.10,
        longitude: 45.50,
        googleMapApiKey: 'KEY',
        client: client,
      );

      expect(data.address, '6HH73GX2+X2');
      expect(data.latitude, 1.10);
      expect(data.longitude, 45.50);
      expect(data.placeId, 'GhIJmZmZmZmZ8T8RAAAAAADARkA');
    });

    test('City resolution priority: locality over administrative_area_level_2', () async {
      final client = MockClient((request) async {
        return http.Response(sampleSuccessJson, 200);
      });

      final data = await Geocoder2.getDataFromAddress(
        address: '277 Bedford Ave, Brooklyn, NY',
        googleMapApiKey: 'KEY',
        client: client,
      );

      // locality is 'New York', adminArea2 is 'Kings County'
      expect(data.city, 'New York');
    });

    test('City resolution fallback to sublocality when locality is missing', () async {
      const sublocalityJson = '''
{
  "results": [
    {
      "address_components": [
        {
          "long_name": "Brooklyn",
          "short_name": "Brooklyn",
          "types": ["sublocality", "sublocality_level_1"]
        },
        {
          "long_name": "Kings County",
          "short_name": "Kings County",
          "types": ["administrative_area_level_2"]
        }
      ],
      "formatted_address": "Brooklyn, NY",
      "geometry": {
        "location": {"lat": 40.6782, "lng": -73.9442},
        "location_type": "APPROXIMATE"
      },
      "place_id": "test_brooklyn",
      "types": ["sublocality"]
    }
  ],
  "status": "OK"
}
''';

      final client = MockClient((request) async {
        return http.Response(sublocalityJson, 200);
      });

      final data = await Geocoder2.getDataFromAddress(
        address: 'Brooklyn, NY',
        googleMapApiKey: 'KEY',
        client: client,
      );

      expect(data.city, 'Brooklyn');
    });
  });

  group('Model Serialization and Formatting', () {
    test('GeoData toJson and toString', () {
      final geo = GeoData(
        address: '123 Main St',
        city: 'Metropolis',
        country: 'USA',
        latitude: 10.0,
        longitude: 20.0,
        postalCode: '10001',
        state: 'NY',
        countryCode: 'US',
        streetNumber: '123',
      );

      final jsonMap = geo.toJson();
      expect(jsonMap['address'], '123 Main St');
      expect(jsonMap['city'], 'Metropolis');
      expect(jsonMap['streetNumber'], '123');

      expect(geo.toString(), contains('123 Main St'));
    });

    test('FetchGeocoder toJson serialization', () {
      final parsed = fetchGeocoderFromJson(sampleSuccessJson);
      final jsonString = fetchGeocoderToJson(parsed);
      expect(jsonString, contains('277 Bedford Ave'));
    });

    test('Geocoder2Exception formatting', () {
      const ex = Geocoder2Exception('Key denied', status: 'REQUEST_DENIED', statusCode: 403);
      expect(ex.toString(), 'Geocoder2Exception: Key denied (Status: REQUEST_DENIED) [HTTP 403]');
    });
  });
}
