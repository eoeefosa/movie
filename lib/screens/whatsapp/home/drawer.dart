
import 'package:flutter/material.dart';
import 'package:movieboxclone/screens/whatsapp/home/photo.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});
  final _menutextcolor = const TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );
  final _iconcolor = const IconThemeData(
    color: Color(0xff757575),
  );
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const UserAccountsDrawerHeader(
            accountName: Text("Welcome to Status Downloader"),
            accountEmail: Text("Easizly Download WhatsApp Status")),
        ListTile(
          leading: IconTheme(
            data: _iconcolor,
            child: const Icon(Icons.photo_library),
          ),
          title: Text(
            "WhatsApp Photo Status",
            style: _menutextcolor,
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const Photos(),
              ),
            );
          },
        )
      ],
    );
  }
}
