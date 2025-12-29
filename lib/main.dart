import 'package:flutter/material.dart';
import 'screens/lost_items_screen.dart';

void main() {
  runApp(const Lost_and_Found());
}

class Lost_and_Found extends StatelessWidget {
  const Lost_and_Found({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const LostItemsScreen(),
    );
  }
}
