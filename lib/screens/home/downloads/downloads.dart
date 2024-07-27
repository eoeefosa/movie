import 'package:flutter/material.dart';
import 'package:torihd/screens/home/downloads/tabs/tab_download.dart';

class Downloads extends StatelessWidget {
  const Downloads({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
      ),
      body: const TabDownload(),
    );
  }
}
