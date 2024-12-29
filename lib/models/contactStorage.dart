import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ContactStorage {
  static const String _contactsKey = 'contacts';

  List<Map<String, dynamic>> _contacts = [];


  Future<void> saveContact(Map<String, dynamic> contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contacts = prefs.getStringList(_contactsKey) ?? [];
    contacts.add(jsonEncode(contact));
    await prefs.setStringList(_contactsKey, contacts);
  }

  Future<void> saveAllContacts(List<Map<String, dynamic>> updatedContacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedContacts = updatedContacts.map((contact) => jsonEncode(contact)).toList();
    await prefs.setStringList(_contactsKey, encodedContacts);
  }

  Future<void> loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedContacts = prefs.getStringList(_contactsKey) ?? [];
    _contacts =  storedContacts
        .map((contact) => jsonDecode(contact) as Map<String, dynamic>)
        .toList();
  }



  List<Map<String, dynamic>> get contacts => _contacts;
}