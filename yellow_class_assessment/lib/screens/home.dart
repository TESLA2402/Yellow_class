import 'package:flutter/material.dart';
import 'package:yellow_class_assessment/screens/contacts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddContacts()));
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
          child: const Icon(
            Icons.android,
            color: Colors.white,
          ),
        ),
      ),
    ));
  }
}
