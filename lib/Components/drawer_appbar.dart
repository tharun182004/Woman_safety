import 'package:flutter/material.dart';

class drawer_list extends StatefulWidget {
  const drawer_list({super.key});

  @override
  State<drawer_list> createState() => _drawer_listState();
}

class _drawer_listState extends State<drawer_list> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("Images/New_Logo.png"),
                        fit: BoxFit.fill))),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(children: [
                  ListTile(
                    leading: Icon(Icons.home,
                        color: Color.fromARGB(255, 143, 53, 101)),
                    title: Text(
                      "Home",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 143, 53, 101)),
                    ),
                    onTap: () {
                      print("home button");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings_outlined,
                        color: Color.fromARGB(255, 143, 53, 101)),
                    title: Text("Settings",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 143, 53, 101))),
                    onTap: () {
                      print("Settings button");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person,
                        color: Color.fromARGB(255, 143, 53, 101)),
                    title: Text("About US",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 143, 53, 101))),
                    onTap: () {
                      print("About us button");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications,
                        color: Color.fromARGB(255, 143, 53, 101)),
                    title: Text("Notification",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 143, 53, 101))),
                    onTap: () {
                      print("Notification button");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock_rounded,
                        color: Color.fromARGB(255, 143, 53, 101)),
                    title: Text("Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 143, 53, 101))),
                    onTap: () {
                      print("Logout button");
                    },
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
