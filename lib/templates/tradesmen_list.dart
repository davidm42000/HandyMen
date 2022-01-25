import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handy_men/models/tradesman_model.dart';
import 'package:handy_men/screens/tradesman_edit_profile_page.dart';
import 'package:handy_men/screens/tradesman_profile_page.dart';
import 'package:handy_men/screens/view_tradesman_profile_page.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class TradesmenList extends StatefulWidget {
  final User user;
  final double distance;
  final String tradeType;
  const TradesmenList(
      {required this.distance,
      required this.tradeType,
      required this.user,
      Key? key})
      : super(key: key);

  @override
  _TradesmenListState createState() => _TradesmenListState();
}

class _TradesmenListState extends State<TradesmenList> {
  var _example = "2km";

  var location = new loc.Location();
  var _userLongitude;
  var _userLatitude;
  var _userCurrentAddress;
  var _distanceInMeters = 0.0;

  late double _distance;
  late String _tradeType;
  late User _currentUser;
  bool _error = false;

  @override
  void initState() {
    _distance = widget.distance;
    _tradeType = widget.tradeType;
    _currentUser = widget.user;
    super.initState();
    getLocation();
  }

  Stream<QuerySnapshot> getStream() {
    Stream<QuerySnapshot> tradesmanStream;
    if (_tradeType == 'All') {
      late Stream<QuerySnapshot> _tradesmanStream = FirebaseFirestore.instance
          .collection('tradesmen')
          .orderBy('location', descending: true)
          .snapshots();
      tradesmanStream = _tradesmanStream;
    } else {
      late Stream<QuerySnapshot> _tradesmanStream = FirebaseFirestore.instance
          .collection('tradesmen')
          .orderBy('location', descending: true)
          .where('trade', isEqualTo: _tradeType)
          .snapshots();
      tradesmanStream = _tradesmanStream;
    }
    return tradesmanStream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (_error == true) {
          return Text('errorrrrrrr');
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
              this._error = false;
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
                          child: Text('View Profile'),
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ViewTradesmanProfilePage(
                                      user: _currentUser,
                                      name: data['name'],
                                      email: data['email'],
                                    )));
                          }),
                    ),
                    trailing: Text("${_distanceInMeters} km"),
                  ),
                ),
              );
            } else {
              this._error = true;
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
