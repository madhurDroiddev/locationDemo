import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlocationdemo/app_utils.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String address;
  Location location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Lib"),
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
    );
  }

  getLocation() {
    location = Location();

    location.hasPermission().then((value) {
      if (value != PermissionStatus.granted) {
        location.requestPermission().then((value) {
          if (value == PermissionStatus.granted) {
            checkServiceEnabled();
          }
        });
      } else {
        checkServiceEnabled();
      }
    });
  }

  void getCurrentLocation() {
    print("Fetching Location");
    location.getLocation().then((value) async {
      if (value != null) {
        Coordinates coordinates = Coordinates(value.latitude, value.longitude);
        address = await CommonUtils.getAddress(coordinates);
        setState(() {});
      }
    }).catchError((error) {
      print(error);
    });
  }

  void checkServiceEnabled() {
    if (Platform.isAndroid) {
      // For Android
      location.serviceEnabled().then((value) {
        if (value) {
          getCurrentLocation();
        } else {
          location.requestService().then((value) {
            if (value) {
              getCurrentLocation();
            }
          });
        }
      });
    } else {
      // For Ios
      getCurrentLocation();
    }
  }
}
