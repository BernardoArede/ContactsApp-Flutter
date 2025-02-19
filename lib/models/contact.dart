
import "package:flutter/cupertino.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";


class Contact{
  String name;
  String email;
  String phone;
  String? birthdate;
  String? imagePath;
  Set<Marker> locations;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
    this.birthdate,
    this.imagePath,
    Set<Marker>? locations,
  }) : locations = locations ?? <Marker>{};

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'birthdate': birthdate,
      'imagePath': imagePath,
      'locations': locations.map((location) => {
        'id': location.markerId.value,
        'lat': location.position.latitude,
        'lng': location.position.longitude,
        'title': location.infoWindow.title,
      }).toList(),
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      birthdate: json['birthdate'],
      imagePath: json['imagePath'],
      locations: (json['locations'] as List<dynamic>?)?.map((location) {
        return Marker(
          markerId: MarkerId(location['id'] as String),
          position: LatLng(location['lat'] as double, location['lng'] as double),
          infoWindow: InfoWindow(
            title: location['title'] as String?,
            snippet: "Lat: ${location['lat']}, Lng: ${location['lng']}",
          ),
        );
      }).toSet() ?? {},
    );
  }




  void removeLocation(Marker targetMarker) {
    const double maxDistanceInMeters = 2000; // 2 km em metros

    locations.removeWhere((marker) {
      double distance = Geolocator.distanceBetween(
        marker.position.latitude,
        marker.position.longitude,
        targetMarker.position.latitude,
        targetMarker.position.longitude,
      );
      return distance <= maxDistanceInMeters;
    });
  }



}

