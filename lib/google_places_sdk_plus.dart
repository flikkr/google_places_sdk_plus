import 'src/places.g.dart';

export 'src/places.g.dart';
export 'src/extensions.dart';

class GooglePlaces extends PlacesHostApi {
  final String apiKey;

  GooglePlaces(this.apiKey);
}
