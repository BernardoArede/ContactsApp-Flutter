import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/contact.dart';


class EditContactScreen extends StatefulWidget{

  final Contact contact;


  const EditContactScreen({super.key, required this.contact});

  @override
  State<EditContactScreen> createState()=>_EditContactScreenState();

}

class _EditContactScreenState extends State<EditContactScreen>{
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dateController;

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    emailController = TextEditingController(text: widget.contact.email);
    phoneController = TextEditingController(text: widget.contact.phone);
    dateController = TextEditingController(text: widget.contact.birthdate);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){
              final updateContact = Contact(
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  birthdate: dateController.text
              );
              Navigator.pop(context, updateContact);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),

            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Birthdate'),
              keyboardType: TextInputType.datetime,
            )
          ],
        ),
      ),
    );
  }
}