
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/state/login_user/success.dart';
import '../widgets/state/error.dart';
import '../widgets/state/loading.dart';

class LoginUser extends StatelessWidget {
  const LoginUser({super.key});

  @override
  Widget build(BuildContext context) {
    // FirebaseDatabase database = FirebaseDatabase.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
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
                return LoginUserSuccess(listData: listData, firestore: firestore);
                // return Admin(listData: listData, firestore: firestore);
              } else {
                return const Text('Empty data');
              }
            }
            return Text('State: ${snapshot.connectionState}');
          },
        ),
      ),
    );
  }
}
