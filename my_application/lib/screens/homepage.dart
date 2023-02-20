import 'package:flutter/material.dart';
import 'package:my_application/database/mydatabase.dart';
import 'package:my_application/screens/data_page.dart';

import '../api_services/api_serve.dart';
import '../models/prayer_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();
  TimingModel journel = TimingModel();
  bool isLoading = true;
  void refreshJournals() async {
    final data = await PrayerTimeDatabase.instance.getPrayerTime();
    setState(() {
      journel = data!;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshJournals();
    print("..number of items : ${journel.asr}");
  }

  // void _showForm(int? id) async {
  //   showModalBottomSheet(
  //       context: context,
  //       elevation: 5,
  //       isScrollControlled: true,
  //       builder: ((context) {
  //         return ListView.builder(
  //             itemCount: journel.asr!.length,
  //             itemBuilder: ((context, index) {
  //               return Card(
  //                 color: Colors.orange[200],
  //                 margin: EdgeInsets.all(15),
  //                 child: ListTile(
  //                   title: Text(
  //                     journel.asr.toString(),
  //                   ),
  //                   subtitle: Text(
  //                     journel.dhuhr.toString(),
  //                   ),
  //                 ),
  //               );
  //             }));
  //       }));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Prayer Times'),
      ),
      body: FutureBuilder(
        future: apiService.fetchPrayerTime(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TimingModel>> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  return Card(
                      child: ListTile(
                          title: Text(snapshot.data![index].fajr.toString())));
                }));
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     ElevatedButton(
      //       onPressed: (() {
      //         apiService.fetchPrayerTime(DateTime.now().toString());
      //       }),
      //       child: Text("Click me"),
      //     ),
      //     ElevatedButton(
      //       onPressed: (() {
      //         PrayerTimeDatabase.instance
      //             .getPrayerTime(DateTime.now().toString());
      //       }),
      //       child: Text("Show"),
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.green,
        hoverColor: Colors.orange,
        splashColor: Colors.purple,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => DataPage(
                        timingModel: journel,
                      ))));
          // _showForm(null);
        },
      ),
    );
  }
}
