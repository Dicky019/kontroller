import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../button/button.dart';

class AdminSuccess extends StatelessWidget {
  const AdminSuccess({
    Key? key,
    required this.listData,
    required this.firestore,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> listData;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    final valueC = TextEditingController();
    final nameC = TextEditingController();

    // edit user
    Future<void> editData(BuildContext context, String id) async {
      // update mac

      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Data'),
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
              // edit mac
              ButtonOff(
                title: 'Edit',
                onPressed: () async {
                  await firestore.collection('mac').doc(id).update(
                    {
                      "value": valueC.text,
                      "nama": nameC.text,
                    },
                  );
                  valueC.clear();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              ),
              // button Cancel
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

    // pilihan ke edit atau hapus
    Future<void> choised(BuildContext context, String id, String value,String nama) async {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Choise')),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // button to update
                ButtonOff(
                  title: 'Edit Data',
                  onPressed: () {
                    Navigator.pop(context);
                    valueC.text = value;
                    nameC.text = nama;
                    editData(context, id);
                  },
                ),
                // button delete
                ButtonOff(
                  title: 'Delete Data',
                  onPressed: () async {
                    await firestore.collection('mac').doc(id).delete();
                    valueC.clear();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    var listDataUser = listData
        .where((element) => element.data()['isAdmin'] == false)
        .toList();

    var c = Get.put(MyController());

    return ListView.builder(
      itemCount: listDataUser.length,
      itemBuilder: (context, index) {
        var data = listDataUser[index];
        return Column(
          children: [
            if (index == 0)
              // tombol matikan semua
              ListTile(
                title: const Text(
                  "Matikan Semua",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Obx(
                  () => Checkbox(
                    activeColor: Colors.lightBlue[300],
                    value: c.matikanSemua.value,
                    onChanged: (value) async {
                      c.matikanSemua.value = value ?? true;
                      // ignore: avoid_function_literals_in_foreach_calls
                      listDataUser.forEach((element) async {
                        await firestore
                            .collection('mac')
                            .doc(element.id)
                            .update(
                          {
                            'isActive': false,
                          },
                        );
                      });
                    },
                  ),
                ),
              ),
            // tombol matikan salah satu
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.lightBlue[300],
                child: const Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                ),
              ),
              onTap: () async =>
                  await choised(context, data.id, data.data()['value'],data.data()['nama']),
              trailing: Checkbox(
                activeColor: Colors.lightBlue[300],
                value: data.data()['isActive'],
                onChanged: (value) async {
                  c.matikanSemua.value = false;
                  // ignore: avoid_function_literals_in_foreach_calls
                  listDataUser.forEach((element) async {
                    await firestore.collection('mac').doc(element.id).update(
                      {
                        'isActive': false,
                      },
                    );
                  });
                  await firestore.collection('mac').doc(data.id).update(
                    {
                      'isActive': true,
                    },
                  );
                },
              ),
              title: Text(
                data.data()['nama'],
              ),
              subtitle: Text(
                data.data()['value'],
              ),
            ),
          ],
        );
      },
    );
  }
}

class MyController extends GetxController {
  var matikanSemua = false.obs;
}
