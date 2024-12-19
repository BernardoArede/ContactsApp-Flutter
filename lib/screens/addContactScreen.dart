
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contact.dart';

class addContactScreen extends StatefulWidget{

  const addContactScreen({super.key});

  @override
  State<addContactScreen> createState()=> _addContactScreen();

}

class _addContactScreen extends State<addContactScreen>{
  late TextEditingController newName;
  late TextEditingController newEmail;
  late TextEditingController newPhone;

  @override
  void initState(){
    super.initState();
    newName = TextEditingController();
    newEmail = TextEditingController();
    newPhone = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
              final newContact = Contact(
                  name: newName.text,
                  email: newEmail.text,
                  phone: newPhone.text
              );
              Navigator.pop(context, newContact);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: newName,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: newEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: newPhone,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );

  }


}