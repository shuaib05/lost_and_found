import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';
import 'add_item_screen.dart';

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
        title: const Text('Lost Items'),
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
              DropdownMenuItem(value: 'All', child: Text('Show All')),
              DropdownMenuItem(
                value: 'NotFound',
                child: Text('Show Not Found Only'),
              ),
            ],
          ),
        ],
      ),
      body: displayedItems.isEmpty
          ? const Center(child: Text('No items to show'))
          : ListView.builder(
              itemCount: displayedItems.length,
              itemBuilder: (context, index) {
                final item = displayedItems[index];

                return Card(
                  child: ListTile(
                    leading: IconButton(
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
                    title: Text(
                      item.name,
                      style: TextStyle(
                        decoration: item.isFound
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.desc),
                        Text(item.num),
                        if (item.isFound)
                          const Text(
                            'FOUND',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
