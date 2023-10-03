import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_flex_messenger/screens/organizations_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  final searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    onSaved: (newValue) => searchString,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                          onPressed: () {
                            final currentState = _formKey.currentState;
                            if (currentState == null) {
                              return;
                            }

                            if (currentState.validate()) {
                              currentState.save();
                              var orgs = db
                                  .collection("organizations")
                                  .orderBy("name")
                                  .startAt([searchString]).endAt(
                                      ["$searchString\uf8ff"]).limit(5);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => OrganizationsScreen(
                                    stream: orgs.snapshots(),
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text("Submit"))),
                ],
              ))),
    );
  }
}
