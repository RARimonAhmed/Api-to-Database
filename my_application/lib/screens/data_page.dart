import 'package:flutter/material.dart';
import 'package:my_application/api_services/api_serve.dart';

import '../database/mydatabase.dart';
import '../models/prayer_model.dart';

class DataPage extends StatefulWidget {
  final TimingModel timingModel;
  const DataPage({
    super.key,
    required this.timingModel,
  });

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  ApiService apiService = ApiService();
  // TimingModel journel = TimingModel();
  // bool isLoading = true;
  // void refreshJournals() async {
  //   final data = await PrayerTimeDatabase.instance.getPrayerTime();
  //   setState(() {
  //     journel = data!;
  //     isLoading = false;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   refreshJournals();
  //   print("..number of items : ${journel.asr}");
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiService.fetchPrayerTime(),
        builder: ((context, snapshot) {
          print("Asr is = " + snapshot.data![0].asr.toString());
          return ListView.builder(
              itemCount: 1,
              itemBuilder: ((context, index) {
                return Card(
                  color: Colors.orange[200],
                  margin: EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(widget.timingModel.asr.toString()),
                    subtitle: Text(widget.timingModel.dhuhr.toString()),
                  ),
                );
              }));
        }));
  }
}
