import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:queue_time_predictor/screens/queue_screen.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String _qrData = "";

  scanQRcode() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancel", true, ScanMode.QR)
        .then((value) {
      setState(() {
        _qrData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Queue Time Predictor"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 250,
              height: 45,
              child: FlatButton(
                child: Text("SCAN QR CODE"),
                onPressed: () {
                  scanQRcode();
                  switch (_qrData) {
                    case "doctor":
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  QueueScreen(queueType: _qrData,)));
                      break;
                    case "bloodtest":
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  QueueScreen(queueType: _qrData,)));
                      break;
                    case "x-ray":
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  QueueScreen(queueType: _qrData,)));
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
