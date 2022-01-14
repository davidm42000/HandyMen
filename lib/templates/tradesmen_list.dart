import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/templates/tradesman_tile.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class TradesmenList extends StatefulWidget {
  final double distance;
  const TradesmenList({required this.distance, Key? key}) : super(key: key);

  @override
  _TradesmenListState createState() => _TradesmenListState();
}

class _TradesmenListState extends State<TradesmenList> {
  final Stream<QuerySnapshot> _tradesmanStream = FirebaseFirestore.instance
      .collection('tradesmen')
      .orderBy('location', descending: true)
      .snapshots();
  var _example = "2km";

  var location = new loc.Location();
  var _userLongitude;
  var _userLatitude;
  var _userCurrentAddress;
  var _distanceInMeters = 0.0;

  late double _distance;

  @override
  void initState() {
    _distance = widget.distance;
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    // final tradesmen = Provider.of<List<Tradesman>>(context);

    // tradesmen.forEach((tradesman) {
    //   print(tradesman.name);
    // });

    // return ListView.builder(
    //   itemCount: tradesmen.length,
    //   itemBuilder: (context, index) {
    //     return TradesmanTile(tradesman: tradesmen[index]);
    //   },
    // );

    return StreamBuilder<QuerySnapshot>(
      stream: _tradesmanStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            var _tradesmanLatitude = data['location'].latitude;
            var _tradesmanLongitude = data['location'].longitude;
            if (_userLatitude == null) {
              getLocation();
            } else {
              _distanceInMeters = Geolocator.distanceBetween(_tradesmanLatitude,
                  _tradesmanLongitude, _userLatitude, _userLongitude);
              _distanceInMeters = _distanceInMeters / 1000;
              _distanceInMeters = roundDouble(_distanceInMeters, 2);
            }
            print("Tradesman latitude: ${_tradesmanLatitude}");
            print("Tradesman longitude: ${_tradesmanLongitude}");
            print("Users latitude: ${_userLatitude}");
            print("Users longitude: ${_userLongitude}");
            if (_distanceInMeters < _distance) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Card(
                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.orange,
                    ),
                    title: Text(data['name']),
                    subtitle: SizedBox(
                      height: 30.0,
                      child: TextButton(
                          child: Text('View Profile'), onPressed: () async {}),
                    ),
                    trailing: Text("${_distanceInMeters} km"),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 8.0),
              );
            }
          }).toList(),
        );
      },
    );
  }

  getLocation() async {
    var _currentLocation = await location.getLocation();
    print(_currentLocation.longitude);
    double _lat = _currentLocation.latitude as double;
    double _long = _currentLocation.longitude as double;
    List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _long);
    Placemark place = placemarks[0];
    setState(() {
      _userLongitude = _currentLocation.longitude;
      _userLatitude = _currentLocation.latitude;
      _userCurrentAddress =
          "${place.locality}, ${place.name}, ${place.postalCode}, ${place.country}}";
    });
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places) as double;
    return ((value * mod).round().toDouble() / mod);
  }
}
