import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Actor {
  String name;
  File imageFile;

  Actor({required this.name, required this.imageFile});
}

class ActorForm extends StatefulWidget {
  @override
  _ActorFormState createState() => _ActorFormState();
}

class _ActorFormState extends State<ActorForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final actor = Actor(name: _nameController.text, imageFile: _imageFile!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActorDisplay(actor: actor)),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Who is your Favorite Actor?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Actor Name',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an actor name';
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 16),
              Expanded(
                child: Center(
                  child: _imageFile == null
                      ? const Text('No image selected')
                      : Image.file(_imageFile!),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.camera),
                    child: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade800,
                      onPrimary: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.gallery),
                    child: const Text('Choose From Gallery'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade800,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow.shade200,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActorDisplay extends StatelessWidget {
  final Actor actor;

  ActorDisplay({required this.actor});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text('Favorite Actor'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: FileImage(actor.imageFile),
                radius: 50,
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 16),
              Text(
                actor.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
