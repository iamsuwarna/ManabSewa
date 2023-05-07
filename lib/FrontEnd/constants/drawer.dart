import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/constants/bookmark.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/completeddonation.dart';
import 'package:manav_sewa/FrontEnd/screens/homescreen.dart/viewpending.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // for election upadte's url
    final Uri election_url =
        Uri.parse('https://www.election.chitrawankhabar.com/');
    return Container(
      color: Color.fromARGB(255, 241, 40, 40),
      child: Drawer(
          child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 252, 105, 94),
            ),
            accountName: const Text("चित्रवन खबर",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 64, 64, 64))),
            accountEmail: const Text("www.chitrawankhabar.com",
                style: TextStyle(color: Color.fromARGB(255, 64, 64, 64))),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  'https://chitrawankhabar.com/wp-content/uploads/2022/05/chitrawan-khabar-Header-Logo.png',
                  width: 90,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // use of list tile
          const ListTile(
            title: Text(
              "समाचार श्रेणी",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text("मुख्य समाचार",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const ViewPendingDonations()),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.poll_outlined),
            title: const Text("राजनीति",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const CompletedDonations()),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text("स्वास्थ्य",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => BookmarkScreen()),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
