// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/mac_model.dart';
import '../widgets/button/button.dart';
import '../widgets/state/admin/success.dart';
import '../widgets/state/loading.dart';
import '../widgets/state/error.dart';
import 'login_admin.dart';

class Admin extends StatefulWidget {
  final String id;
  const Admin({super.key, required this.id});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
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
    // FirebaseDatabase database = FirebaseDatabase.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final valueC = TextEditingController();
    final nameC = TextEditingController();

    // add data user
    Future<void> addData(BuildContext context) async {
      // inputan mac

      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Data'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameC,
                  decoration: const InputDecoration(hintText: "Nama"),
                ),
                TextField(
                  controller: valueC,
                  decoration: const InputDecoration(hintText: "mac"),
                ),
              ],
            ),
            actions: <Widget>[
              // button add
              ButtonOff(
                title: 'Add',
                onPressed: () async {
                  await firestore.collection('mac').add(
                        MacUsers(
                          id: "",
                          isLogin: false,
                          isAdmin: false,
                          isActive: false,
                          value: valueC.text,
                          nama: nameC.text,
                        ).toJson(),
                      );
                  valueC.clear();
                  Navigator.pop(context);
                },
              ),
              ButtonOff(
                title: 'Cancel',
                onPressed: () {
                  valueC.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        // leading:
        backgroundColor: Colors.lightBlue[300],
        title: const Text("Admin"),
        centerTitle: true,
        actions: [
          // logout admin
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
                'isAdmin',
              );
              box.remove(
                'mac',
              );
              await FirebaseMessaging.instance
                  .unsubscribeFromTopic(box.read("nama"));
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginAdmin(),
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
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore.collection('mac').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Error();
              } else if (snapshot.hasData) {
                var listData = snapshot.data!.docs;
                return AdminSuccess(listData: listData, firestore: firestore);
              } else {
                return const Text('Empty data');
              }
            }
            return Text('State: ${snapshot.connectionState}');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue[300],
          onPressed: () {
            addData(context);
          },
          child: const Icon(Icons.add)),
    );
  }
}
