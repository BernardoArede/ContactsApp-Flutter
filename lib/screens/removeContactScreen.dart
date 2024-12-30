import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contact.dart';

import '../models/contactStorage.dart';

class RemoveContactScreen extends StatefulWidget {
  final List<Contact> contacts;

  const RemoveContactScreen({Key? key, required this.contacts}) : super(key: key);

  @override
  State<RemoveContactScreen> createState() => _RemoveContactScreenState();
}

class _RemoveContactScreenState extends State<RemoveContactScreen> {
  void _removeContact(Contact contact) async {
    setState(() {
      widget.contacts.remove(contact);
    });
    Navigator.pop(context, contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Remove Contact"),
      ),
      body: widget.contacts.isEmpty
          ? const Center(
        child: Text(
          "No contacts available to remove.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: widget.contacts.length,
        itemBuilder: (context, index) {
          final contact = widget.contacts[index];
          return ListTile(
            leading: contact.imagePath != null
                ? CircleAvatar(
              backgroundImage: FileImage(File(contact.imagePath!)),
            )
                : const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(
                contact.name ?? "Unnamed"
            ),
            subtitle: Text(
                contact.email ?? "No email"
            ),
            trailing: IconButton(
              icon: const Icon(
                  Icons.delete,
                  color: Colors.red
              ),
              onPressed: () {
                _removeContact(contact);
              },
            ),
          );
        },
      ),
    );
  }

}