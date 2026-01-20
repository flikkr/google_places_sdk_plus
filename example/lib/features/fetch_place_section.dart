import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';
import '../components/action_input_field.dart';

class FetchPlaceSection extends StatefulWidget {
  final PlacesHostApi placesApi;
  final bool isEnabled;
  final ValueChanged<Place> onPlaceFetched;
  final ValueChanged<String> onError;

  const FetchPlaceSection({
    super.key,
    required this.placesApi,
    required this.isEnabled,
    required this.onPlaceFetched,
    required this.onError,
  });

  @override
  State<FetchPlaceSection> createState() => _FetchPlaceSectionState();
}

class _FetchPlaceSectionState extends State<FetchPlaceSection> {
  final _placeIdController = TextEditingController(
    text: 'ChIJLU7jZClu5kcR4PcOOO6p3I0',
  ); // Eiffel Tower
  bool _loading = false;

  Future<void> _fetchPlace() async {
    final placeId = _placeIdController.text.trim();
    if (placeId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a Place ID')),
        );
      }
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await widget.placesApi.fetchPlace(
        FetchPlaceRequest(
          placeId: placeId,
          placeFields: PlaceField.values, // Fetch all fields for raw response
        ),
      );

      if (mounted) {
        setState(() => _loading = false);
        if (response.place != null) {
          widget.onPlaceFetched(response.place!);
        } else {
          widget.onError("Place not found");
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        widget.onError(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActionInputField(
      title: "Fetch Place Details",
      controller: _placeIdController,
      label: 'Place ID',
      hint: 'e.g., ChIJLU7jZClu5kcR4PcOOO6p3I0',
      icon: Icons.location_on,
      buttonText: 'Fetch Place Details',
      buttonIcon: Icons.search,
      onPressed: _fetchPlace,
      isLoading: _loading,
      isEnabled: widget.isEnabled && !_loading,
    );
  }
}
