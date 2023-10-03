import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_flex_messenger/screens/organization_screen.dart';

class OrganizationsScreen extends StatefulWidget {
  const OrganizationsScreen(
      {Key? key, required Stream<QuerySnapshot<Object?>> stream})
      : _stream = stream,
        super(key: key);

  final Stream<QuerySnapshot<Object?>> _stream;

  @override
  State<OrganizationsScreen> createState() => _OrganizationsScreenState();
}

class _OrganizationsScreenState extends State<OrganizationsScreen> {
  late Stream<QuerySnapshot<Object?>> _stream;

  @override
  void initState() {
    _stream = widget._stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data?.docs[index];
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                          child: ElevatedButton(
                              onPressed: () {
                                if (data != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => OrganizationScreen(
                                        document: data,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(data?.get("name"))));
                    },
                  );
                })));
  }
}
