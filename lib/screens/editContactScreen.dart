import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    emailController = TextEditingController(text: widget.contact.email);
    phoneController = TextEditingController(text: widget.contact.phone);
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
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
          ],
        ),
      ),
    );
  }
}