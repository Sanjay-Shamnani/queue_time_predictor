class ApiUrls {
  String doctorPredictionUrl(Map<dynamic, dynamic> data) {
    String url =
        'https://dbpqt9.herokuapp.com/predict_api/?mr3=${data['mr3']}&td=${data['td']}&ft=${data['ft']}&nq=${data['nq']}&dr=${data['dr']}';
    return url;
  }

  String xrayPredictionUrl(Map<dynamic, dynamic> data) {
    String url =
        'https://xraypqt9.herokuapp.com/predict_api/?nm=${data['nm']}&nq=${data['nq']}';
    return url;
  }

  String bloodtestPredictionUrl(Map<dynamic, dynamic> data, String ageGroup) {
    return "https://bloodtestpqt9.herokuapp.com/predict_api/?nm=${data['nm']}&nq=${data['nq']}&age=$ageGroup";
  }
}
