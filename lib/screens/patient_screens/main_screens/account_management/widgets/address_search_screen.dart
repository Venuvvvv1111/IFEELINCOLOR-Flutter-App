import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddressSearchScreenState createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  List<String> predictions = [];
  // String accessToken =
  //     'pk.f242a135794c6dd00503bc2b331f77e3'; // Replace with your API access token
  String accessToken = 'AIzaSyDYnSt88OMQBytz2HAtEGjeiEMQ6HcwpQY';

  bool isLoading = false;
  String query = "";
  void searchPlace(String input) async {
    if (input.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      // 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$accessToken&components=country:in';
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?address=$input&key=$accessToken";
      try {
        final response = await http.get(Uri.parse(url));
        final data = json.decode(response.body);
        if (kDebugMode) {
          print(response.statusCode);
          print(response.body);
        }

        if (mounted) {
          if (response.statusCode == 200 && data['status'] == 'OK') {
            setState(() {
              predictions = data['results']
                  .map<String>((item) => item['formatted_address'].toString())
                  .toList();
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            if (kDebugMode) {
              print('Autocomplete Error: ${data['status']}');
            }
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    } else {
      if (mounted) {
        setState(() {
          predictions = [];
          isLoading = false;
        });
      }
    }
  }

  // // Function to search for addresses (Autocomplete)
  // void searchPlace(String query) async {
  //   if (query.isNotEmpty) {
  //     setState(() {
  //       isLoading = true;
  //     });

  //     final url =
  //         'https://api.locationiq.com/v1/autocomplete?key=$accessToken&q=$query&limit=5&dedupe=1';
  //     try {
  //       final response = await http.get(Uri.parse(url));

  //       if (mounted) {
  //         // Ensure widget is still active
  //         if (response.statusCode == 200) {
  //           final data = json.decode(response.body);
  //           setState(() {
  //             predictions = data
  //                 .map<String>(
  //                     (result) => result['display_name']?.toString() ?? '')
  //                 .toList();
  //             isLoading = false;
  //           });
  //         } else {
  //           setState(() {
  //             isLoading = false;
  //           });
  //           print('Error fetching data');
  //         }
  //       }
  //     } catch (e) {
  //       if (mounted) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }
  //       print('Error: $e');
  //     }
  //   } else {
  //     if (mounted) {
  //       setState(() {
  //         predictions = [];
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  // // Function to fetch latitude and longitude (Forward Geocoding)
  // void fetchPlaceDetails(String place) async {
  //   final url =
  //       'https://us1.locationiq.com/v1/search?key=$accessToken&q=$place&format=json';
  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final lat = data[0]['lat'];
  //     final lon = data[0]['lon'];
  //     final address = data[0]['display_name'];

  //     Navigator.pop(context, {
  //       'address': address,
  //       'latitude': lat,
  //       'longitude': lon,
  //     });
  //   } else {
  //     print('Error fetching place details');
  //   }
  // }
  void fetchPlaceDetails(String place, context) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(place)}&key=$accessToken';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];
        final address = data['results'][0]['formatted_address'];

        Navigator.pop(context, {
          'address': address,
          'latitude': location['lat'],
          'longitude': location['lng'],
        });
      } else {
        if (kDebugMode) {
          print('Geocode Error: ${data['status']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Address'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Enter address...',
                    border: InputBorder.none,
                    isDense: true),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                  searchPlace(value);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Recent Searches Section
            Expanded(
              child: isLoading
                  ? ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 60,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    )
                  : predictions.isNotEmpty
                      ? ListView.separated(
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(predictions[index]),
                              onTap: () {
                                fetchPlaceDetails(predictions[index], context);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search,
                                size: 50,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                query.isNotEmpty
                                    ? 'No results found'
                                    : 'Search for addresses',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Perform additional cleanup if required
  }
}
