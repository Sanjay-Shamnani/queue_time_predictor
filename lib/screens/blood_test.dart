import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:queue_time_predictor/services/api_urls.dart';
import 'package:queue_time_predictor/constants/strings.dart';

class BloodTestQueue extends StatefulWidget {
  @override
  _BloodTestQueueState createState() => _BloodTestQueueState();
}

class _BloodTestQueueState extends State<BloodTestQueue> {
  Map waitingTimeResponse;
  Map data;
  String url;
  ApiUrls _urls = ApiUrls();
  TextEditingController _ageGroup = TextEditingController();
  bool _isLoading = false;

  fetehBloodTestParameters(int ageGroup) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(bloodtestparameters);
    QuerySnapshot querySnapshot = await collectionReference.get();
    data = querySnapshot.docs[0].data();
    url = _urls.bloodtestPredictionUrl(data, ageGroup);
    fetchWaitingTime(url);
  }

  fetchWaitingTime(String url) async {
    http.Response response = await http.get(url);
    waitingTimeResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        waitingTimeResponse = json.decode(response.body);
      });
    }
    incrementNQ();
  }

  incrementNQ() async {
    Map tempData = data;
    tempData['nq'] = data['nq'] + 1;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(bloodtestparameters);
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs[0].reference.update(tempData);
    setState(() {
      _isLoading = false;
    });

    sendWaitingTime();
  }

  sendWaitingTime() async {
    print("object");
    String url = ApiUrls().waitCreateUrl();
    print(url);
    final reponse = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"waiting": waitingTimeResponse["prediction"]}));
    print(reponse.statusCode);
    if (reponse.statusCode == 200) {
      print("waiting Time sent successfully");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Queue Time Predictor"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: _ageGroup,
                  onSubmitted: (value) {
                    int age = int.parse(value);
                    setState(() {
                      _isLoading = true;
                      _ageGroup.clear();
                    });
                    if (age > 0 && age <= 12) fetehBloodTestParameters(0);
                    if (age > 12 && age <= 50)
                      fetehBloodTestParameters(1);
                    else
                      fetehBloodTestParameters(2);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Age',
                    hintText: 'Enter Your Age',
                  ),
                ),
              ),
              (_isLoading)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: (waitingTimeResponse == null)
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Your Expected Waiting Time:",
                                    style: TextStyle(
                                      fontSize: 25,
                                    )),
                                Text(
                                  waitingTimeResponse["prediction"].toString(),
                                  style: TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("Minutes",
                                    style: TextStyle(
                                      fontSize: 25,
                                    )),
                              ],
                            ),
                    ),
            ],
          ),
        ));
  }
}
