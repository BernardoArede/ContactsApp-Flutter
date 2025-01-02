import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'contact.dart';

class ContactStorage {

 Future<String> getFilePath() async {
    final filePath = await getApplicationDocumentsDirectory();
    return '${filePath.path}/contactos.txt';
  }


  Future<void> saveContacts(List<Contact> contacts) async {
    final filePath = await getFilePath();
    final file = File(filePath);
    try {
      final contactJson = contacts.map((contact) => contact.toJson()).toList();
      await file.writeAsString(jsonEncode(contactJson));

    } catch (e) {
      print("Error writing to file: $e");
    }
  }


  Future<List<Contact>> loadContacts() async {
    final filePath = await getFilePath();
    final file = File(filePath);

    if (!await file.exists()) {
      return [];
    }

    final content = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(content);
    return jsonData.map((data) => Contact.fromJson(data)).toList();
  }

 Future<void> updateContact(Contact updatedContact) async {
   final contacts = await loadContacts();
   final updatedContacts = contacts.map((contact) {
     return contact.name == updatedContact.name ? updatedContact : contact;
   }).toList();
   await saveContacts(updatedContacts);
 }
}
