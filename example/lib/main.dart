import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';
import 'package:google_places_sdk_plus_example/features/text_search_section.dart';

import 'package:google_places_sdk_plus_example/features/fetch_photo_section.dart';

import 'components/initialization_card.dart';
import 'features/fetch_place_section.dart';
import 'features/nearby_search_section.dart';
import 'components/place_result_content.dart';
import 'components/place_list_sheet.dart';
import 'components/prediction_list_sheet.dart';
import 'features/autocomplete_section.dart';

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
  final _places = PlacesHostApi();
  bool _initialized = false;

  void _showPlacesBottomSheet({
    required List<Place?> places,
    String? error,
    String? sessionToken,
  }) {
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
        builder: (context, scrollController) => places.length == 1
            ? PlaceResultContent(
                place: places.first,
                error: error,
                scrollController: scrollController,
                placesApi: _places,
                sessionToken: sessionToken,
              )
            : PlaceListSheet(
                places: places,
                scrollController: scrollController,
                onPlaceSelected: (selected) {
                  Navigator.pop(context);
                  _showPlacesBottomSheet(
                    places: [selected],
                    sessionToken: sessionToken,
                  );
                },
              ),
      ),
    );
  }

  void _showResultsBottomSheet(
    Widget Function(BuildContext, ScrollController) builder,
  ) {
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
        builder: builder,
      ),
    );
  }

  void _showPredictionsBottomSheet(
    List<AutocompletePrediction> predictions,
    String? sessionToken,
  ) {
    _showResultsBottomSheet(
      (context, scrollController) => PredictionListSheet(
        predictions: predictions,
        scrollController: scrollController,
        sessionToken: sessionToken,
        onPredictionSelected: (prediction) async {
          Navigator.pop(context);
          // Auto-fetch details for the selected prediction
          try {
            final response = await _places.fetchPlace(
              FetchPlaceRequest(
                placeId: prediction.placeId,
                placeFields: PlaceField.values,
                sessionToken: sessionToken,
              ),
            );
            _showPlacesBottomSheet(
              places: [response.place],
              sessionToken: sessionToken,
            );
          } catch (e) {
            _onError(e.toString());
          }
        },
      ),
    );
  }

  void _onError(String error) {
    if (mounted) {
      _showPlacesBottomSheet(places: [], error: error);
    }
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            InitializationCard(
              apiKey: 'AIzaSyA7hzJgNC_KaYY8gkvfOqL7dO433XHkJpY',
              placesApi: _places,
              onInitializationChanged: (value) {
                setState(() {
                  _initialized = value;
                });
              },
            ),
            FetchPlaceSection(
              placesApi: _places,
              isEnabled: _initialized,
              onPlaceFetched: (place) =>
                  _showPlacesBottomSheet(places: [place]),
              onError: _onError,
            ),
            FetchPhotoSection(
              placesApi: _places,
              isEnabled: _initialized,
              onError: _onError,
              onPhotoFetched: (url) {
                // Show photo in a simple dialog or bottom sheet for now
                _showResultsBottomSheet(
                  (context, scrollController) => SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Fetched Photo',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            TextSearchSection(
              placesApi: _places,
              isEnabled: _initialized,
              onPlacesFound: (places) => _showPlacesBottomSheet(places: places),
              onError: _onError,
            ),
            NearbySearchSection(
              placesApi: _places,
              isEnabled: _initialized,
              onPlacesFound: (places) => _showPlacesBottomSheet(places: places),
              onError: _onError,
            ),
            AutocompleteSection(
              placesApi: _places,
              isEnabled: _initialized,
              onPredictionsFound: _showPredictionsBottomSheet,
              onError: _onError,
            ),
          ],
        ),
      ),
    );
  }
}
