
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:stepit/services/location_service.dart';

class FlutterMapWidget extends StatelessWidget {

  const FlutterMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
    final locationService = context.watch<LocationService>();
    final currentPosition = locationService.currentPosition;

    if(currentPosition != null) {

      return ListenableBuilder(
        listenable: locationService,
        builder: (context, child) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FlutterMap(
              // mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(currentPosition.latitude, currentPosition.longitude), // Default center
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  // subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(currentPosition.latitude, currentPosition.longitude),
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.location_on,
                          size: 40, color: Colors.red),
                    
                    ),
                  ],
                ),
                  
              ],
            ),
            ),
          );
          
           
        },
      );
    } 

  return const SizedBox.shrink();
  }
}

