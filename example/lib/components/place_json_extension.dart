import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';

extension PlaceJson on Place {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'formattedAddress': formattedAddress,
      'adrFormatAddress': adrFormatAddress,
      'businessStatus': businessStatus?.name,
      'location': location != null
          ? {'lat': location!.lat, 'lng': location!.lng}
          : null,
      'rating': rating,
      'userRatingCount': userRatingCount,
      'websiteUri': websiteUri,
      'googleMapsUri': googleMapsUri,
      'priceLevel': priceLevel,
      'utcOffsetMinutes': utcOffsetMinutes,
      'types': types,
      'viewport': viewport != null
          ? {
              'southwest': {
                'lat': viewport!.southwest.lat,
                'lng': viewport!.southwest.lng,
              },
              'northeast': {
                'lat': viewport!.northeast.lat,
                'lng': viewport!.northeast.lng,
              },
            }
          : null,
      'iconMaskUrl': iconMaskUrl,
      'iconBackgroundColor': iconBackgroundColor,
      'plusCode': plusCode != null
          ? {
              'globalCode': plusCode!.globalCode,
              'compoundCode': plusCode!.compoundCode,
            }
          : null,
      'accessibilityOptions': accessibilityOptions != null
          ? {
              'wheelchairAccessibleEntrance':
                  accessibilityOptions!.wheelchairAccessibleEntrance?.name,
              'wheelchairAccessibleRestroom':
                  accessibilityOptions!.wheelchairAccessibleRestroom?.name,
              'wheelchairAccessibleSeating':
                  accessibilityOptions!.wheelchairAccessibleSeating?.name,
              'wheelchairAccessibleParking':
                  accessibilityOptions!.wheelchairAccessibleParking?.name,
            }
          : null,
      'parkingOptions': parkingOptions != null
          ? {
              'freeParkingLot': parkingOptions!.freeParkingLot?.name,
              'paidParkingLot': parkingOptions!.paidParkingLot?.name,
              'freeStreetParking': parkingOptions!.freeStreetParking?.name,
              'paidStreetParking': parkingOptions!.paidStreetParking?.name,
              'valetParking': parkingOptions!.valetParking?.name,
              'freeGarageParking': parkingOptions!.freeGarageParking?.name,
              'paidGarageParking': parkingOptions!.paidGarageParking?.name,
            }
          : null,
      'paymentOptions': paymentOptions != null
          ? {
              'acceptsCreditCards': paymentOptions!.acceptsCreditCards?.name,
              'acceptsDebitCards': paymentOptions!.acceptsDebitCards?.name,
              'acceptsCashOnly': paymentOptions!.acceptsCashOnly?.name,
              'acceptsNfc': paymentOptions!.acceptsNfc?.name,
            }
          : null,
    };
  }
}
