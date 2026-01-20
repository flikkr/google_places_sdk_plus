import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Places SDK Plus Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _apiKeyController = TextEditingController(
    text: 'AIzaSyA7hzJgNC_KaYY8gkvfOqL7dO433XHkJpY',
  );
  final TextEditingController _nearbyLatController = TextEditingController(
    text: '-33.8688',
  );
  final TextEditingController _nearbyLngController = TextEditingController(
    text: '151.2093',
  );
  final TextEditingController _nearbyRadiusController = TextEditingController(
    text: '500.0',
  );
  final _placeIdController = TextEditingController(
    text: 'ChIJLU7jZClu5kcR4PcOOO6p3I0',
  ); // Google Sydney
  final _searchQueryController = TextEditingController(text: 'Spicy Food');
  final _places = PlacesHostApi();
  bool _initialized = false;
  bool _loading = false;

  Future<void> _initialize() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an API Key')));
      return;
    }

    setState(() => _loading = true);
    try {
      await _places.initialize(apiKey);
      setState(() {
        _initialized = true;
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SDK Initialized Successfully')),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _fetchPlace() async {
    final placeId = _placeIdController.text.trim();
    if (placeId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a Place ID')));
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await _places.fetchPlace(
        FetchPlaceRequest(
          placeId: placeId,
          placeFields: PlaceField.values, // Fetch all fields for raw response
        ),
      );

      if (mounted) {
        setState(() => _loading = false);
        _showResultBottomSheet(place: response.place);
      }
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        _showResultBottomSheet(error: e.toString());
      }
    }
  }

  Future<void> _searchByText() async {
    final textQuery = _searchQueryController.text.trim();
    if (textQuery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a text query')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await _places.searchByText(
        SearchByTextRequest(
          textQuery: textQuery,
          placeFields: PlaceField.values, // Fetch all fields
        ),
      );

      if (mounted) {
        setState(() => _loading = false);
        _showSearchResultsBottomSheet(places: response.places);
      }
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        _showResultBottomSheet(error: e.toString());
      }
    }
  }

  Future<void> _searchNearby() async {
    if (_nearbyLatController.text.isEmpty ||
        _nearbyLngController.text.isEmpty ||
        _nearbyRadiusController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Lat, Lng and Radius')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final lat = double.parse(_nearbyLatController.text);
      final lng = double.parse(_nearbyLngController.text);
      final radius = double.parse(_nearbyRadiusController.text);

      final request = SearchByNearbyRequest(
        locationRestriction: CircularBounds(
          center: LatLng(lat: lat, lng: lng),
          radius: radius,
        ),
        placeFields: [
          PlaceField.ID,
          PlaceField.DISPLAY_NAME,
          PlaceField.LOCATION,
          PlaceField.BUSINESS_STATUS,
          PlaceField.FORMATTED_ADDRESS,
          PlaceField.TYPES,
          PlaceField.RATING,
          PlaceField.USER_RATING_COUNT,
          PlaceField.PRICE_LEVEL,
          PlaceField.OPENING_HOURS,
        ],
      );

      final response = await _places.searchByNearby(request);

      if (mounted) {
        _showSearchResultsBottomSheet(
          places: response.places.whereType<Place>().toList(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _showSearchResultsBottomSheet({required List<Place?> places}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Found ${places.length} Places',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: places.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final place = places[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        place?.displayName ?? place?.id ?? 'Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        place?.formattedAddress ?? 'No address',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: place?.rating != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    place!.rating!.toString(),
                                    style: TextStyle(
                                      color: Colors.amber.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.amber.shade900,
                                  ),
                                ],
                              ),
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        _showResultBottomSheet(place: place);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultBottomSheet({Place? place, String? error}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => PlaceResultContent(
          place: place,
          error: error,
          scrollController: scrollController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places SDK Plus'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _apiKeyController,
                      decoration: InputDecoration(
                        labelText: 'Google Maps API Key',
                        prefixIcon: const Icon(Icons.key),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _initialize,
                        icon: _loading && !_initialized
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                _initialized
                                    ? Icons.check_circle
                                    : Icons.power_settings_new,
                              ),
                        label: Text(
                          _initialized ? 'Re-initialize SDK' : 'Initialize SDK',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _initialized
                              ? Colors.green.shade50
                              : null,
                          foregroundColor: _initialized
                              ? Colors.green.shade700
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ActionInputField(
              title: "Fetch Place Details",
              controller: _placeIdController,
              label: 'Place ID',
              hint: 'e.g., ChIJLU7jZClu5kcR4PcOOO6p3I0',
              icon: Icons.location_on,
              buttonText: 'Fetch Place Details',
              buttonIcon: Icons.search,
              onPressed: _fetchPlace,
              isLoading: _loading && _initialized,
              isEnabled: _initialized && !_loading,
            ),
            const SizedBox(height: 24),
            ActionInputField(
              title: 'Search By Text',
              controller: _searchQueryController,
              label: 'Text Query',
              hint: 'e.g., Spicy Food in Sydney',
              icon: Icons.search,
              buttonText: 'Search Place',
              buttonIcon: Icons.text_fields,
              onPressed: _searchByText,
              isLoading: _loading && _initialized,
              isEnabled: _initialized && !_loading,
              filledButtonStyle: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Theme.of(context).colorScheme.onTertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              loadingColor: Theme.of(context).colorScheme.onTertiary,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Nearby Search',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nearbyLatController,
                    decoration: InputDecoration(
                      labelText: 'Latitude',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabled: _initialized && !_loading,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _nearbyLngController,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabled: _initialized && !_loading,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ActionInputField(
              controller: _nearbyRadiusController,
              label: 'Radius (meters)',
              hint: 'e.g., 500',
              icon: Icons.radar,
              buttonText: 'Search Nearby',
              buttonIcon: Icons.my_location,
              onPressed: _searchNearby,
              isLoading: _loading && _initialized,
              isEnabled: _initialized && !_loading,
              filledButtonStyle: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              loadingColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceResultContent extends StatelessWidget {
  final Place? place;
  final String? error;
  final ScrollController scrollController;

  const PlaceResultContent({
    super.key,
    this.place,
    this.error,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final String jsonString;
    if (error != null) {
      jsonString = const JsonEncoder.withIndent('  ').convert({'error': error});
    } else if (place != null) {
      jsonString = const JsonEncoder.withIndent('  ').convert(place!.toJson());
    } else {
      jsonString = '{}';
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          error != null ? 'Error' : 'Raw JSON Response',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: SelectableText(
                jsonString,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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

class ActionInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonStyle? filledButtonStyle;
  final Color? loadingColor;
  final String? title;

  const ActionInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
    required this.isLoading,
    this.isEnabled = true,
    this.filledButtonStyle,
    this.loadingColor,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
        ],
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabled: isEnabled || isLoading, // Keep text field visible/readable
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton.icon(
            onPressed: isEnabled ? onPressed : null,
            icon: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: loadingColor ?? Colors.white,
                    ),
                  )
                : Icon(buttonIcon),
            label: Text(buttonText),
            style:
                filledButtonStyle ??
                FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
