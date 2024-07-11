import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommerceDashboard extends StatelessWidget {
  const CommerceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
        title: const Text("Commerce"),
        leading: const Icon(Icons.logo_dev),
      ),
      body: ListView(
        children: const [
          TabBar(tabs: )
        ],
      ),
    );
  }
}
