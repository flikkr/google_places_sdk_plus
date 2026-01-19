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
  final _apiKeyController = TextEditingController();
  final _placeIdController = TextEditingController(
    text: 'ChIJLU7jZClu5kcR4PcOOO6p3I0',
  ); // Google Sydney
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
          placeFields: [
            PlaceField.ID,
            PlaceField.DISPLAY_NAME,
            PlaceField.FORMATTED_ADDRESS,
            PlaceField.LOCATION,
            PlaceField.RATING,
            PlaceField.USER_RATING_COUNT,
            PlaceField.WEBSITE_URI,
          ],
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
            TextField(
              controller: _placeIdController,
              decoration: InputDecoration(
                labelText: 'Place ID',
                hintText: 'e.g., ChIJLU7jZClu5kcR4PcOOO6p3I0',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabled: _initialized,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: (_loading || !_initialized) ? null : _fetchPlace,
                icon: _loading && _initialized
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.search),
                label: const Text('Fetch Place Details'),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
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
          error != null
              ? 'Error Occurred'
              : (place?.displayName ?? 'Place Details'),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              if (error != null) ...[
                const Center(
                  child: Icon(Icons.error_outline, color: Colors.red, size: 64),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Text(
                    error!,
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ] else if (place != null) ...[
                _buildDetailTile(Icons.info_outline, 'Place ID', place!.id),
                _buildDetailTile(Icons.title, 'Name', place!.displayName),
                _buildDetailTile(
                  Icons.map_outlined,
                  'Address',
                  place!.formattedAddress,
                ),
                _buildDetailTile(
                  Icons.star_outline,
                  'Rating',
                  place!.rating?.toString(),
                ),
                _buildDetailTile(
                  Icons.people_outline,
                  'Review Count',
                  place!.userRatingCount?.toString(),
                ),
                _buildDetailTile(Icons.public, 'Website', place!.websiteUri),
                _buildDetailTile(
                  Icons.location_on_outlined,
                  'Coordinate',
                  place!.location != null
                      ? '${place!.location!.lat}, ${place!.location!.lng}'
                      : null,
                ),
                const SizedBox(height: 24),
                Text(
                  'Raw JSON Response:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    '{\n'
                    '  "id": "${place!.id}",\n'
                    '  "displayName": "${place!.displayName}",\n'
                    '  "formattedAddress": "${place!.formattedAddress}"\n'
                    '}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String? value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value ?? 'N/A',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
