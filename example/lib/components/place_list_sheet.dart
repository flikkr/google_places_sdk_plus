import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';

class PlaceListSheet extends StatelessWidget {
  final List<Place?> places;
  final Function(Place) onPlaceSelected;
  final ScrollController scrollController;

  const PlaceListSheet({
    super.key,
    required this.places,
    required this.onPlaceSelected,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    if (place != null) {
                      onPlaceSelected(place);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
