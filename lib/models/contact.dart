
import "location.dart";

class Contact{
  String name;

  String email;

  String phone;

  String? birthdate;

  String? imagePath;

  List<Location> locations;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
    this.birthdate,
    this.imagePath,
    this.locations = const [],
  });

  

}


