import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  // Function to load contacts
  Future<void> loadContacts() async {
    try {
      // Request permission and fetch contacts
      if (await FlutterContacts.requestPermission()) {
        final contacts =
            await FlutterContacts.getContacts(withProperties: true);
        setState(() {
          _contacts = contacts;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading contacts: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to add a new contact
  Future<void> addContact() async {
    try {
      final newContact = Contact(
        name: Name(first: 'John', last: 'Doe'),
        phones: [Phone('123456789')],
      );

      await FlutterContacts.insertContact(newContact);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact added successfully')),
      );

      // Reload contacts to include the new one
      loadContacts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add contact: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("People"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addContact,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
              ? Center(child: Text("No contacts available."))
              : ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = _contacts[index];
                    return ListTile(
                      title: Text(contact.displayName),
                      subtitle: contact.phones.isNotEmpty
                          ? Text(contact.phones.first.number)
                          : Text('No Number'),
                    );
                  },
                ),
    );
  }
}
