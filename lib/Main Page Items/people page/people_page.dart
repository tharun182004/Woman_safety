import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    requestContactsPermission(); // Request permission when the page loads
  }

  // Function to request permissions and load contacts
  Future<void> requestContactsPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      loadContacts();
    } else {
      var result = await Permission.contacts.request();
      if (result.isGranted) {
        loadContacts();
      }
    }
  }

  // Function to load contacts
  Future<void> loadContacts() async {
    try {
      final contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts.toList();
      });
    } catch (e) {
      print("Error loading contacts: $e");
    }
  }

  // Function to add a new contact
  Future<void> addContact() async {
    Contact newContact = Contact(
      givenName: "New",
      familyName: "Contact",
      phones: [Item(label: "mobile", value: "1234567890")],
    );
    await ContactsService.addContact(newContact);
    loadContacts(); // Reload contacts after adding a new one
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("People"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await requestContactsPermission();
              await addContact();
            },
          ),
        ],
      ),
      body: _contacts.isEmpty
          ? Center(child: Text("No contacts added. Tap + to add contacts."))
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? 'No Name'),
                  subtitle: contact.phones != null && contact.phones!.isNotEmpty
                      ? Text(contact.phones!.first.value ?? 'No Number')
                      : Text('No Number'),
                );
              },
            ),
    );
  }
}
