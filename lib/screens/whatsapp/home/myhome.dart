
import 'package:flutter/material.dart';
import 'package:movieboxclone/screens/whatsapp/home/dashboard.dart';
import 'package:movieboxclone/screens/whatsapp/home/drawer.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("downloand WhatsAppStatus"),
      ),
      body: const DashboardScreen(),
      drawer: const Drawer(
        child: MyNavigationDrawer(),
      ),
    );
  }
}
