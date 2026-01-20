// ignore_for_file: constant_identifier_names

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/places.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/flik/google_places_sdk_plus/Places.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.flik.google_places_sdk_plus'),
    dartPackageName: 'google_places_sdk_plus',
  ),
)
@HostApi()
abstract class PlacesHostApi {
  void initialize(String apiKey);

  @async
  FetchPlaceResponse fetchPlace(FetchPlaceRequest request);

  @async
  SearchByTextResponse searchByText(SearchByTextRequest request);

  @async
  SearchNearbyResponse searchNearby(SearchNearbyRequest request);

  @async
  FetchPhotoResponse fetchPhoto(FetchPhotoRequest request);

  @async
  FetchAutocompletePredictionsResponse fetchAutocompletePredictions(
    FetchAutocompletePredictionsRequest request,
  );
}

enum PlaceField {
  ACCESSIBILITY_OPTIONS,
  ADDRESS_COMPONENTS,
  ADR_FORMAT_ADDRESS,
  ALLOWS_DOGS,
  BUSINESS_STATUS,
  CONSUMER_ALERT,
  CURBSIDE_PICKUP,
  CURRENT_OPENING_HOURS,
  CURRENT_SECONDARY_OPENING_HOURS,
  DELIVERY,
  DINE_IN,
  DISPLAY_NAME,
  EDITORIAL_SUMMARY,
  EV_CHARGE_AMENITY_SUMMARY,
  EV_CHARGE_OPTIONS,
  FORMATTED_ADDRESS,
  FUEL_OPTIONS,
  GENERATIVE_SUMMARY,
  GOOD_FOR_CHILDREN,
  GOOD_FOR_GROUPS,
  GOOD_FOR_WATCHING_SPORTS,
  GOOGLE_MAPS_LINKS,
  GOOGLE_MAPS_URI,
  ICON_BACKGROUND_COLOR,
  ICON_MASK_URL,
  ID,
  INTERNATIONAL_PHONE_NUMBER,
  LIVE_MUSIC,
  LOCATION,
  MENU_FOR_CHILDREN,
  NATIONAL_PHONE_NUMBER,
  NEIGHBORHOOD_SUMMARY,
  OPENING_HOURS,
  OUTDOOR_SEATING,
  PARKING_OPTIONS,
  PAYMENT_OPTIONS,
  PHOTO_METADATAS,
  PLUS_CODE,
  PRICE_LEVEL,
  PRIMARY_TYPE,
  PRIMARY_TYPE_DISPLAY_NAME,
  PURE_SERVICE_AREA_BUSINESS,
  RATING,
  RESERVABLE,
  RESOURCE_NAME,
  RESTROOM,
  REVIEWS,
  REVIEW_SUMMARY,
  SECONDARY_OPENING_HOURS,
  SERVES_BEER,
  SERVES_BREAKFAST,
  SERVES_BRUNCH,
  SERVES_COCKTAILS,
  SERVES_COFFEE,
  SERVES_DESSERT,
  SERVES_DINNER,
  SERVES_LUNCH,
  SERVES_VEGETARIAN_FOOD,
  SERVES_WINE,
  SHORT_FORMATTED_ADDRESS,
  SUB_DESTINATIONS,
  TAKEOUT,
  TYPES,
  USER_RATING_COUNT,
  UTC_OFFSET,
  VIEWPORT,
  WEBSITE_URI,
}

class FetchPlaceRequest {
  String placeId;
  List<PlaceField> placeFields;
  String? sessionToken;

  FetchPlaceRequest({
    required this.placeId,
    required this.placeFields,
    required this.sessionToken,
  });
}

class FetchPlaceResponse {
  Place place;

  FetchPlaceResponse(this.place);
}

class SearchByTextRequest {
  String textQuery;
  List<PlaceField> placeFields;
  String? includedType;
  int? maxResultCount;
  double? minRating;
  bool? isOpenNow;
  List<int>? priceLevels;
  bool? strictTypeFiltering;
  LatLngBounds? locationBias;
  LatLngBounds? locationRestriction;
  SearchByTextRankPreference? rankPreference;

  SearchByTextRequest({
    required this.textQuery,
    required this.placeFields,
    required this.includedType,
    required this.maxResultCount,
    required this.minRating,
    required this.isOpenNow,
    required this.priceLevels,
    required this.strictTypeFiltering,
    required this.locationBias,
    required this.locationRestriction,
  });
}

