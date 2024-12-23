import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'contact.dart';

class ListContactManager {
  static const String _listContactKey = 'listContact';

  static Future<void> addContact(Contact contact) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? contactsJson = prefs.getString(_listContactKey);

    List<Contact> contacts = contactsJson != null
        ? (json.decode(contactsJson) as List).map((item) => Contact.fromJson(item)).toList()
        : <Contact>[];

    contacts.removeWhere((value) => value.name == contact.name);

    contacts.insert(0, contact);

    if (contacts.length > 10) {
      contacts = contacts.sublist(0, 10);
    }

    prefs.setString(_listContactKey, json.encode(contacts));
  }

  static Future<List<Contact>> getContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? contactsJson = prefs.getString(_listContactKey);

    if (contactsJson != null) {
      return (json.decode(contactsJson) as List)
          .map((value) => Contact.fromJson(value))
          .toList();
    }

    return [];
  }
}
