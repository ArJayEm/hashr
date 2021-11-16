// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:global_configuration/global_configuration.dart';
import 'package:hashr/helpers/extensions/format_extension.dart';
import 'package:hashr/pages/add_account.dart';

import 'models/account.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  // ));
  await Firebase.initializeApp();
  await GlobalConfiguration().loadFromAsset("app_settings");

  runApp(
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => User()),
    //     ChangeNotifierProvider(create: (_) => GoogleProvider()),
    //   ],
    //   child: MyApp(),
    // ),
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
        const Locale('fr'),
        const Locale('es'),
        const Locale('de'),
        const Locale('ru'),
        const Locale('ja'),
        const Locale('ar'),
        const Locale('fa'),
        const Locale("es"),
      ],
      title: 'Hashr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Hashr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: prefer_final_fields
  Account _account = Account(apporsitename: "", username: "");

  //List<dynamic> _accounts = [];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
              actions: <Widget>[
                PopupMenuButton<int>(
                  onSelected: (item) => handleClick(item),
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                        value: 0, child: Text('Add account')),
                    const PopupMenuItem<int>(value: 1, child: Text('Logout')),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("accounts")
                    .orderBy('created_on', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    if (kDebugMode) {
                      print("list error: ${snapshot.error}");
                    }
                    return const Center(child: Text('Something went wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return snapshot.data!.docs.isEmpty
                      ? const Center(child: Text('No accounts yet.'))
                      : Card(
                          // child: RefreshIndicator(
                          //   onRefresh: _getStream(_userId),
                          //   child: ,
                          // ),
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map(
                              (DocumentSnapshot document) {
                                var data = document.data();
                                Account acc = Account.fromJson(
                                    data as Map<String, dynamic>);
                                //if (_bill.payerIds.toString().contains("$_userId")) {
                                acc.id = document.id;
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      //isThreeLine: true,
                                      leading: const CircleAvatar(),
                                      title: Text(acc.apporsitename!),
                                      //subtitle: Text('Created On: ${DateTime.fromMillisecondsSinceEpoch(data['created_on']).format()}'),
                                      subtitle: Text(acc.username!),
                                      //onTap: () {},
                                      trailing: SizedBox(
                                        width: 150,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons.visibility)),
                                            const Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddAcount(acc),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.green)),
                                            const Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  _delete(_account.id);
                                                },
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider()
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                        );
                },
              ),
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: _incrementCounter,
            //   tooltip: 'Increment',
            //   child: const Icon(Icons.add),
            // ), // This trailing comma makes auto-formatting nicer for build methods.
          );
  }

  void handleClick(int item) {
    printIfDebug(item);

    switch (item) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddAcount(_account),
          ),
        ); //.then(getAccounts);
        break;
      case 1:
        break;
    }
  }

  getAccounts(value) {
    _showProgressUi(true, "");
  }

  void printIfDebug(text) {
    if (kDebugMode) {
      print("print: $text");
    }
  }

  _showProgressUi(bool isLoading, String msg) {
    if (!msg.isNullOrEmpty()) {
      Fluttertoast.showToast(msg: msg);
    }
    setState(() => _isLoading = isLoading);
  }

  _delete(String? id) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
            'You are about to delete a record. This action is irreversible'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              _showProgressUi(true, "Deleting record...");
              try {
                String collection = widget.title.toLowerCase();

                FirebaseFirestore.instance
                    .collection(collection)
                    .doc(id)
                    .delete()
                    .then((_) {
                  _showProgressUi(false, "Record deleted");
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              } on FirebaseAuthException catch (e) {
                _showProgressUi(false, "${e.message}.");
              } catch (e) {
                _showProgressUi(false, "$e.");
              }
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
