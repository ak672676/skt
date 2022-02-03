import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skt/model/tax.dart';
import 'package:skt/widget/navigation_drawer_widget.dart';

class TaxNotification extends StatefulWidget {
  const TaxNotification({Key? key}) : super(key: key);

  @override
  _TaxNotificationState createState() => _TaxNotificationState();
}

class _TaxNotificationState extends State<TaxNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tax Notification'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("taxes")
                  .where(
                    "endDate",
                    isLessThanOrEqualTo: DateTime.now()
                        .add(Duration(days: 35))
                        .millisecondsSinceEpoch,
                  )
                  .orderBy("endDate", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      Tax tax = Tax.fromJson(
                          (snapshot.data! as dynamic).docs[index].data());

                      return ListTile(
                        leading: GestureDetector(
                          onTap: () async {},
                          child: const Text(
                            "TAX",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          "${tax.startDate!.day}-${tax.startDate!.month}-${tax.startDate!.year}    -    ${tax.endDate!.day}-${tax.endDate!.month}-${tax.endDate!.year}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      drawer: NavigationDrawerWidget(),
    );
  }
}