class SearchByTextResponse {
  List<Place> places;

  SearchByTextResponse(this.places);
}

class SearchNearbyRequest {
  CircularBounds locationRestriction;
  List<PlaceField> placeFields;
  List<String>? includedTypes;
  List<String>? excludedTypes;
  List<String>? includedPrimaryTypes;
  List<String>? excludedPrimaryTypes;
  int? maxResultCount;
  SearchNearbyRankPreference? rankPreference;

  SearchNearbyRequest({
    required this.locationRestriction,
    required this.placeFields,
    required this.includedTypes,
    required this.excludedTypes,
    required this.includedPrimaryTypes,
    required this.excludedPrimaryTypes,
    required this.maxResultCount,
    required this.rankPreference,
  });
}

class Leg {
  int distanceMeters;
  int durationSeconds;
  Leg({required this.distanceMeters, required this.durationSeconds});
}

class RoutingSummary {
  String? uri;
  List<Leg> legs;
  RoutingSummary({required this.uri, required this.legs});
}

class SearchNearbyResponse {
  List<Place> places;
  List<RoutingSummary>? routingSummary;

  SearchNearbyResponse(this.places);
}

class FetchPhotoRequest {
  PhotoMetadata photoMetadata;
  int? maxWidth;
  int? maxHeight;

  FetchPhotoRequest({
    required this.photoMetadata,
    required this.maxWidth,
    required this.maxHeight,
  });
}

class FetchPhotoResponse {
  String? uri;

  FetchPhotoResponse(this.uri);
}

enum PlaceTypes {
  ACCOUNTING,
  ADDRESS,
  ADMINISTRATIVE_AREA_LEVEL_1,
  ADMINISTRATIVE_AREA_LEVEL_2,
  ADMINISTRATIVE_AREA_LEVEL_3,
  ADMINISTRATIVE_AREA_LEVEL_4,
  ADMINISTRATIVE_AREA_LEVEL_5,
  ADMINISTRATIVE_AREA_LEVEL_6,
  ADMINISTRATIVE_AREA_LEVEL_7,
  AIRPORT,
  AMUSEMENT_PARK,
  AQUARIUM,
  ARCHIPELAGO,
  ART_GALLERY,
  ATM,
  BAKERY,
  BANK,
  BAR,
  BEAUTY_SALON,
  BICYCLE_STORE,
  BOOK_STORE,
  BOWLING_ALLEY,
  BUS_STATION,
  CAFE,
  CAMPGROUND,
  CAR_DEALER,
  CAR_RENTAL,
  CAR_REPAIR,
  CAR_WASH,
  CASINO,
  CEMETERY,
  CHURCH,
  CITIES,
  CITY_HALL,
  CLOTHING_STORE,
  COLLOQUIAL_AREA,
  CONTINENT,
  CONVENIENCE_STORE,
  COUNTRY,
  COURTHOUSE,
  DENTIST,
  DEPARTMENT_STORE,
  DOCTOR,
  DRUGSTORE,
  ELECTRICIAN,
  ELECTRONICS_STORE,
  EMBASSY,
  ESTABLISHMENT,
  FINANCE,
  FIRE_STATION,
  FLOOR,
  FLORIST,
  FOOD,
  FUNERAL_HOME,
  FURNITURE_STORE,
  GAS_STATION,
  GENERAL_CONTRACTOR,
  GEOCODE,
  GYM,
  HAIR_CARE,
  HARDWARE_STORE,
  HEALTH,
  HINDU_TEMPLE,
  HOME_GOODS_STORE,
  HOSPITAL,
  INSURANCE_AGENCY,
  INTERSECTION,
  JEWELRY_STORE,
  LANDMARK,
  LAUNDRY,
  LAWYER,
  LIBRARY,
  LIGHT_RAIL_STATION,
  LIQUOR_STORE,
  LOCALITY,
  LOCAL_GOVERNMENT_OFFICE,
  LOCKSMITH,
  LODGING,
  MEAL_DELIVERY,
  MEAL_TAKEAWAY,
  MOSQUE,
  MOVIE_RENTAL,
  MOVIE_THEATER,
  MOVING_COMPANY,
  MUSEUM,
  NATURAL_FEATURE,
  NEIGHBORHOOD,
  NIGHT_CLUB,
  PAINTER,
  PARK,
  PARKING,
  PET_STORE,
  PHARMACY,
  PHYSIOTHERAPIST,
  PLACE_OF_WORSHIP,
  PLUMBER,
  PLUS_CODE,
  POINT_OF_INTEREST,
  POLICE,
  POLITICAL,
  POSTAL_CODE,
  POSTAL_CODE_PREFIX,
  POSTAL_CODE_SUFFIX,
  POSTAL_TOWN,
  POST_BOX,
  POST_OFFICE,
  PREMISE,
  PRIMARY_SCHOOL,
  REAL_ESTATE_AGENCY,
  REGIONS,
  RESTAURANT,
  ROOFING_CONTRACTOR,
  ROOM,
  ROUTE,
  RV_PARK,
  SCHOOL,
  SECONDARY_SCHOOL,
  SHOE_STORE,
  SHOPPING_MALL,
  SPA,
  STADIUM,
  STORAGE,
  STORE,
  STREET_ADDRESS,
  STREET_NUMBER,
  SUBLOCALITY,
  SUBLOCALITY_LEVEL_1,
  SUBLOCALITY_LEVEL_2,
  SUBLOCALITY_LEVEL_3,
  SUBLOCALITY_LEVEL_4,
  SUBLOCALITY_LEVEL_5,
  SUBPREMISE,
  SUBWAY_STATION,
  SUPERMARKET,
  SYNAGOGUE,
  TAXI_STAND,
  TOURIST_ATTRACTION,
  TOWN_SQUARE,
  TRAIN_STATION,
  TRANSIT_STATION,
  TRAVEL_AGENCY,
  UNIVERSITY,
  VETERINARY_CARE,
  ZOO,
}

