import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/calls_screen.dart';
import 'package:whatsapp_clone/screens/chats_screen.dart';
import 'package:whatsapp_clone/screens/community_screen.dart';
import 'package:whatsapp_clone/screens/updates_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WhatsAppHomeScreen(),
    );
  }
}

class WhatsAppHomeScreen extends StatefulWidget {
  const WhatsAppHomeScreen({super.key});

  @override
  State<WhatsAppHomeScreen> createState() => _WhatsAppHomeScreenState();
}

class _WhatsAppHomeScreenState extends State<WhatsAppHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const ChatsScreen(),
    const UpdatesScreen(),
    const CommunityScreen(),
    const CallsScreen(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
String get _title {
    switch (_selectedIndex) {
      case 0:
        return 'WhatsApp';
      case 1:
        return 'Updates';
      case 2:
        return 'Communities';
      case 3:
        return 'Calls';
      default:
        return '';
    }
  }
  List<Widget> _getActions(int index){
    switch (index) {
      case 0:
        return [
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ];
      case 1:
        return [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ];
      case 2:
        return [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ];
      case 3:
        return [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF25D366),
        title:  Text(_title),
        actions: _getActions(_selectedIndex),
       ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.update), label: 'Updates'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Communities'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Calls'),
        ],
        onDestinationSelected: _onDestinationSelected,
        selectedIndex: _selectedIndex,
        surfaceTintColor: const Color(0xFF25D366),
      ),
    );
  }
}
