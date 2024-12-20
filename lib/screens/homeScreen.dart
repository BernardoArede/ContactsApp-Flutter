import 'package:flutter/material.dart';
import 'package:flutter_contacts/screens/viewContactScreen.dart';
import '../models/contact.dart';
import 'addContactScreen.dart';
import 'editContactScreen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  final List<Contact> contacts = [
    Contact(name: 'Bernardo', email: 'bernardo@example.com', phone: '927252511', birthdate: "2004-07-03"),
    Contact(name: 'Ricardo', email: 'ricardo@example.com', phone: '962445987'),
    Contact(name: 'Xudas', email: 'xudasd@example.com', phone: '925969973'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async{
              final newContact = await Navigator.push<Contact>(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const addContactScreen(),
                  ),
              );
              if(newContact != null){
                setState(() {
                  contacts.add(newContact);
                });
              }
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(contact.name),
              subtitle: Text('${contact.email} \n${contact.phone}${contact.birthdate !=null ? '\n${contact.birthdate}' : ''}'),
              isThreeLine: true,
              onTap: () async{
                final updateContact = await Navigator.push<Contact>(
                  context,
                  MaterialPageRoute(
                    builder:(context) => viewContactScreen(contact:contact),
                  ),
                );
                if(updateContact != null){
                  setState(() {
                    contacts[index] = updateContact;
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

