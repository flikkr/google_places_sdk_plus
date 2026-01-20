import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';

class PredictionListSheet extends StatelessWidget {
  final List<AutocompletePrediction> predictions;
  final Function(AutocompletePrediction) onPredictionSelected;
  final ScrollController scrollController;

  final String? sessionToken;

  const PredictionListSheet({
    super.key,
    required this.predictions,
    required this.onPredictionSelected,
    required this.scrollController,
    this.sessionToken,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Found ${predictions.length} Predictions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (sessionToken != null) ...[
          const SizedBox(height: 4),
          Text(
            'Session: $sessionToken',
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              color: Colors.grey.shade500,
            ),
          ),
        ],
        const Divider(),
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: predictions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final prediction = predictions[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(
                    prediction.primaryText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    prediction.secondaryText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: prediction.distanceMeters != null
                      ? Text(
                          '${(prediction.distanceMeters! / 1000).toStringAsFixed(1)} km',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        )
                      : null,
                  onTap: () => onPredictionSelected(prediction),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
