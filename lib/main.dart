import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterlocationdemo/SecondScreen.dart';
import 'package:flutterlocationdemo/app_utils.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Geolocator geolocator;
  Position position;
  String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GeoLocator Lib"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              '$address',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            FlatButton(
              onPressed: () => getLocation(),
              color: Colors.blue,
              child: Text(
                'Get Location',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (buildContext) => SecondScreen()));
        },
        tooltip: 'Next Page',
        child: Icon(Icons.arrow_forward_ios),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getLocation() {
    geolocator = Geolocator();

    print("Clicked");

    if (Platform.isAndroid) {
      // For Android
      geolocator.isLocationServiceEnabled().then((value) {
        print(value);
        if (value) {
          // Service enabled
          getCurrentLocation();
        }
      });
    } else {
      // For IOs
      getCurrentLocation();
    }
  }

  void getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
        .then((value) async {
      print(value);
      if (value != null) {
        position = value;
        print(position.toJson());
        Coordinates coordinates =
            Coordinates(position.latitude, position.longitude);
        address = await CommonUtils.getAddress(coordinates);
        print(address);

        setState(() {});
      }
    }).catchError((error) {
      print(error);
    });
  }
}
