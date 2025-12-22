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
                return Card(
                  child: ListTile(
                    title: Text(
                      _items[index].name,
                      style: TextStyle(
                        decoration: _items[index].isFound
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _items[index].desc,
                          style: TextStyle(
                            decoration: _items[index].isFound
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        Text(
                          _items[index].num,
                          style: TextStyle(
                            decoration: _items[index].isFound
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          _items[index].isFound = !(_items[index].isFound);
                        });
                      },
                      icon: Icon(
                        _items[index].isFound
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                      color: _items[index].isFound ? Colors.green : null,
                    ),
                  ),
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