class FetchAutocompletePredictionsRequest {
  String? query;
  List<String>? countries;
  LatLngBounds? locationBias;
  LatLngBounds? locationRestriction;
  LatLng? origin;
  List<PlaceTypes>? typesFilter;
  String? sessionToken;

  FetchAutocompletePredictionsRequest({
    required this.query,
    required this.countries,
    required this.locationBias,
    required this.locationRestriction,
    required this.origin,
    required this.typesFilter,
    required this.sessionToken,
  });
}

class FetchAutocompletePredictionsResponse {
  List<AutocompletePrediction> predictions;

  FetchAutocompletePredictionsResponse(this.predictions);
}

class AutocompletePrediction {
  String placeId;
  String primaryText;
  String secondaryText;
  String fullText;
  List<String> placeTypes;
  int? distanceMeters;

  AutocompletePrediction({
    required this.placeId,
    required this.primaryText,
    required this.secondaryText,
    required this.fullText,
    required this.placeTypes,
    required this.distanceMeters,
  });
}

enum SearchByTextRankPreference { DISTANCE, RELEVANCE }

enum SearchNearbyRankPreference { DISTANCE, POPULARITY }

enum BusinessStatus { OPERATIONAL, CLOSED_TEMPORARILY, CLOSED_PERMANENTLY }

enum DayOfWeek {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY,
}

enum BooleanPlaceAttributeValue { UNKNOWN, TRUE, FALSE }

class LatLng {
  double lat;
  double lng;

  LatLng({required this.lat, required this.lng});
}

class LatLngBounds {
  LatLng southwest;
  LatLng northeast;

  LatLngBounds({required this.southwest, required this.northeast});
}

class CircularBounds {
  LatLng center;
  double radius;

  CircularBounds({required this.center, required this.radius});
}

class AddressComponent {
  String name;
  String? shortName;
  List<String> types;

  AddressComponent({
    required this.name,
    required this.shortName,
    required this.types,
  });
}

class AddressComponents {
  List<AddressComponent> components;

  AddressComponents({required this.components});
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});
}

class LocalTime {
  int hours;
  int minutes;

  LocalTime({required this.hours, required this.minutes});
}

class TimeOfWeek {
  DayOfWeek day;
  LocalTime time;

  TimeOfWeek({required this.day, required this.time});
}

class Period {
  TimeOfWeek? open;
  TimeOfWeek? close;

  Period({required this.open, required this.close});
}

