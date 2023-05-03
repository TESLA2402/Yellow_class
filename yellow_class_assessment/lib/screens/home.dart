import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yellow_class_assessment/color.dart';
import 'package:yellow_class_assessment/helper/authenticate.dart';
import 'package:yellow_class_assessment/model/contact_model.dart';
import 'package:yellow_class_assessment/screens/contacts.dart';
import 'package:yellow_class_assessment/services/auth.dart';
import 'package:yellow_class_assessment/services/database.dart';
import 'package:yellow_class_assessment/typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseMethods service = DatabaseMethods();
  Future<List<Contact>>? contacts;
  List<Contact>? reterivedcontacts;

  @override
  void initState() {
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = _auth.currentUser!;
    print(user.email);
    _initRetrieval(user.email);
  }

  Future<void> _initRetrieval(userID) async {
    contacts = service.retrieveContact(userID);
    reterivedcontacts = await service.retrieveContact(userID);
    print(reterivedcontacts);
  }

  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Contact');
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = _auth.currentUser!;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.signIn,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    await AuthService().signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authenticate()));
                  },
                  child: const Icon(
                    Icons.logout,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Contact')
                        .where('user_id', isEqualTo: user.email)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final contacts = snapshot.data!.docs;

                        return ListView.separated(
                            itemBuilder: (context, index) {
                              return Stack(children: [
                                ContactCard(
                                  name: contacts[index]['name'],
                                  phone: contacts[index]['phone'],
                                  address: contacts[index]['address'],
                                  email: contacts[index]['email'],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () async {
                                        DatabaseMethods service =
                                            DatabaseMethods();
                                        await service.deleteContact(snapshot
                                            .data.docs[index].reference.id);
                                        setState(() {});
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                              ]);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: snapshot.data!.docs.length);
                      } else {
                        return const Center(
                          child: Text("Add some new Contacts"),
                          //CircularProgressIndicator()
                        );
                      }
                    }),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddContacts()));
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}

class ContactCard extends StatefulWidget {
  String name;
  String email;
  String address;
  String phone;
  ContactCard(
      {super.key,
      required this.phone,
      required this.address,
      required this.email,
      required this.name});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppColors.signIn, borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.all(12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "● Name : ${widget.name}",
              style: AppTypography.textSm
                  .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            Text(
              "● Email : ${widget.email}",
              style: AppTypography.textSm
                  .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            Text(
              "● Contact No. : ${widget.phone}",
              style: AppTypography.textSm
                  .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            Text(
              "● Address : ${widget.address}",
              style: AppTypography.textSm
                  .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ]),
        )
      ],
    );
  }
}
