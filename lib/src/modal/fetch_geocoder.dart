import 'dart:convert';

FetchGeocoder fetchGeocoderFromJson(String str) =>
    FetchGeocoder.fromJson(json.decode(str));

String fetchGeocoderToJson(FetchGeocoder data) => json.encode(data.toJson());

class FetchGeocoder {
  FetchGeocoder({
    required this.results,
    required this.status,
  });

  List<Result> results;
  String status;

  factory FetchGeocoder.fromJson(Map<String, dynamic> json) => FetchGeocoder(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
      };
}

class Result {
  Result({
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
  });

  String formattedAddress;
  Geometry geometry;
  String placeId;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "place_id": placeId,
      };
}

class AddressComponent {
  AddressComponent({
    required this.longName,
    required this.shortName,
  });

  String longName;
  String shortName;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
      };
}

class Geometry {
  Geometry({
    required this.location,
  });

  Location location;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
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
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
