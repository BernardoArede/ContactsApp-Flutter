
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contact.dart';
import 'package:image_picker/image_picker.dart';

class addContactScreen extends StatefulWidget{

  const addContactScreen({super.key});

  @override
  State<addContactScreen> createState()=> _addContactScreen();

}

class _addContactScreen extends State<addContactScreen>{
  late TextEditingController newName;
  late TextEditingController newEmail;
  late TextEditingController newPhone;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    newName = TextEditingController();
    newEmail = TextEditingController();
    newPhone = TextEditingController();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null){
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
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
                  phone: newPhone.text,
                  imagePath: _selectedImage?.path
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
            if(_selectedImage != null)
              CircleAvatar(
                radius: 60,
                backgroundImage: FileImage(_selectedImage!),
              )
            else
              const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
              ),
            const SizedBox(height: 16,),
            ElevatedButton.icon(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              icon: const Icon(Icons.photo),
              label: const Text("Choose from gallery"),
            ),
            ElevatedButton.icon(
                onPressed: () {
                  _pickImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text("Take a photo"),
            ),
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