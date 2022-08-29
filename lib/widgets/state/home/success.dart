import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../button/button.dart';
import '../error.dart';
import '../../text/text_suhu.dart';

class HomeSucess extends StatelessWidget {
  const HomeSucess({
    Key? key,
    required this.data,
    required this.starCountRef,
    required this.id,
  }) : super(key: key);

  final Map data;
  final String id;
  final DatabaseReference starCountRef;

  @override
  Widget build(BuildContext context) {
    Future updateData(String key, bool isOn) async {
      await FirebaseDatabase.instance.ref().update({key: isOn});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Hy User",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        // tampilan mac user yang terhubung
        Center(
          child: Text(
            "Mac $id",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // tampilan temperatur
            TextSuhu(
              dataSuhu: "${data['Temperatur_fan']['value']} °C",
              title: 'Temperatur',
            ),
            // tampilan Humidity
            TextSuhu(
              dataSuhu: "${data['Humidity_lampu']['value']} %",
              title: 'Humidity',
            ),
          ],
        ),
        const Divider(thickness: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // tombol kipas
            SwitchCostum(
              value: data['Temperatur_fan_isOn'],
              onChanged: data['isClick']
                  ? (value) async {
                      await updateData(
                        'Temperatur_fan_isOn',
                        value,
                      );
                    }
                  : null,
              title: 'Fan',
            ),
            // tombol lampu
            SwitchCostum(
              value: data['Humidity_lampu_isOn'],
              onChanged: data['isClick']
                  ? (value) async {
                      await updateData(
                        'Humidity_lampu_isOn',
                        value,
                      );
                    }
                  : null,
              title: 'Lampu',
            ),
          ],
        ),
        const Divider(thickness: 2),
        Center(
          child: data['isClick']
              ? 
              // tombol manual
              ButtonOn(
                  title: 'Manual',
                  onPressed: () async {
                    starCountRef.update({'isClick': !data['isClick']});
                  },
                )
              : 
              // tombol otomatis
              ButtonOff(
                  title: 'Otomatis',
                  onPressed: () async {
                    starCountRef.update({'isClick': !data['isClick']});
                  },
                ),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}
