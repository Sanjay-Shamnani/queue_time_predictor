class ApiUrls {
  String doctorPredictionUrl(Map<dynamic, dynamic> data, int ft, docrate) {
    int td = 0;
    int currentTime = DateTime.now().hour;

    td = (currentTime > 16) ? 2 : 1;

    String url =
        'https://dbpqt9.herokuapp.com/predict_api/?mr3=${data['mr3']}&td=$td&ft=$ft&nq=${data['nq']}&dr=$docrate';
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

  String waitCreateUrl() {
    return "https://pqt9queuewaittime.herokuapp.com/wait-create/";
  }
}
