// Flutter imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Package imports:
import 'package:flutter_support_chat/flutter_support_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'flutter_support_chat example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter_fb_news example"),
      ),
      body: StreamBuilder<User?>(
        builder: (BuildContext context, AsyncSnapshot<User?> s) {
          if (s.connectionState == ConnectionState.active) {
            if (s.hasData) {
              return StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final User user = snapshot.data!;
                      return FlutterSupportChat(
                        supporterIDs: [
                          'cedtegapps.de@gmail.com',
                        ],
                        currentID: user.email!,
                        firestoreInstance: FirebaseFirestore.instance,
                        onNewCaseText: 'New Support Case',
                        createCaseButtonText: "Create Support Case",
                        writeMessageText: "Write a Message",
                      );
                    }
                  }
                  return RefreshProgressIndicator();
                },
              );
            }
            return Login();
          }
          return RefreshProgressIndicator();
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
