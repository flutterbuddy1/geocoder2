import 'dart:convert';

FetchGeocoder fetchGeocoderFromJson(String str) =>
    FetchGeocoder.fromJson(json.decode(str));

String fetchGeocoderToJson(FetchGeocoder data) => json.encode(data.toJson());

@Deprecated('Use fetchGeocoderToJson instead')
String tetchGeocoderToJson(FetchGeocoder data) => fetchGeocoderToJson(data);

class FetchGeocoder {
  FetchGeocoder({
    required this.results,
    required this.status,
    this.errorMessage,
  });

  List<Result> results;
  String status;
  String? errorMessage;

  factory FetchGeocoder.fromJson(Map<String, dynamic> json) => FetchGeocoder(
        results: json["results"] != null
            ? List<Result>.from(
                (json["results"] as List).map((x) => Result.fromJson(x)))
            : <Result>[],
        status: json["status"] ?? "",
        errorMessage: json["error_message"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
        if (errorMessage != null) "error_message": errorMessage,
      };
}

class Result {
  Result({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.types,
  });

  List<AddressComponent> addressComponents;
  String formattedAddress;
  Geometry geometry;
  String placeId;
  List<String> types;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: json["address_components"] != null
            ? List<AddressComponent>.from(
                (json["address_components"] as List)
                    .map((x) => AddressComponent.fromJson(x)))
            : <AddressComponent>[],
        formattedAddress: json["formatted_address"] ?? "",
        geometry: json["geometry"] != null
            ? Geometry.fromJson(json["geometry"])
            : Geometry(
                location: Location(lat: 0.0, lng: 0.0),
                locationType: LocationType.UNKNOWN,
              ),
        placeId: json["place_id"] ?? "",
        types: json["types"] != null
            ? List<String>.from((json["types"] as List).map((x) => x.toString()))
            : <String>[],
      );

  Map<String, dynamic> toJson() => {
        "address_components":
            List<dynamic>.from(addressComponents.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "place_id": placeId,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class AddressComponent {
  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  String longName;
  String shortName;
  List<String> types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"] ?? "",
        shortName: json["short_name"] ?? "",
        types: json["types"] != null
            ? List<String>.from(
                (json["types"] as List).map((x) => x.toString()))
            : <String>[],
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class Geometry {
  Geometry({
    required this.location,
    required this.locationType,
  });

  Location location;
  LocationType locationType;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : Location(lat: 0.0, lng: 0.0),
        locationType: locationTypeValues.map[json["location_type"]] ??
            LocationType.UNKNOWN,
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "location_type": locationTypeValues.reverse[locationType],
      };
}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  Location northeast;
  Location southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
      };
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  double lat;
  double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: (json["lat"] as num?)?.toDouble() ?? 0.0,
        lng: (json["lng"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

enum LocationType {
  ROOFTOP,
  GEOMETRIC_CENTER,
  APPROXIMATE,
  RANGE_INTERPOLATED,
  UNKNOWN,
}

final locationTypeValues = EnumValues({
  "APPROXIMATE": LocationType.APPROXIMATE,
  "GEOMETRIC_CENTER": LocationType.GEOMETRIC_CENTER,
  "ROOFTOP": LocationType.ROOFTOP,
  "RANGE_INTERPOLATED": LocationType.RANGE_INTERPOLATED,
  "UNKNOWN": LocationType.UNKNOWN,
});

class PlusCode {
  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  String compoundCode;
  String globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"] ?? "",
        globalCode: json["global_code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(Map<String, T> map)
      : map = Map.from(map),
        reverseMap = {
          for (var v in map.values) v: map.keys.firstWhere((k) => map[k] == v)
        };

  Map<T, String> get reverse {
    return reverseMap;
  }
}
