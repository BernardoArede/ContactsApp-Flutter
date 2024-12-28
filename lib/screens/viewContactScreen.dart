import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/screens/editContactScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/contact.dart';
import 'package:intl/intl.dart';

class viewContactScreen extends StatefulWidget {
  final Contact contact;

  const viewContactScreen({Key? key, required this.contact}) : super(key: key);

  @override
  _viewContactScreenState createState() => _viewContactScreenState();
}

class _viewContactScreenState extends State<viewContactScreen> {
  late LatLng initialCameraPosition;
  late GoogleMapController mapController;
  late Set<Marker> locations;

  @override
  void initState() {
    super.initState();
    // Inicializa o mapa na posição inicial.
    initialCameraPosition =
    const LatLng(37.7749, -122.4194); // Exemplo: São Francisco.
    locations =
        widget.contact.locations; // Inicializa com os marcadores do contato.
  }

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

  /*void removeMarker(LatLng position) {
      removeWhere((marker) {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          marker.position.latitude,
          marker.position.longitude,
        );
        return distance <= 5000; // 5 km de distância
      });
    }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return Row(
            children: [
              // Lado esquerdo
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: widget.contact.imagePath != null
                            ? FileImage(File(widget.contact.imagePath!))
                            : null,
                        child: widget.contact.imagePath == null
                            ? Icon(Icons.person, size: 20, color: Colors.white)
                            : null,
                        backgroundColor: Theme
                            .of(context)
                            .primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          widget.contact.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(thickness: 1),
                      _buildDetailRow(
                          Icons.phone, 'Phone', widget.contact.phone),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                          Icons.email, 'Email', widget.contact.email),
                      const SizedBox(height: 16),
                      if (widget.contact.birthdate != null)
                        _buildDetailRow(Icons.cake, 'Birthdate', widget.contact
                            .birthdate!),
                      const Spacer(),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final updateContact = await Navigator.push<Contact>(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditContactScreen(contact: widget.contact),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              // Lado direito
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            GoogleMap(
                              markers: widget.contact.locations,
                              initialCameraPosition: CameraPosition(
                                target: initialCameraPosition,
                                zoom: 15,
                              ),
                              mapType: MapType.normal,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              onMapCreated: (
                                  GoogleMapController controller) async {
                                Position position = await getCurrentLocation();
                                mapController = controller;
                                mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(position.latitude, position
                                          .longitude),
                                      zoom: 15,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              Position position = await getCurrentLocation();
                              final newMarker = Marker(
                                markerId: MarkerId(DateTime.now().toString()),
                                position: LatLng(
                                    position.latitude, position.longitude),
                                infoWindow: InfoWindow(
                                    title: DateFormat('dd/MM/yyyy HH:mm')
                                        .format(DateTime.now())),
                              );

                              setState(() {
                                widget.contact.locations.add(newMarker);
                              });
                            },
                            icon: const Icon(Icons.add_location_alt),
                            label: const Text("Add Marker"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              Position position = await getCurrentLocation();
                              setState(() {
                                locations.removeWhere((marker) =>
                                marker.position.latitude == position.latitude &&
                                    marker.position.longitude ==
                                        position.longitude);
                              });
                            },
                            icon: const Icon(Icons.wrong_location),
                            label: const Text("Remove Marker"),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.list),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Locations List"),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView(
                                    children: widget.contact.locations.map((
                                        marker) {
                                      return Card(
                                        elevation: 4,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: ListTile(
                                          leading: const Icon(
                                              Icons.location_on),
                                          title: Text(marker.infoWindow.title ??
                                              "No Title"),
                                          subtitle: Text(
                                            marker.infoWindow.snippet ??
                                                "Lat: ${marker.position
                                                    .latitude}, Lng: ${marker
                                                    .position.longitude}",
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Close"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        label: const Text("Historic of Locations"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: widget.contact.imagePath != null
                      ? FileImage(File(widget.contact.imagePath!))
                      : null,
                  child: widget.contact.imagePath == null
                      ? Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    widget.contact.name,
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
                _buildDetailRow(Icons.phone, 'Phone', widget.contact.phone),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.email, 'Email', widget.contact.email),
                const SizedBox(height: 16),
                if (widget.contact.birthdate != null)
                  _buildDetailRow(
                      Icons.cake, 'Birthdate', widget.contact.birthdate!),
                const SizedBox(height: 8),
                const Divider(thickness: 1),
                const SizedBox(height: 8),
                SizedBox(
                  height: 250, // Defina a altura desejada para o mapa.
                  child: Stack(
                    children: [
                      GoogleMap(
                        markers: widget.contact.locations,
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        Position position = await getCurrentLocation();
                        final newMarker = Marker(
                          markerId: MarkerId(DateTime.now().toString()),
                          position: LatLng(
                              position.latitude, position.longitude),
                          infoWindow: InfoWindow(
                              title: DateFormat('dd/MM/yyyy HH:mm').format(
                                  DateTime.now())),
                        );

                        setState(() {
                          widget.contact.locations.add(newMarker);
                        });
                      },
                      icon: const Icon(Icons.add_location_alt),
                      label: const Text("Add Marker"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        Position position = await getCurrentLocation();
                        setState(() {
                          locations.removeWhere((marker) =>
                          marker.position.latitude == position.latitude &&
                              marker.position.longitude == position.longitude);
                        });
                      },
                      icon: const Icon(Icons.wrong_location),
                      label: const Text("Remove Marker"),
                    ),

                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.list),
                  onPressed: () {
                    // Exibe o pop-up com os marcadores
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Locations List"),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView(
                              children: widget.contact.locations.map((marker) {
                                return Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8),
                                  child: ListTile(
                                    leading: const Icon(Icons.location_on),
                                    title: Text(
                                        marker.infoWindow.title ?? "No Title"),
                                    subtitle: Text(
                                      marker.infoWindow.snippet ??
                                          "Lat: ${marker.position
                                              .latitude}, Lng: ${marker.position
                                              .longitude}",
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  label: const Text("Historic of Locations"),
                ),
                const Spacer(),
                Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final updateContact = await Navigator.push<Contact>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditContactScreen(contact: widget.contact),
                          ),
                        );
                        if (updateContact != null) {
                          Navigator.pop(context, updateContact);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit contact")
                      ,))
              ],
            ),
          );
        }
      },
      ),
    );
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
}
