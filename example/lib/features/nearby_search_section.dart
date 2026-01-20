import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';
import '../components/action_input_field.dart';

class NearbySearchSection extends StatefulWidget {
  final PlacesHostApi placesApi;
  final bool isEnabled;
  final ValueChanged<List<Place?>> onPlacesFound;
  final ValueChanged<String> onError;

  const NearbySearchSection({
    super.key,
    required this.placesApi,
    required this.isEnabled,
    required this.onPlacesFound,
    required this.onError,
  });

  @override
  State<NearbySearchSection> createState() => _NearbySearchSectionState();
}

class _NearbySearchSectionState extends State<NearbySearchSection> {
  final _nearbyLatController = TextEditingController(text: '-33.8688');
  final _nearbyLngController = TextEditingController(text: '151.2093');
  final _nearbyRadiusController = TextEditingController(text: '500.0');
  bool _loading = false;

  Future<void> _searchNearby() async {
    if (_nearbyLatController.text.isEmpty ||
        _nearbyLngController.text.isEmpty ||
        _nearbyRadiusController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter Lat, Lng and Radius')),
        );
      }
      return;
    }

    setState(() => _loading = true);

    try {
      final lat = double.parse(_nearbyLatController.text);
      final lng = double.parse(_nearbyLngController.text);
      final radius = double.parse(_nearbyRadiusController.text);

      final request = SearchNearbyRequest(
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

      final response = await widget.placesApi.searchNearby(request);

      if (mounted) {
        widget.onPlacesFound(response.places.whereType<Place>().toList());
      }
    } catch (e) {
      if (mounted) {
        widget.onError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  enabled: widget.isEnabled && !_loading,
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
                  enabled: widget.isEnabled && !_loading,
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
          isLoading: _loading,
          isEnabled: widget.isEnabled && !_loading,
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
    );
  }
}
