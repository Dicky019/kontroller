import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'login_user.dart';
import 'package:get_storage/get_storage.dart';

import '../widgets/state/home/success.dart';
import '../widgets/state/error.dart';
import '../widgets/state/loading.dart';

// ignore_for_file: use_build_context_synchronously
class Home extends StatefulWidget {
  final String id, mac;
  const Home({super.key, required this.id, required this.mac});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    get();
    FirebaseMessaging.onMessage.listen((message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification?.body ?? "kosong"}');
        String title = message.notification?.title ?? "Notif";
        String body = message.notification?.body ?? "kosong";
        Get.snackbar(title, body);
      }
    });
    super.initState();
  }

  Future get() async {
    final box = GetStorage();
    log(box.read("nama"));
    await FirebaseMessaging.instance.subscribeToTopic(box.read("nama"));
  }

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference starCountRef = database.ref();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        // leading:
        backgroundColor: Colors.lightBlue[300],
        title: const Text("Kontroler"),
        centerTitle: true,
        actions: [
          // logout user
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () async {
              await firestore.collection('mac').doc(widget.id).update(
                {
                  "isLogin": false,
                },
              );
              var box = GetStorage();
              box.remove(
                'isLogin',
              );
              box.remove(
                'mac',
              );
              await FirebaseMessaging.instance
                  .unsubscribeFromTopic(box.read("nama"));
              await database.ref("/login").set("");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginUser(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<DatabaseEvent>(
          stream: starCountRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Error();
              } else if (snapshot.hasData) {
                var data = snapshot.data?.snapshot.value as Map;
                return HomeSucess(
                  data: data,
                  mac: widget.mac,
                  starCountRef: starCountRef,
                  id: widget.mac,
                );
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}
