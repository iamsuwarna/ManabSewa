import 'package:flutter/material.dart';

class AreaOfInterestTextField extends StatefulWidget {
  @override
  _AreaOfInterestTextFieldState createState() =>
      _AreaOfInterestTextFieldState();
}

class _AreaOfInterestTextFieldState extends State<AreaOfInterestTextField> {
  List<String> _selectedAreaOfInterest = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Enter your area of interest",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  FlatButton(
                    child: Text("Option 1"),
                    onPressed: () {
                      setState(() {
                        if (_selectedAreaOfInterest.contains("Option 1")) {
                          _selectedAreaOfInterest.remove("Option 1");
                        } else {
                          _selectedAreaOfInterest.add("Option 1");
                        }
                      });
                    },
                    color: _selectedAreaOfInterest.contains("Option 1")
                        ? Colors.blue
                        : Colors.grey[300],
                    textColor: _selectedAreaOfInterest.contains("Option 1")
                        ? Colors.white
                        : Colors.black,
                  ),
                  FlatButton(
                    child: Text("Option 2"),
                    onPressed: () {
                      setState(() {
                        if (_selectedAreaOfInterest.contains("Option 2")) {
                          _selectedAreaOfInterest.remove("Option 2");
                        } else {
                          _selectedAreaOfInterest.add("Option 2");
                        }
                      });
                    },
                    color: _selectedAreaOfInterest.contains("Option 2")
                        ? Colors.blue
                        : Colors.grey[300],
                    textColor: _selectedAreaOfInterest.contains("Option 2")
                        ? Colors.white
                        : Colors.black,
                  ),
                  FlatButton(
                    child: Text("Option 3"),
                    onPressed: () {
                      setState(() {
                        if (_selectedAreaOfInterest.contains("Option 3")) {
                          _selectedAreaOfInterest.remove("Option 3");
                        } else {
                          _selectedAreaOfInterest.add("Option 3");
                        }
                      });
                    },
                    color: _selectedAreaOfInterest.contains("Option 3")
                        ? Colors.blue
                        : Colors.grey[300],
                    textColor: _selectedAreaOfInterest.contains("Option 3")
                        ? Colors.white
                        : Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
