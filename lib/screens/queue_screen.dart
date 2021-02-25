import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:queue_time_predictor/constants/api_urls.dart';
import 'package:queue_time_predictor/constants/strings.dart';

class QueueScreen extends StatefulWidget {
  final String queueType;

  QueueScreen({this.queueType});

  @override
  _QueueScreenState createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  Map waitingTimeResponse;
  Map data;
  String url;
  ApiUrls _urls = ApiUrls();

  @override
  void initState() {
    switch (widget.queueType) {
      case "doctor":
        print(widget.queueType);
        fetchDoctorData();
        break;
      case "x-ray":
        print(widget.queueType);
        fetchXrayData();
        break;
      default:
        fetchDoctorData();
    }
    super.initState();
  }

  fetchXrayData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(xrayparameters);
    QuerySnapshot querySnapshot = await collectionReference.get();
    data = querySnapshot.docs[0].data();
    url = _urls.xrayPredictionUrl(data);
    print(url);
    fetchWaitingTime(url);
  }

  fetchDoctorData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(parameters);
    QuerySnapshot querySnapshot = await collectionReference.get();
    data = querySnapshot.docs[0].data();
    url = _urls.doctorPredictionUrl(data);
    print(url);
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
    String qType;
    if (widget.queueType == "doctor")
      qType = parameters;
    else
      qType = xrayparameters;

    print(qType);
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(qType);
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs[0].reference.update(tempData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Queue Time Predictor"),
      ),
      body: Center(
        child: (waitingTimeResponse == null)
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your Expected Waiting Time:",
                      style: TextStyle(
                        fontSize: 25,
                      )),
                  Text(
                    waitingTimeResponse["prediction"]
                        .toString()
                        .substring(0, 2),
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  Text("Minutes",
                      style: TextStyle(
                        fontSize: 25,
                      )),
                ],
              ),
      ),
    );
  }
}
