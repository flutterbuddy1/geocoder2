class GeoData {
  GeoData(
      {required this.address,
      required this.city,
      required this.country,
      required this.latitude,
      required this.longitude,
      required this.postalCode,
      required this.state,
      required this.street_number});
  String address;
  String city;
  String country;
  String postalCode;
  String state;
  double latitude;
  double longitude;
  String street_number;
}
