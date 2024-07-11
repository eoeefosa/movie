import 'package:flutter/material.dart';
import 'package:movieboxclone/screens/home/downloads/tabs/tab_download.dart';

class Downloads extends StatelessWidget {
  const Downloads({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: ListView(
        children: const [
          SizedBox(
            height: 50,
            width: 350,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabs: <Tab>[
                Tab(text: 'Downloads'),
                Tab(text: 'Local Videos'),
              ],
            ),
          ),
          SizedBox(
            height: 500,
            width: 350,
            child: TabBarView(
              children: [
                TabDownload(),
                Center(child: Text('Explorer context')),
              ],
            ),
          )
        ],
      )),
    );
  }
}
