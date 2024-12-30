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
  late TextEditingController birthdateController;
  DateTime? birthDate;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    emailController = TextEditingController(text: widget.contact.email);
    phoneController = TextEditingController(text: widget.contact.phone);
    birthdateController = TextEditingController(text: widget.contact.birthdate);
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
              if(nameController.text.isEmpty||
                emailController.text.isEmpty ||
                phoneController.text.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all required fields.")),
                );
                return;
              }
              final updateContact = Contact(
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  birthdate: birthdateController?.text,
                  imagePath: _selectedImage?.path
              );
              Navigator.pop(context, updateContact);
            },
          )
        ],
      ),
      body: OrientationBuilder(builder: (context,orientation){
        if(orientation == Orientation.landscape){

          return Row(
            children: [
              // Parte esquerda: Foto e botões
              Expanded(
                flex: 1,
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
              // Parte direita: Campos de edição
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      TextField(
                        controller: birthdateController,
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'Birthdate'),
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (selectedDate != null) {
                            setState(() {
                              birthdateController.text =
                              '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

        }else{
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
                TextField(
                  controller: birthdateController,
                  readOnly: true, // Define o campo como somente leitura para evitar digitação manual
                  decoration: const InputDecoration(labelText: 'Birthdate'),
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), // Data inicial exibida
                      firstDate: DateTime(1900),   // Data mínima permitida
                      lastDate: DateTime.now(),    // Data máxima permitida
                    );

                    if (selectedDate != null) {
                      setState(() {
                        birthdateController.text =
                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                ),
              ],
            ),
          );
        }
      })
    );
  }
}