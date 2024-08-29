import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:torihd/models/appState/app_state_manager.dart';
import 'package:torihd/screens/home/dashboard.dart';
import 'package:torihd/screens/downloads/downloads.dart';
import 'package:torihd/screens/home/me.dart';
import 'package:provider/provider.dart';

import '../../provider/movieprovider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.currentTab});

  final int currentTab;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> pages = <Widget>[
    const Dashboard(),
    const Downloads(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.currentTab,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
        currentIndex: widget.currentTab,
        onTap: (index) {
          Provider.of<AppStateManager>(context, listen: false).goToTab(index);
          Provider.of<MovieProvider>(context, listen: false).loadFiles();
          context.goNamed('home', pathParameters: {
            'tab': '$index',
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.download), label: "Downloads"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
