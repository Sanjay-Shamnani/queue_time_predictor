import 'package:flutter/material.dart';
import 'package:queue_time_predictor/screens/qr_code_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Queue Time Predictor"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: _userNameController,
                onSubmitted: (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRCodeScreen(
                              userName: value,
                            ))),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  hintText: 'Enter Your Name',
                ),
              ),
            ),
            RaisedButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRCodeScreen(
                              userName: _userNameController.text,
                            )));
              },
            )
          ],
        ),
      ),
    );
  }
}
