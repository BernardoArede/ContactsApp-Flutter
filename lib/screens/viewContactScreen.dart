
import 'package:flutter/material.dart';
import 'package:flutter_contacts/screens/editContactScreen.dart';
import '../models/contact.dart';

class viewContactScreen extends StatelessWidget {
  final Contact contact;
  const viewContactScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /*TODO-> Temos que substituir isto pela foto do contacto se tiver se não colocar este icone*/
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 60, color: Colors.white),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                contact.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                contact.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.phone, 'Phone', contact.phone),
            if(contact.birthdate != null)
              const SizedBox(height: 8),
            _buildDetailRow(Icons.cake, 'Birthdate', contact.birthdate!),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                  onPressed: () async{
                    final updateContact =  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditContactScreen(contact: contact),
                      ),
                  );
                    if(updateContact != null){
                      Navigator.pop(context, updateContact);
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit contact"),
              )
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildDetailRow(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, color: Colors.grey.shade700),
      const SizedBox(width: 16),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
    ],
  );
}
