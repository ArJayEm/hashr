import 'package:flutter/material.dart';
import 'package:hashr/models/account.dart';

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

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setFields();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
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
                          icon: Icon(Icons.label, color: Colors.green),
                          labelText: 'Site or App Name',
                          hintText: 'Site or App Name...'),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      controller: _ctrlApporsitename,
                      onChanged: (value) {
                        setState(() {
                          _account.desciption = value;
                        });
                      },
                      onTap: () {
                        if ((_account.desciption!.isEmpty) ||
                            _account.desciption!.isEmpty) {
                          _ctrlApporsitename.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _ctrlApporsitename.text.length);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          icon: Icon(Icons.label, color: Colors.green),
                          labelText: 'Username',
                          hintText: 'Username...'),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      controller: _ctrlApporsitename,
                      onChanged: (value) {
                        setState(() {
                          _account.desciption = value;
                        });
                      },
                      onTap: () {
                        if (_account.desciption!.isEmpty) {
                          _ctrlApporsitename.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _ctrlApporsitename.text.length);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void _setFields() {
    setState(() {
      _account = widget.account;
      _ctrlApporsitename.text = _account.apporsitename ?? "";
      _ctrlDescription.text = _account.desciption ?? "";
      _ctrlHash.text = _account.hash ?? "";
      _ctrlUsername.text = _account.username ?? "";
    });
  }
}
