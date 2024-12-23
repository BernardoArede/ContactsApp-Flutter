import 'package:flutter/material.dart';
import '../models/contact.dart';

class ListContactScreen extends StatefulWidget {
  final List<Contact> contacts;

  const ListContactScreen({Key? key, required this.contacts}) : super(key: key);

  @override
  _ListContactScreenState createState() => _ListContactScreenState();
}

class _ListContactScreenState extends State<ListContactScreen> {

  @override
  Widget build(BuildContext context) {
    final listContact = widget.contacts.reversed.take(10).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Contacts'),
      ),
      body: listContact.isEmpty
          ? const Center(
        child: Text(
          "No recent contacts in list.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: listContact.length,
        itemBuilder: (context, index) {
          final contact = listContact[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(contact.name),
              subtitle: Text(
                '${contact.email}\n${contact.phone}${contact.birthdate != null ? '\n${contact.birthdate}' : ''}',
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
