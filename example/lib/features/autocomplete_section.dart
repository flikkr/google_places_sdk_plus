import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';
import 'package:google_places_sdk_plus_example/components/action_input_field.dart';

class AutocompleteSection extends StatefulWidget {
  final PlacesHostApi placesApi;
  final bool isEnabled;
  final Function(List<AutocompletePrediction>, String?) onPredictionsFound;
  final ValueChanged<String> onError;

  const AutocompleteSection({
    super.key,
    required this.placesApi,
    required this.isEnabled,
    required this.onPredictionsFound,
    required this.onError,
  });

  @override
  State<AutocompleteSection> createState() => _AutocompleteSectionState();
}

class _AutocompleteSectionState extends State<AutocompleteSection> {
  final _queryController = TextEditingController(text: 'Pizza in');
  bool _loading = false;
  String? _sessionToken;

  void _generateNewSessionToken() {
    setState(() {
      _sessionToken = DateTime.now().millisecondsSinceEpoch.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _generateNewSessionToken();
  }

  Future<void> _fetchPredictions() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please enter a query')));
      }
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await widget.placesApi.fetchAutocompletePredictions(
        FetchAutocompletePredictionsRequest(
          query: query,
          countries: [],
          locationBias: null,
          locationRestriction: null,
          origin: null,
          typesFilter: [],
          sessionToken: _sessionToken,
        ),
      );

      if (mounted) {
        setState(() => _loading = false);
        widget.onPredictionsFound(response.predictions, _sessionToken);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActionInputField(
          title: 'Autocomplete Predictions',
          controller: _queryController,
          label: 'Query',
          hint: 'e.g., Pizza in London',
          icon: Icons.map,
          buttonText: 'Get Predictions',
          buttonIcon: Icons.auto_awesome,
          onPressed: _fetchPredictions,
          isLoading: _loading,
          isEnabled: widget.isEnabled && !_loading,
          filledButtonStyle: FilledButton.styleFrom(
            backgroundColor: Colors.orange.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          loadingColor: Colors.white,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const Icon(Icons.vpn_key, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                'Session:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _sessionToken ?? 'None',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: Colors.blueGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: _generateNewSessionToken,
                icon: const Icon(Icons.refresh, size: 16),
                tooltip: 'Rotate Session Token',
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