enum HoursType {
  ACCESS,
  BREAKFAST,
  BRUNCH,
  DELIVERY,
  DINNER,
  DRIVE_THROUGH,
  HAPPY_HOUR,
  KITCHEN,
  LUNCH,
  ONLINE_SERVICE_HOURS,
  PICKUP,
  SENIOR_HOURS,
  TAKEOUT,
}

class SpecialDay {
  String stringDate;
  SpecialDay({required this.stringDate});
}

class OpeningHours {
  List<Period> periods;
  List<String> weekdayText;
  List<SpecialDay> specialDays;
  HoursType? type;

  OpeningHours({
    required this.periods,
    required this.weekdayText,
    required this.specialDays,
    required this.type,
  });
}

class PhotoMetadata {
  int width;
  int height;
  String attributions;
  List<AuthorAttribution> authorAttributions;
  String? photoReference;

  PhotoMetadata({
    required this.width,
    required this.height,
    required this.attributions,
    required this.authorAttributions,
    required this.photoReference,
  });
}

class AuthorAttribution {
  String? name;
  String? uri;
  String? photoUri;

  AuthorAttribution({
    required this.name,
    required this.uri,
    required this.photoUri,
  });
}

class Review {
  String? name;
  String? relativePublishTimeDescription;
  double? rating;
  String? text;
  AuthorAttribution? authorAttribution;
  String? publishTime;

  Review({
    required this.name,
    required this.relativePublishTimeDescription,
    required this.rating,
    required this.text,
    required this.authorAttribution,
    required this.publishTime,
  });
}

class AccessibilityOptions {
  BooleanPlaceAttributeValue? wheelchairAccessibleEntrance;
  BooleanPlaceAttributeValue? wheelchairAccessibleRestroom;
  BooleanPlaceAttributeValue? wheelchairAccessibleSeating;
  BooleanPlaceAttributeValue? wheelchairAccessibleParking;

  AccessibilityOptions({
    required this.wheelchairAccessibleEntrance,
    required this.wheelchairAccessibleRestroom,
    required this.wheelchairAccessibleSeating,
    required this.wheelchairAccessibleParking,
  });
}

class ParkingOptions {
  BooleanPlaceAttributeValue? freeParkingLot;
  BooleanPlaceAttributeValue? paidParkingLot;
  BooleanPlaceAttributeValue? freeStreetParking;
  BooleanPlaceAttributeValue? paidStreetParking;
  BooleanPlaceAttributeValue? valetParking;
  BooleanPlaceAttributeValue? freeGarageParking;
  BooleanPlaceAttributeValue? paidGarageParking;

  ParkingOptions({
    required this.freeParkingLot,
    required this.paidParkingLot,
    required this.freeStreetParking,
    required this.paidStreetParking,
    required this.valetParking,
    required this.freeGarageParking,
    required this.paidGarageParking,
  });
}

class PaymentOptions {
  BooleanPlaceAttributeValue? acceptsCreditCards;
  BooleanPlaceAttributeValue? acceptsDebitCards;
  BooleanPlaceAttributeValue? acceptsCashOnly;
  BooleanPlaceAttributeValue? acceptsNfc;

  PaymentOptions({
    required this.acceptsCreditCards,
    required this.acceptsDebitCards,
    required this.acceptsCashOnly,
    required this.acceptsNfc,
  });
}

class ContentBlock {
  String? content;
  String? contentLanguageCode;
  List<String>? referencedPlaceResourceNames;
  List<String>? referencedPlaceIds;

  ContentBlock({
    required this.content,
    required this.contentLanguageCode,
    required this.referencedPlaceResourceNames,
    required this.referencedPlaceIds,
  });
}

class EvChargeAmenitySummary {
  ContentBlock overview;
  ContentBlock? coffee;
  ContentBlock? restaurant;
  ContentBlock? store;
  String? flagContentUri;
  String? disclosureText;
  String? disclosureTextLanguageCode;

  EvChargeAmenitySummary({
    required this.overview,
    required this.coffee,
    required this.restaurant,
    required this.store,
    required this.flagContentUri,
    required this.disclosureText,
    required this.disclosureTextLanguageCode,
  });
}

