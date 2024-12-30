  import 'package:flutter/material.dart';
  import 'package:flutter_contacts/models/contactStorage.dart';
  import 'package:flutter_contacts/screens/viewContactScreen.dart';
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

    List<Contact> contacts = [];

    @override
    void initState() {
      super.initState();
      _loadContacts();
    }
    void _loadContacts() async {
      final loadedContacts = await contactStorage.loadContacts();

      setState(() {
        for (var contact in loadedContacts) {
          if (!contacts.any((existingContact) => existingContact.email == contact.email)) {
            contacts.add(contact);
          }
        }

      });
    }

    void _removeContact(Contact contact) {
      setState(() {
        contacts.remove(contact);
        contactStorage.saveContacts(contacts);
      });
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
                final newContact = await Navigator.push<Contact>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const addContactScreen(),
                  ),
                );
                if (newContact != null) {
                  setState(() {
                    contacts.add(newContact);
                    contactStorage.saveContacts(contacts);
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final removedContact = await Navigator.push<Contact>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RemoveContactScreen(contacts: List.from(contacts)),
                  ),
                );
                if (removedContact != null) {
                  _removeContact(removedContact);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListContactScreen(contacts: contacts),
                  ),
                );
              },
            ),
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
                title: Text(contact.name),
                subtitle: Text(
                  '${contact.email} \n${contact.phone}\n'
                      '${contact.birthdate ?? ""}', // igual a: ${contact.birthdate != null ? contact.birthdate : " "}
                ),
                isThreeLine: true,
                onTap: () async {
                  final updateContact = await Navigator.push<Contact>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => viewContactScreen(contact: contact),
                    ),
                  );
                  if (updateContact != null) {
                    setState(() {
                      contacts[index] = updateContact;
                      contactStorage.saveContacts(contacts);
                    });
                  }
                },
              ),
            );
          },
        ),
      );
    }
  }
