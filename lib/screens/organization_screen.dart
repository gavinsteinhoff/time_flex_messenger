import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen(
      {Key? key, required QueryDocumentSnapshot<Object?> document})
      : _document = document,
        super(key: key);

  final QueryDocumentSnapshot<Object?> _document;

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  late QueryDocumentSnapshot<Object?> _document;
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    _document = widget._document;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(_document.get("name")),
          Text(_document.get("description")),
          ElevatedButton(
              onPressed: () {
                db.collection("users").doc(auth.currentUser?.uid).update({
                  "subscriptions": FieldValue.arrayUnion([_document.id])
                });
              },
              child: const Text("Subscribe"))
        ],
      ),
    )));
  }
}
