import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yellow_class_assessment/color.dart';
import 'package:yellow_class_assessment/model/contact_model.dart';
import 'package:yellow_class_assessment/screens/home.dart';
import 'package:yellow_class_assessment/services/database.dart';
import 'package:yellow_class_assessment/typography.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({super.key});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  @override
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFEF6),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 140, 20, 36),
        child: Column(children: [
          Text(
            "Create New Contact",
            style: AppTypography.textMd
                .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Please fill up all inputs to create a new contact account.",
            textAlign: TextAlign.center,
            style: AppTypography.textSm.copyWith(fontSize: 14),
          ),
          const SizedBox(
            height: 40,
          ),
          Form(
            key: _formKey,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0, color: Color(0xFFFEC490)),
                    color: AppColors.signIn),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [
                    FieldsFormat(
                      text: _nameController,
                      title: "Name*",
                      maxlines: 1,
                    ),
                    FieldsFormat(
                      text: _userNameController,
                      title: "Username*",
                      maxlines: 1,
                    ),
                    FieldsFormat(
                      text: _emailController,
                      title: "E-mail* (preferably outlook id)",
                      maxlines: 1,
                    ),
                    FieldsFormat(
                      text: _phoneController,
                      title: "Phone Number*",
                      maxlines: 1,
                    ),
                    FieldsFormat(
                      text: _addressController,
                      title: "Add Address*",
                      maxlines: 2,
                    ),
                  ],
                )),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                DatabaseMethods service = DatabaseMethods();
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final User user = await _auth.currentUser!;
                Contact contact = Contact(
                    user_id: user.email!,
                    name: _nameController.text,
                    userName: _userNameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    address: _addressController.text);

                await service.addContact(contact);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffF57C51),
                      ),
                      child: Center(
                        child: Text("Add",
                            style: AppTypography.textMd.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class FieldsFormat extends StatefulWidget {
  final String title;
  final TextEditingController text;
  final int maxlines;
  FieldsFormat(
      {Key? key,
      required this.title,
      required this.text,
      required this.maxlines})
      : super(key: key);

  @override
  _FieldsFormatState createState() => _FieldsFormatState();
}

class _FieldsFormatState extends State<FieldsFormat> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: AppTypography.textSm.copyWith(fontSize: 14),
      ),
      const SizedBox(
        height: 4,
      ),
      SizedBox(
        height: widget.title == "Add Address*" ? 76 : 40,
        child: TextFormField(
            enabled: true,
            textAlign: TextAlign.start,
            maxLines: widget.maxlines,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        const BorderSide(width: 0, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        const BorderSide(width: 0, color: Colors.white))),
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ${widget.title}';
              }
              return null;
            },
            controller: widget.text),
      ),
      const SizedBox(
        height: 10,
      )
    ]);
  }
}
