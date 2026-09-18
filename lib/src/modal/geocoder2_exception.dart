/// Exception thrown when a geocoding request fails.
class Geocoder2Exception implements Exception {
  /// A human-readable description of the error.
  final String message;

  /// The Google Maps Geocoding API status string (e.g. 'REQUEST_DENIED', 'ZERO_RESULTS', 'OVER_QUERY_LIMIT').
  final String? status;

  /// The HTTP status code (e.g. 200, 400, 403, 500), if applicable.
  final int? statusCode;

  const Geocoder2Exception(
    this.message, {
    this.status,
    this.statusCode,
  });

  @override
  String toString() {
    final buffer = StringBuffer('Geocoder2Exception: $message');
    if (status != null) {
      buffer.write(' (Status: $status)');
    }
    if (statusCode != null) {
      buffer.write(' [HTTP $statusCode]');
    }
    return buffer.toString();
  }
}
