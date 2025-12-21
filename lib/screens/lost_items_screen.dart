import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/add_item_screen.dart';
import '../models/item.dart';

class LostItemsScreen extends StatefulWidget {
  const LostItemsScreen({super.key});

  @override
  State<LostItemsScreen> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  final List<Item> _items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lost Items')),
      body: _items.isEmpty
          ? const Center(child: Text("No items to show"))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index].name),
                  subtitle: Text(_items[index].desc),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push<Item>(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
          if (newItem != null) {
            setState(() {
              _items.add(newItem);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
