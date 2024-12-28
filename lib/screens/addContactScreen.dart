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

class _addContactScreen extends State<addContactScreen> {
  late TextEditingController newName;
  late TextEditingController newEmail;
  late TextEditingController newPhone;
  DateTime? birthDate;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    newName = TextEditingController();
    newEmail = TextEditingController();
    newPhone = TextEditingController();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectBirthdate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != birthDate) {
      setState(() {
        birthDate = pickedDate;
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
            onPressed: () {
              final newContact = Contact(
                  name: newName.text,
                  email: newEmail.text,
                  phone: newPhone.text,
                  birthdate: birthDate.toString().split(' ')[0],
                  imagePath: _selectedImage?.path
              );
              Navigator.pop(context, newContact);
            },
          )
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return Row(
            children: [
              // Lado Esquerdo
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_selectedImage != null)
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(_selectedImage!),
                      )
                    else
                      const CircleAvatar(
                        radius: 60,
                        child: Icon(Icons.person, size: 60),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo),
                      label: const Text("Choose from gallery"),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text("Take a photo"),
                    ),
                  ],
                ),
              ),
              // Divisória
              const VerticalDivider(thickness: 1, color: Colors.grey),
              // Lado Direito
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: newName,
                        decoration:
                        const InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: newEmail,
                        decoration:
                        const InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: newPhone,
                        decoration:
                        const InputDecoration(labelText: 'Phone'),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          _selectBirthdate(context);
                        },
                        icon: const Icon(Icons.cake),
                        label: const Text("Select Birthdate"),
                      ),
                      if (birthDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Birthdate: ${birthDate!.toLocal().toString().split(
                                ' ')[0]}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Birthdate: Not Selected",
                            style:
                            TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Padding(
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
                const SizedBox(height: 8,),
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
                const SizedBox(height: 16,),
                ElevatedButton.icon(
                  onPressed: () {
                    _selectBirthdate(context);
                  },
                  icon: const Icon(Icons.cake),
                  label: const Text("Select Birthdate"),
                ),
                if (birthDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Birthdate: ${birthDate!.toLocal().toString().split(
                          ' ')[0]}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: const Text(
                      "Birthdate: Not Selected",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          );
        }
      },
      ),
    );
  }
}