import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';
import 'package:google_places_sdk_plus_example/components/action_input_field.dart';

class FetchPhotoSection extends StatefulWidget {
  final PlacesHostApi placesApi;
  final bool isEnabled;
  final ValueChanged<String> onError;
  final ValueChanged<String> onPhotoFetched;

  const FetchPhotoSection({
    super.key,
    required this.placesApi,
    required this.isEnabled,
    required this.onError,
    required this.onPhotoFetched,
  });

  @override
  State<FetchPhotoSection> createState() => _FetchPhotoSectionState();
}

class _FetchPhotoSectionState extends State<FetchPhotoSection> {
  final _placeIdController = TextEditingController(
    text: 'ChIJLU7jZClu5kcR4PcOOO6p3I0',
  ); // Google Sydney
  bool _loading = false;

  Future<void> _fetchFirstPhoto() async {
    final placeId = _placeIdController.text.trim();
    if (placeId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a Place ID')),
        );
      }
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // 1. Fetch Place to get metadata
      final placeResponse = await widget.placesApi.fetchPlace(
        FetchPlaceRequest(
          placeId: placeId,
          placeFields: [PlaceField.ID, PlaceField.PHOTO_METADATAS],
        ),
      );

      final place = placeResponse.place;
      if (place.photoMetadatas == null || place.photoMetadatas!.isEmpty) {
        widget.onError('No photos found for this place');
        setState(() => _loading = false);
        return;
      }

      final firstMetadata = place.photoMetadatas!.first!;

      // 2. Fetch Photo
      final photoResponse = await widget.placesApi.fetchPhoto(
        FetchPhotoRequest(
          photoMetadata: firstMetadata,
          maxWidth: 500,
          maxHeight: 500,
        ),
      );

      if (mounted) {
        setState(() {
          _loading = false;
        });
        if (photoResponse.uri != null) {
          widget.onPhotoFetched(photoResponse.uri!);
        } else {
          widget.onError('Failed to fetch photo URI');
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
      title: "Fetch First Photo",
      controller: _placeIdController,
      label: 'Place ID for Photo',
      hint: 'e.g., ChIJLU7jZClu5kcR4PcOOO6p3I0',
      icon: Icons.image_search,
      buttonText: 'Fetch First Photo',
      buttonIcon: Icons.photo_camera,
      onPressed: _fetchFirstPhoto,
      isLoading: _loading,
      isEnabled: widget.isEnabled && !_loading,
    );
  }
}
