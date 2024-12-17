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

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    emailController = TextEditingController(text: widget.contact.email);
    phoneController = TextEditingController(text: widget.contact.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
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
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.contact.name = nameController.text;
                  widget.contact.email = emailController.text;
                  widget.contact.phone = phoneController.text;
                });
                Navigator.pop(context, widget.contact);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}