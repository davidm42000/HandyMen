import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class TradesmanEditLocationOnMap extends StatefulWidget {
  final User user;
  const TradesmanEditLocationOnMap({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _TradesmanEditLocationOnMapState createState() =>
      _TradesmanEditLocationOnMapState();
}

class _TradesmanEditLocationOnMapState
    extends State<TradesmanEditLocationOnMap> {
  CollectionReference tradesmen =
      FirebaseFirestore.instance.collection('tradesmen');

  Completer<GoogleMapController> _controller = Completer();

  Marker _setLoc = Marker(
    markerId: const MarkerId('setLoc'),
    infoWindow: const InfoWindow(title: 'Set Your Location'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    position: LatLng(53.2911, -6.3635),
  );

  static final CameraPosition _startLoc = CameraPosition(
    target: LatLng(53.2911, -6.3635),
    zoom: 14.4746,
  );

  var _kLake;

  late User _currentUser;

  var location = new loc.Location();
  var _longitude;
  var _latitude;
  var _currentAddress;

  @override
  void initState() {
    enableService();
    getLocation();
    super.initState();
    setMarker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //snackbar for showing errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        actions: [
          TextButton(
              onPressed: () {
                tradesmen.doc(widget.user.uid).update({
                  'location': new GeoPoint(
                      _setLoc.position.latitude, _setLoc.position.longitude),
                }).whenComplete(() {
                  showSnackBar(
                      'Location Set Successfully', Duration(seconds: 1));
                  Navigator.of(context).pop();
                });
              },
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600)),
              child: const Text('Set Location')),
          SizedBox(
            width: 24,
          ),
        ],
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _startLoc,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onLongPress: _addMarker,
        markers: {if (_setLoc != null) _setLoc},
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Your Location'),
        icon: Icon(Icons.center_focus_strong),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void _addMarker(LatLng pos) {
    setState(() {
      _setLoc = Marker(
        markerId: const MarkerId('setLoc'),
        infoWindow: const InfoWindow(title: 'Set Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      );
    });
  }

  void setMarker() {
    tradesmen
        .doc(widget.user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        GeoPoint g = documentSnapshot.get('location');
        var lat = g.latitude;
        var long = g.longitude;
        print('Document data: ${lat}, ${long}');
        setState(() {
          _setLoc = Marker(
            markerId: const MarkerId('setLoc'),
            infoWindow: const InfoWindow(title: 'Set Location'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: LatLng(lat, long),
          );
        });
      } else {
        print('Document does not exist on the database');

        setState(() {
          _setLoc = Marker(
            markerId: const MarkerId('setLoc'),
            infoWindow: const InfoWindow(title: 'Set Location'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: LatLng(53.2911, -6.3635),
          );
        });
      }
    });
  }

  enableService() async {
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
  }

  getLocation() async {
    var _currentLocation = await location.getLocation();
    print(_currentLocation.longitude);
    double _lat = _currentLocation.latitude as double;
    double _long = _currentLocation.longitude as double;
    List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _long);
    Placemark place = placemarks[0];
    setState(() {
      _longitude = _currentLocation.longitude;
      _latitude = _currentLocation.latitude;
      _currentAddress =
          "${place.locality}, ${place.name}, ${place.postalCode}, ${place.country}}";
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(_latitude, _longitude),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414);
    });
  }
}
