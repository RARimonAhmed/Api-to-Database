import 'dart:convert';

import 'package:http/http.dart' as http;

import '../database/mydatabase.dart';
import '../models/prayer_model.dart';

class ApiService {
  List<TimingModel> prayerList = <TimingModel>[];

  Future<List<TimingModel>> fetchPrayerTime() async {
    var url =
        'https://api.aladhan.com/v1/calendarByAddress?address=Sultanahmet%20Mosque,%20Istanbul,%20Turkey&method=2&month=04&year=2017';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      print(response.statusCode);
      print(json);
      var list = json["data"] as List;
      print(list);
      List<TimingModel> produkte = list.map((i) =>
          TimingModel.fromJson(Map<String, dynamic>.from(i))).toList();


      for (int i = 0; i < list.length; i++) {
        var dayObject = list[i];
        print(dayObject.toString());
        var timeModelData = TimingModel.fromJson(dayObject["timings"]);
        print(timeModelData);

        prayerList.add(timeModelData);
      }
      await PrayerTimeDatabase.instance.create(prayerList);
      return prayerList;
    }
    else {
      return prayerList;
    }
  }
}