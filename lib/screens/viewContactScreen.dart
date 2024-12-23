import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/screens/editContactScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/contact.dart';

class viewContactScreen extends StatelessWidget {
  final Contact contact;
  LatLng initialCameraPosition = const LatLng(37.7749, -122.4194);
  late GoogleMapController mapController;

  viewContactScreen({super.key, required this.contact});

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permitions.');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //TODO-> Temos que substituir isto pela foto do contacto se tiver se não colocar este icone
            CircleAvatar(
              radius: 60,
              backgroundImage: contact.imagePath != null
                  ? FileImage(File(contact.imagePath!))
                  : null,
              child: contact.imagePath == null
                  ? Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                contact.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.phone, 'Phone', contact.phone),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.email, 'Email', contact.email),
            const SizedBox(height: 16),
            if (contact.birthdate != null)
              _buildDetailRow(Icons.cake, 'Birthdate', contact.birthdate!),
            const SizedBox(height: 8),
            SizedBox(
              height: 200, // Defina a altura desejada para o mapa.
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initialCameraPosition,
                      zoom: 15,
                    ),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) async {
                      Position position = await getCurrentLocation();
                      mapController = controller;
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target:
                                LatLng(position.latitude, position.longitude),
                            zoom: 15,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16, // Distância da parte inferior
                    right: 16, // Distância da lateral direita
                    child: FloatingActionButton(
                      onPressed: () async {
                        Position position = await getCurrentLocation();
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target:
                                  LatLng(position.latitude, position.longitude),
                              zoom: 15,
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Center(
                child: ElevatedButton.icon(
              onPressed: () async {
                final updateContact = await Navigator.push<Contact>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditContactScreen(contact: contact),
                  ),
                );
                if (updateContact != null) {
                  Navigator.pop(context, updateContact);
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit contact"),
            ))
          ],
        ),
      ),
    );
  }
}

Widget _buildDetailRow(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, color: Colors.grey.shade700),
      const SizedBox(width: 16),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
    ],
  );
}
