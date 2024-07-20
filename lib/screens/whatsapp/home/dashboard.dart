import 'package:flutter/material.dart';
import 'package:movieboxclone/screens/whatsapp/home/photo.dart';
import 'package:movieboxclone/screens/whatsapp/home/video.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffe8e8e8),
      child: ListView(children: <Widget>[
        //Welcome and Balance Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: const BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.all(Radius.circular(3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset.zero,
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
//                  createInterstitialAd()
//                    ..load()
//                    ..show();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const Photos(),
                ));
              },
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Photo Status",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      )),
                  Text("Click here to view all photo status.",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white70,
                      )),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.all(Radius.circular(3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset.zero,
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
//                  createInterstitialAd()
//                    ..load()
//                    ..show();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const VideoListView(),
                ));
              },
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Videos Status",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      )),
                  Text("Click here to view all videos status.",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white70,
                      )),
                ],
              ),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.all(Radius.circular(3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset.zero,
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("File Manager > Downloaded Status ",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    )),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                    "All photos and videos will be saved in Downloaded Status Folder.",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white70,
                    )),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
