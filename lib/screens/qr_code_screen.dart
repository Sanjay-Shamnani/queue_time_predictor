import 'package:flutter/material.dart';
import 'package:queue_time_predictor/screens/blood_test.dart';
import 'package:queue_time_predictor/screens/doctor_queue.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:queue_time_predictor/screens/xray_queue.dart';

class QRCodeScreen extends StatefulWidget {
  final String userName;

  QRCodeScreen({this.userName});
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String _qrData;

  scanQRcode() async {
    _qrData = await scanner.scan();
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
            Container(
              child: Column(
                children: [
                  Text(
                    'Welcome, ${widget.userName}',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Scan QR Code Here!!!',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Container(
              width: 250,
              height: 45,
              child: FlatButton(
                child: Text("SCAN QR CODE"),
                onPressed: () {
                  scanQRcode();
                  switch (_qrData) {
                    case "doctor":
                    _qrData = '';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DoctorQueue()));
                      break;
                    case "bloodtest":
                    _qrData = '';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BloodTestQueue()));
                      break;
                    case "x-ray":
                    _qrData = '';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => XrayQueue()));
                      break;
                    default:
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Invalid QR Code"),
                          content: Text("Please Scan Again."),
                          actions: <Widget>[
                            FlatButton(
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Scan Again"),
                            ),
                          ],
                        ),
                      );
                  }
                },
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
