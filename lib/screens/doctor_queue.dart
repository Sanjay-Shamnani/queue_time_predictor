import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:queue_time_predictor/constants/api_urls.dart';
import 'package:queue_time_predictor/constants/strings.dart';

class DoctorQueue extends StatefulWidget {
  @override
  _DoctorQueueState createState() => _DoctorQueueState();
}

class _DoctorQueueState extends State<DoctorQueue> {
  Map waitingTimeResponse;
  Map data;
  String url;
  ApiUrls _urls = ApiUrls();

  fetchDoctorData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(parameters);
    QuerySnapshot querySnapshot = await collectionReference.get();
    data = querySnapshot.docs[0].data();
    url = _urls.doctorPredictionUrl(data);
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
        FirebaseFirestore.instance.collection(parameters);
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs[0].reference.update(tempData);
  }

  @override
  void initState() {
    fetchDoctorData();
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
