// ignore_for_file: prefer_conditional_assignment, prefer_const_constructors

import 'dart:async';
import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

///
///This is an [example] app for testing the [EasyGeofencing] dart package
///that is purely written in dart
///
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Geofencing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Easy Geofencing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  StreamSubscription<GeofenceStatus>? geofenceStatusStream;
  Geolocator geolocator = Geolocator();
  String geofenceStatus = '';
  bool isReady = false;
  Position? position;
  double? distance;
  bool isInRadius = false;

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("LOCATION => ${position!.latitude}");
    print("LOCATION => ${position!.longitude}");
    isReady = (position != null) ? true : false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Start"),
                  onPressed: () {
                    print("starting geoFencing Service");
                    EasyGeofencing.startGeofenceService(
                        pointedLatitude: "11.0322826",
                        pointedLongitude: "77.0189443",
                        radiusMeter: "100",
                        eventPeriodInSeconds: 20);
                    // if (geofenceStatusStream == null) {
                      // print("Distance ---------------- ${EasyGeofencing.distanceBetween(11.0176, 76.9674, position!.latitude, position!.longitude)}");
                      geofenceStatusStream = EasyGeofencing.getGeofenceStream()
                          ?.listen((GeofenceStatus status) {
                        print( "status tostring ---- ${status.toString()}");
                        setState(() {
                          geofenceStatus = status.toString();
                          distance = EasyGeofencing.distanceBetween(11.0322724, 77.0189615, position!.latitude, position!.longitude) * 1000;
                        });
                         print('total distance -----${distance}');
                        if(distance! <= 5.0){
                        setState(() {
                          isInRadius = true; 
                        });
                        print("IS in Radius ---- $isInRadius");
                      }else{
                        print('Not in radius');
                      }
                      });
                    }
                  // },
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  child: Text("Stop"),
                  onPressed: () {
                    // print("stop");
                    EasyGeofencing.stopGeofenceService();
                    geofenceStatusStream!.cancel();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              color: isInRadius ? Colors.green : Colors.red,
              height: 40,
              width: 40,
            ),
            Text(
              "Geofence Status: \n\n\n" + geofenceStatus,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}