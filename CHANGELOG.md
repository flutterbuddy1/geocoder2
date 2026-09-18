## 1.5.0

* **Dart 3 & Flutter 3 Support**: Updated SDK constraint to `">=2.17.0 <4.0.0"` and `http` constraint to `">=0.13.4 <2.0.0"`. (Fixes #18, #19)
* **Zero Results & Bad State Fix**: Fixed fatal `Unhandled Exception: Bad state: No element` when Google Geocoding API returns empty results or errors. (Fixes #2, #3, #17, #20)
* **Structured Exception Handling**: Introduced `Geocoder2Exception` returning status code (`REQUEST_DENIED`, `OVER_QUERY_LIMIT`, etc.) and Google's exact `error_message`. (Fixes #1)
* **Multiple Results Support**: Added `getAllDataFromAddress` and `getAllDataFromCoordinates` to return all matching locations. (Fixes #9, #15)
* **Nullable Helpers**: Added `getDataFromAddressOrNull` and `getDataFromCoordinatesOrNull`.
* **URL Encoding**: Switched to `Uri.https()` with properly encoded query parameters, preventing malformed URLs when queries contain spaces, symbols, or accents. (Fixes #11)
* **LocationType Fallback**: Safely handle unknown or null `location_type` from Google API with `LocationType.UNKNOWN` instead of throwing `type 'Null' is not a subtype of type 'LocationType'`. (Fixes #5, #16)
* **City Resolution Hierarchy**: Improved city extraction prioritizing `locality` -> `sublocality` -> `postal_town` -> `administrative_area_level_2`.
* **Documentation & Compatibility**: Added `street_number` getter on `GeoData` for backward compatibility with README snippets, and updated code examples. (Fixes #6, #7)
* **Convenience Aliases**: Added `getCoordinatesFromAddress` and `getAddressFromCoordinates`.

## 1.4.0

* Adding Location Type

* Read ```README.md```
