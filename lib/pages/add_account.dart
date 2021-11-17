import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hashr/models/account.dart';
import '/helpers/extensions/format_extension.dart';
import '/helpers/extensions/security.dart';

Future<bool?> showAddRecord(context, data) async {
  return await showModalBottomSheet<bool?>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return AddAcount(data);
    },
  );
}

class AddAcount extends StatefulWidget {
  final Account account;

  // ignore: use_key_in_widget_constructors
  const AddAcount(this.account);

  @override
  State<StatefulWidget> createState() {
    return _AddAcountState();
  }
}

class _AddAcountState extends State<AddAcount> {
  Account _account = Account(apporsitename: "", username: "");
  final _ctrlApporsitename = TextEditingController();
  final _ctrlDescription = TextEditingController();
  final _ctrlHash = TextEditingController();
  final _ctrlUsername = TextEditingController();
  final _ctrlPassword = TextEditingController();

  final FocusNode _focusPassword = FocusNode();

  final _formKey = GlobalKey<FormState>();
  String? _password;
  bool _obscureText = true;
  bool _isLoading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _setFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_isEdit ? "Edit" : "Add"} Account"),
        actions: [
          TextButton(
            child: const Icon(Icons.done, size: 30, color: Colors.white),
            onPressed: _saveRecord,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            icon: Icon(Icons.app_registration,
                                color: Colors.green),
                            labelText: 'Site or App Name',
                            hintText: 'Site or App Name...'),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        controller: _ctrlApporsitename,
                        onChanged: (value) {
                          setState(() {
                            _account.apporsitename = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "0") {
                            return 'Site or App Name required.';
                          }
                          return null;
                        },
                        onTap: () {
                          // if ((_account.apporsitename.isNullOrEmpty())) {
                          //   _ctrlApporsitename.selection = TextSelection(
                          //       baseOffset: 0,
                          //       extentOffset: _ctrlApporsitename.text.length);
                          // }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            icon: Icon(Icons.person, color: Colors.green),
                            labelText: 'Username',
                            hintText: 'Username...'),
                        keyboardType: TextInputType.name,
                        //textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        controller: _ctrlUsername,
                        onChanged: (value) {
                          setState(() {
                            _account.username = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "0") {
                            return 'Username required.';
                          }
                          return null;
                        },
                        onTap: () {
                          // if (_account.username.isNullOrEmpty()) {
                          //   _ctrlUsername.selection = TextSelection(
                          //       baseOffset: 0,
                          //       extentOffset: _ctrlUsername.text.length);
                          // }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          icon: const Icon(Icons.password, color: Colors.green),
                          labelText: 'Password',
                          hintText: 'Password...',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        focusNode: _focusPassword,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        controller: _ctrlPassword,
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "0") {
                            return 'Password required.';
                          }
                          return null;
                        },
                        onTap: () {
                          // if (_password.isNullOrEmpty()) {
                          //   _ctrlPassword.selection = TextSelection(
                          //       baseOffset: 0,
                          //       extentOffset: _ctrlPassword.text.length);
                          // }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _setFields() {
    setState(() {
      _account = widget.account;
      _isEdit = !_account.id.isNullOrEmpty();
      _ctrlApporsitename.text = _account.apporsitename ?? "";
      _ctrlDescription.text = _account.desciption ?? "";
      _ctrlHash.text = _account.hash ?? "";
      _ctrlUsername.text = _account.username ?? "";
      _focusPassword.requestFocus();
    });
  }

  void _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_account.salt!.isNullOrEmpty()) {
          Fluttertoast.showToast(msg: "Generating salt...");
          Random _random = Random.secure();
          var values = List<int>.generate(32, (i) => _random.nextInt(256));
          _account.salt = base64Url.encode(values); //generateBase64Salt();
        }
        _account.hash.generateHash(_account.salt!, _password!);
      });
      _showProgressUi("Saving...");

      CollectionReference list =
          FirebaseFirestore.instance.collection("accounts");
      if (_account.id.isNullOrEmpty()) {
        var data = _account.toJson();
        list.add(data).then((value) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values);
          _showProgressUi("Account saved.");
          Navigator.pop(context);
        }).catchError((error) {
          _showProgressUi("Failed to add account: $error.");
        });
      } else {
        _account.modifiedOn = DateTime.now();
        list.doc(_account.id).update(_account.toJson()).then((value) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values);
          Navigator.pop(context);
          _showProgressUi("Account updated.");
        }).catchError((error) {
          _showProgressUi("Failed to update Account: $error.");
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Please fill required fields.");
    }
  }

  _showProgressUi(String msg) {
    Fluttertoast.showToast(msg: msg);
    setState(() => _isLoading = !_isLoading);
  }
}
