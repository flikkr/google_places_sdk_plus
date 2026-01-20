import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';
import 'place_json_extension.dart';

class PlaceResultContent extends StatefulWidget {
  final Place? place;
  final String? error;
  final ScrollController scrollController;
  final PlacesHostApi? placesApi;

  const PlaceResultContent({
    super.key,
    this.place,
    this.error,
    required this.scrollController,
    this.placesApi,
    this.sessionToken,
  });

  final String? sessionToken;

  @override
  State<PlaceResultContent> createState() => _PlaceResultContentState();
}

class _PlaceResultContentState extends State<PlaceResultContent> {
  final Map<int, String> _fetchedPhotoUris = {};
  final Map<int, bool> _loadingPhotos = {};

  Future<void> _fetchPhoto(int index, PhotoMetadata metadata) async {
    if (widget.placesApi == null) return;

    setState(() {
      _loadingPhotos[index] = true;
    });

    try {
      final response = await widget.placesApi!.fetchPhoto(
        FetchPhotoRequest(
          photoMetadata: metadata,
          maxWidth: 500,
          maxHeight: 500,
        ),
      );
      if (mounted) {
        if (response.uri != null) {
          setState(() {
            _fetchedPhotoUris[index] = response.uri!;
            _loadingPhotos[index] = false;
          });
        } else {
          setState(() {
            _loadingPhotos[index] = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Photo URI not found')));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingPhotos[index] = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error fetching photo: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String jsonString;
    if (widget.error != null) {
      jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert({'error': widget.error});
    } else if (widget.place != null) {
      jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(widget.place!.toJson());
    } else {
      jsonString = '{}';
    }

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
          widget.error != null ? 'Error' : 'Place Details',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (widget.sessionToken != null) ...[
          const SizedBox(height: 4),
          Text(
            'Session: ${widget.sessionToken}',
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              color: Colors.grey.shade500,
            ),
          ),
        ],
        if (widget.place?.photoMetadatas?.isNotEmpty == true) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: widget.place!.photoMetadatas!.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final metadata = widget.place!.photoMetadatas![index]!;
                final photoUri = _fetchedPhotoUris[index];
                final isLoading = _loadingPhotos[index] == true;

                if (photoUri != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      photoUri,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image)),
                        );
                      },
                    ),
                  );
                }

                return InkWell(
                  onTap: isLoading || widget.placesApi == null
                      ? null
                      : () => _fetchPhoto(index, metadata),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.photo_camera, color: Colors.grey),
                                SizedBox(height: 4),
                                Text(
                                  'Fetch\nPhoto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Divider(),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: SelectableText(
                jsonString,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