enum EVConnectorType {
  EV_CONNECTOR_TYPE_UNSPECIFIED,
  EV_CONNECTOR_TYPE_OTHER,
  EV_CONNECTOR_TYPE_J1772,
  EV_CONNECTOR_TYPE_TYPE_2,
  EV_CONNECTOR_TYPE_CHADEMO,
  EV_CONNECTOR_TYPE_CCS_COMBO_1,
  EV_CONNECTOR_TYPE_CCS_COMBO_2,
  EV_CONNECTOR_TYPE_TESLA,
  EV_CONNECTOR_TYPE_UNSPECIFIED_GB_T,
  EV_CONNECTOR_TYPE_UNSPECIFIED_WALL_OUTLET,
  EV_CONNECTOR_TYPE_NACS,
}

class ConnectorAggregation {
  EVConnectorType type;
  double maxChargeRateKw;
  int count;
  int? availableCount;
  int? outOfServiceCount;
  int? availabilityLastUpdateTime;

  ConnectorAggregation({
    required this.type,
    required this.maxChargeRateKw,
    required this.count,
    required this.availableCount,
    required this.outOfServiceCount,
    required this.availabilityLastUpdateTime,
  });
}

class EVChargeOptions {
  int connectorCount;
  List<ConnectorAggregation> connectorAggregations;
  EVChargeOptions({
    required this.connectorCount,
    required this.connectorAggregations,
  });
}

class Money {
  String currencyCode;
  int nanos;
  int units;

  Money({required this.currencyCode, required this.nanos, required this.units});
}

enum FuelType {
  BIO_DIESEL,
  DIESEL,
  E80,
  E85,
  FUEL_TYPE_UNSPECIFIED,
  LPG,
  METHANE,
  MIDGRADE,
  PREMIUM,
  REGULAR_UNLEADED,
  SP100,
  SP91,
  SP91_E10,
  SP92,
  SP95,
  SP95_E10,
  SP98,
  SP99,
  TRUCK_DIESEL,
}

class FuelPrices {
  Money price;
  FuelType type;
  int updateTime;
  FuelPrices({
    required this.price,
    required this.type,
    required this.updateTime,
  });
}

class FuelOptions {
  List<FuelPrices> fuelPrices;
  FuelOptions({required this.fuelPrices});
}

class GenerativeSummary {
  String? overview;
  String? overviewLanguageCode;
  String? flagContentUri;
  String? disclosureText;
  String? disclosureTextLanguageCode;
  GenerativeSummary({
    required this.overview,
    required this.overviewLanguageCode,
    required this.flagContentUri,
    required this.disclosureText,
    required this.disclosureTextLanguageCode,
  });
}

class GoogleMapsLinks {
  String? directionsUri;
  String? placeUri;
  String? writeAReviewUri;
  String? reviewsUri;
  String? photosUri;
  GoogleMapsLinks({
    required this.directionsUri,
    required this.placeUri,
    required this.writeAReviewUri,
    required this.reviewsUri,
    required this.photosUri,
  });
}

class ReviewSummary {
  String? disclosureText;
  String? disclosureTextLanguageCode;
  String? flagContentUri;
  String? reviewsUri;
  String? text;
  String? textLanguageCode;

  ReviewSummary({
    required this.disclosureText,
    required this.disclosureTextLanguageCode,
    required this.flagContentUri,
    required this.reviewsUri,
    required this.text,
    required this.textLanguageCode,
  });
}

class SubDestination {
  String? name;
  String? id;
  SubDestination({required this.name, required this.id});
}

class Place {
  AddressComponents? addressComponents;
  String? adrFormatAddress;
  BusinessStatus? businessStatus;
  String? displayName;
  String? displayNameLanguageCode;
  String? editorialSummary;
  String? editorialSummaryLanguageCode;
  String? formattedAddress;
  String? iconMaskUrl;
  int? iconBackgroundColor;
  String? id;
  String? internationalPhoneNumber;
  LatLng? location;
  String? nationalPhoneNumber;
  OpeningHours? openingHours;
  OpeningHours? currentOpeningHours;
  List<OpeningHours?>? secondaryOpeningHours;
  List<OpeningHours?>? currentSecondaryOpeningHours;
  List<PhotoMetadata?>? photoMetadatas;
  PlusCode? plusCode;
  int? priceLevel;
  double? rating;
  List<Review>? reviews;
  List<String>? types;
  int? userRatingCount;
  int? utcOffsetMinutes;
  LatLngBounds? viewport;
  String? websiteUri;
  String? googleMapsUri;
  AccessibilityOptions? accessibilityOptions;
  ParkingOptions? parkingOptions;
  PaymentOptions? paymentOptions;
  String? primaryType;
  String? primaryTypeDisplayName;
  String? primaryTypeDisplayNameLanguageCode;
  String? resourceName;
  String? shortFormattedAddress;
  EvChargeAmenitySummary? evChargeAmenitySummary;
  EVChargeOptions? evChargeOptions;
  FuelOptions? fuelOptions;
  GenerativeSummary? generativeSummary;
  GoogleMapsLinks? googleMapsLinks;
  ReviewSummary? reviewSummary;
  List<SubDestination>? subDestinations;

