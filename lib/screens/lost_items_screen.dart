import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';
import '../screens/image_preview.dart';
import 'add_item_screen.dart';
import 'dart:io';

class LostItemsScreen extends StatefulWidget {
  const LostItemsScreen({super.key});

  @override
  State<LostItemsScreen> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  final List<Item> _items = [];
  bool showOnlyNotFound = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _items.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList('items', data);
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('items') ?? [];
    setState(() {
      _items.clear();
      _items.addAll(data.map((e) => Item.fromMap(jsonDecode(e))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedItems = showOnlyNotFound
        ? _items.where((item) => !item.isFound).toList()
        : _items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,

        title: const Text(
          'Lost Items',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          DropdownButton<String>(
            value: showOnlyNotFound ? 'NotFound' : 'All',
            underline: const SizedBox(),
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onChanged: (value) {
              setState(() {
                showOnlyNotFound = (value == 'NotFound');
              });
            },
            items: const [
              DropdownMenuItem(
                value: 'All',
                child: Text('Show All', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'NotFound',
                child: Text(
                  'Show Not Found Only',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      body: displayedItems.isEmpty
          ? const Center(
              child: Text('No items to show', style: TextStyle(fontSize: 25)),
            )
          : ListView.builder(
              itemCount: displayedItems.length,
              itemBuilder: (context, index) {
                final item = displayedItems[index];

                return Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            item.isFound
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: item.isFound ? Colors.green : null,
                          ),
                          onPressed: () {
                            setState(() {
                              item.isFound = !item.isFound;
                            });
                            _saveItems();
                          },
                        ),
                        if (item.imagePath != null)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ImagePreview(imagePath: item.imagePath!),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(item.imagePath!),
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          const Icon(Icons.image_not_supported, size: 45),
                      ],
                    ),
                    title: Text(
                      item.name,
                      style: TextStyle(
                        decoration: item.isFound
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.desc),
                        Text(item.num),
                        if (item.isFound)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'FOUND',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _items.remove(item);
                        });
                        _saveItems();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
        onPressed: () async {
          final newItem = await Navigator.push<Item>(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );

          if (newItem != null) {
            setState(() {
              _items.add(newItem);
            });
            _saveItems();
          }
        },
      ),
    );
  }
}
