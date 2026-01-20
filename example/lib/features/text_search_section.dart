import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';
import '../components/action_input_field.dart';

class TextSearchSection extends StatefulWidget {
  final PlacesHostApi placesApi;
  final bool isEnabled;
  final ValueChanged<List<Place?>> onPlacesFound;
  final ValueChanged<String> onError;

  const TextSearchSection({
    super.key,
    required this.placesApi,
    required this.isEnabled,
    required this.onPlacesFound,
    required this.onError,
  });

  @override
  State<TextSearchSection> createState() => _TextSearchSectionState();
}

class _TextSearchSectionState extends State<TextSearchSection> {
  final _searchQueryController = TextEditingController(text: 'Spicy Food');
  bool _loading = false;

  Future<void> _searchByText() async {
    final textQuery = _searchQueryController.text.trim();
    if (textQuery.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a text query')),
        );
      }
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await widget.placesApi.searchByText(
        SearchByTextRequest(
          textQuery: textQuery,
          placeFields: PlaceField.values, // Fetch all fields
        ),
      );

      if (mounted) {
        setState(() => _loading = false);
        widget.onPlacesFound(response.places);
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
      title: 'Search By Text',
      controller: _searchQueryController,
      label: 'Text Query',
      hint: 'e.g., Spicy Food in Sydney',
      icon: Icons.search,
      buttonText: 'Search Place',
      buttonIcon: Icons.text_fields,
      onPressed: _searchByText,
      isLoading: _loading,
      isEnabled: widget.isEnabled && !_loading,
      filledButtonStyle: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      loadingColor: Theme.of(context).colorScheme.onTertiary,
    );
  }
}