  // Boolean Attribute Values
  BooleanPlaceAttributeValue? curbsidePickup;
  BooleanPlaceAttributeValue? delivery;
  BooleanPlaceAttributeValue? dineIn;
  BooleanPlaceAttributeValue? goodForChildren;
  BooleanPlaceAttributeValue? goodForGroups;
  BooleanPlaceAttributeValue? goodForWatchingSports;
  BooleanPlaceAttributeValue? liveMusic;
  BooleanPlaceAttributeValue? menuForChildren;
  BooleanPlaceAttributeValue? outdoorSeating;
  BooleanPlaceAttributeValue? reservable;
  BooleanPlaceAttributeValue? restroom;
  BooleanPlaceAttributeValue? servesBeer;
  BooleanPlaceAttributeValue? servesBreakfast;
  BooleanPlaceAttributeValue? servesBrunch;
  BooleanPlaceAttributeValue? servesCocktails;
  BooleanPlaceAttributeValue? servesCoffee;
  BooleanPlaceAttributeValue? servesDessert;
  BooleanPlaceAttributeValue? servesDinner;
  BooleanPlaceAttributeValue? servesLunch;
  BooleanPlaceAttributeValue? servesVegetarianFood;
  BooleanPlaceAttributeValue? servesWine;
  BooleanPlaceAttributeValue? takeout;
  BooleanPlaceAttributeValue? allowsDogs;
  BooleanPlaceAttributeValue? pureServiceAreaBusiness;

  Place({
    this.addressComponents,
    this.adrFormatAddress,
    this.businessStatus,
    this.displayName,
    this.displayNameLanguageCode,
    this.editorialSummary,
    this.editorialSummaryLanguageCode,
    this.formattedAddress,
    this.iconMaskUrl,
    this.iconBackgroundColor,
    this.id,
    this.internationalPhoneNumber,
    this.location,
    this.nationalPhoneNumber,
    this.openingHours,
    this.currentOpeningHours,
    this.secondaryOpeningHours,
    this.currentSecondaryOpeningHours,
    this.photoMetadatas,
    this.plusCode,
    this.priceLevel,
    this.rating,
    this.reviews,
    this.types,
    this.userRatingCount,
    this.utcOffsetMinutes,
    this.viewport,
    this.websiteUri,
    this.googleMapsUri,
    this.accessibilityOptions,
    this.parkingOptions,
    this.paymentOptions,
    this.primaryType,
    this.primaryTypeDisplayName,
    this.primaryTypeDisplayNameLanguageCode,
    this.resourceName,
    this.shortFormattedAddress,
    this.evChargeAmenitySummary,
    this.evChargeOptions,
    this.fuelOptions,
    this.generativeSummary,
    this.googleMapsLinks,
    this.reviewSummary,
    this.subDestinations,
    this.curbsidePickup,
    this.delivery,
    this.dineIn,
    this.goodForChildren,
    this.goodForGroups,
    this.goodForWatchingSports,
    this.liveMusic,
    this.menuForChildren,
    this.outdoorSeating,
    this.reservable,
    this.restroom,
    this.servesBeer,
    this.servesBreakfast,
    this.servesBrunch,
    this.servesCocktails,
    this.servesCoffee,
    this.servesDessert,
    this.servesDinner,
    this.servesLunch,
    this.servesVegetarianFood,
    this.servesWine,
    this.takeout,
    this.allowsDogs,
    this.pureServiceAreaBusiness,
  });
}
