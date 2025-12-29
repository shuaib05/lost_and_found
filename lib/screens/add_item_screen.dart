import 'package:flutter/material.dart';
import '../models/item.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Item")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Item name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter item name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: "Item description:"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter item description:';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _numController,
                  decoration: InputDecoration(labelText: 'Phone No:'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Phone No';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _selectedImage == null
                    ? ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Pick Image'),
                      )
                    : Image.file(
                        _selectedImage!,
                        height: 150,
                        fit: BoxFit.cover,
                      ),

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final item = Item(
                        name: _nameController.text,
                        desc: _descController.text,
                        num: _numController.text,
                        imagePath: _selectedImage?.path,
                      );
                      Navigator.pop(context, item);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
