import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contactStorage.dart';
import 'package:flutter_contacts/screens/viewContactScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';
import 'addContactScreen.dart';
import 'listContactSreen.dart';
import 'removeContactScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ContactStorage contactStorage = ContactStorage();
  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    _initializeContacts();
  }
  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("SharedPreferences limpas com sucesso!");
  }

  Future<void> _initializeContacts() async {
    await contactStorage.loadContacts();
    setState(() {
      contacts = contactStorage.contacts;
    });
  }

  Future<void> _saveContacts() async {
    for (var contact in contacts) {
      await contactStorage.saveContact(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newContact = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => const addContactScreen(),
                ),
              );
              if (newContact != null) {
                setState(() {
                  contacts.add(newContact);
                });
                await _saveContacts();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final removedContact = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => RemoveContactScreen(contacts: contacts),
                ),
              );
              if (removedContact != null) {
                setState(() {
                  contacts.remove(removedContact);
                });
                await _saveContacts();
              }
            },
          ),
         /* IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListContactScreen(contacts: contacts),
                ),
              );
            },
          ),*/
        ],
      ),
      body: contacts.isEmpty
          ? const Center(
        child: Text(
          "No contacts available.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(contact['name']),
              subtitle: Text(
                '${contact['email']} \n${contact['phone']}\n'
                    '${contact['birthdate'] ?? " "}', // igual a: ${contact.birthdate != null ? contact.birthdate : " "}
              ),
              isThreeLine: true,
              onTap: () async {
                /* updateContact = await Navigator.push<Contact>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => viewContactScreen(contact: contact),
                  ),
                );
                if (updateContact != null) {
                  setState(() {
                    contacts[index] = updateContact;
                  });
                }*/
              },
            ),
          );
        },
      ),
    );
  }
}
