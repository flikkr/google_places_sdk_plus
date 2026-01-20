import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';

class InitializationCard extends StatefulWidget {
  final PlacesHostApi placesApi;
  final ValueChanged<bool> onInitializationChanged;
  final String? apiKey;

  const InitializationCard({
    super.key,
    required this.placesApi,
    required this.onInitializationChanged,
    this.apiKey,
  });

  @override
  State<InitializationCard> createState() => _InitializationCardState();
}

class _InitializationCardState extends State<InitializationCard> {
  late final TextEditingController _apiKeyController;
  bool _loading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(text: widget.apiKey);
  }

  Future<void> _initialize() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an API Key')),
        );
      }
      return;
    }

    setState(() => _loading = true);
    try {
      await widget.placesApi.initialize(apiKey);
      if (mounted) {
        setState(() {
          _initialized = true;
          _loading = false;
        });
        widget.onInitializationChanged(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SDK Initialized Successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              child: FilledButton.icon(
                onPressed: _loading ? null : _initialize,
                icon: _loading && !_initialized
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _initialized
                            ? Icons.check_circle
                            : Icons.power_settings_new,
                      ),
                label: Text(
                  _initialized ? 'Re-initialize SDK' : 'Initialize SDK',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _initialized ? Colors.green.shade50 : null,
                  foregroundColor: _initialized ? Colors.green.shade700 : null,
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
