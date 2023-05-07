import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  //List to hold the user data
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    //call function to fetch user data
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=20'));
    //parse the JSON response
    final data = json.decode(response.body);
    setState(() {
      //update the user list with fetched data
      users = List<Map<String, dynamic>>.from(data['results']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 245, 250, 183),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    users = users
                        .where((user) => user['name']['first']
                            .toLowerCase()
                            .contains(text.toLowerCase()))
                        //filter users by name based on the search text
                        .toList();
                  });
                  if (text == null || text.isEmpty) {
                    //if search text is empty, clear the user list
                    users.clear();
                    //fetch all users again
                    fetchUsers();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        users.clear();
                        fetchUsers();
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Expanded(
              child: users.isEmpty
                  ? Center(
                      child: Text("No user Found!"),
                    )
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user['picture']['thumbnail']),
                              ),
                              title: Text(
                                '${user['name']['first']} ${user['name']['last']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                user['email'],
                                style: TextStyle(fontSize: 14.0),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
