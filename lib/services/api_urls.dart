import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiUrls {
  String doctorPredictionUrl(Map<dynamic, dynamic> data, int ft, docrate) {
    String url =
        'https://dbpqt9.herokuapp.com/predict_api/?mr3=${data['mr3']}&td=${data['td']}&ft=$ft&nq=${data['nq']}&dr=$docrate';
    print(url);
    return url;
  }

  String xrayPredictionUrl(Map<dynamic, dynamic> data) {
    String url =
        'https://xraypqt9.herokuapp.com/predict_api/?nm=${data['nm']}&nq=${data['nq']}';
    return url;
  }

  String bloodtestPredictionUrl(Map<dynamic, dynamic> data, int ageGroup) {
    return "https://bloodtestpqt9.herokuapp.com/predict_api/?nm=${data['nm']}&nq=${data['nq']}&age=$ageGroup";
  }

  String userUrl(String userName) {
    return "https://pqt9queuewaittime.herokuapp.com/usr-detail/$userName/";
  }
}