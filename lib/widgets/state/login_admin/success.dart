// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kontroller/view/login_user.dart';

import '../../../view/admin.dart';

class LoginAdminSuccess extends StatelessWidget {
  const LoginAdminSuccess({
    Key? key,
    required this.listData,
    required this.firestore,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>?> listData;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    final controllerMac = TextEditingController();

    showDialogCustom(String text) {
      AlertDialog alert = AlertDialog(
        title: const Text("Ada Yang Salah"),
        content: Text(text),
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    QueryDocumentSnapshot<Map<String, dynamic>>? dataMac;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login Admin",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/login.png',
              height: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            // inputan mac
            TextFormField(
              controller: controllerMac,
              onChanged: (v) {
                try {
                  for (var element in listData) {
                    if (element?.data()['value'] == controllerMac.text) {
                      dataMac = element;
                    }
                  }
                } catch (e) {
                  showDialogCustom("Ada Yang Salah");
                }
              },
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.person_alt_circle,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // button login
            ElevatedButton(
              onPressed: () async {
                if (dataMac?.data() == null) {
                  showDialogCustom("Mac Addres Tidak Terdaftar");
                } else {
                  bool isLogin = dataMac?['isLogin'] ?? false;
                  bool isActive = dataMac?['isActive'] ?? false;
                  bool isAdmin = dataMac?['isAdmin'] ?? false;
                  if (isActive) {
                    if (isAdmin) {
                      if (!isLogin) {
                        await firestore
                            .collection('mac')
                            .doc(dataMac!.id)
                            .update(
                          {
                            "isLogin": true,
                          },
                        );

                        final box = GetStorage();
                        box.write('isLogin', dataMac!.id);
                        box.write('isAdmin', isAdmin);
                        box.write('mac', dataMac!.data()['value']);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Admin(id: dataMac!.id)),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        showDialogCustom("Anda Sudah Login");
                      }
                    } else {
                      showDialogCustom("Akun ini Adalah User");
                    }
                  } else {
                    showDialogCustom("Mac Anda Sudah Tidak Aktif");
                  }
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text("Login"),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Divider(
              thickness: 1.4,
            ),
            TextButton(
                onPressed: () {
                  Get.to(
                    () => const LoginUser(),
                    transition: Transition.fadeIn,
                  );
                },
                child: const Text("To Login User")),
            const Divider(
              thickness: 1.4,
            ),
          ],
        ),
      ),
    );
  }
}
