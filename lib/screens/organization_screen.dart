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
  Future<DocumentSnapshot<Map<String, dynamic>>> _userFuture = FirebaseFirestore
      .instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get();

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
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _userFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const SizedBox.shrink();
                }
                print(snapshot.data?.get("subscriptions"));
                if (snapshot.data
                    ?.get("subscriptions")
                    .contains(_document.id)) {
                  return ElevatedButton(
                      onPressed: () => subscribeButton(snapshot.data),
                      child: const Text("Unsubscribe"));
                } else {
                  return ElevatedButton(
                      onPressed: () => subscribeButton(snapshot.data),
                      child: const Text("Subscribe"));
                }
              })
        ],
      ),
    )));
  }

  void subscribeButton(DocumentSnapshot<Map<String, dynamic>>? user) {
    if (user == null) return;
    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid);

    if (user.get("subscriptions").contains(_document.id)) {
      userDoc.update({
        "subscriptions": FieldValue.arrayRemove([_document.id])
      });
      setState(() {
        _userFuture = FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
      });
    } else {
      userDoc.update({
        "subscriptions": FieldValue.arrayUnion([_document.id])
      });
      setState(() {
        _userFuture = FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
      });
    }
  }
}
