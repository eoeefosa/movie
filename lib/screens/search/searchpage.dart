import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Card(
          child: TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      if (name.isEmpty) {
                        return ListTile(
                          title: Text(
                            data['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['image']),
                          ),
                        );
                      }
                      if (data['name']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['image']),
                          ),
                        );
                      }
                      return Container();
                    });
          },
        ));
  }
}
