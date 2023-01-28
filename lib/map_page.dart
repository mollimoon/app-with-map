import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location location = Location();
  late GoogleMapController _mapController;
  final Completer<GoogleMapController> _controller = Completer();

  static const _defaultPosition = LatLng(35.41, 139.41);
  LatLng? _currentPosition;
  LatLng get currentPosition => _currentPosition ?? _defaultPosition;

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId(_defaultPosition.toString()),
      position: _defaultPosition,
    )
  };

  void _onMapCreated(GoogleMapController mapController) {
    _controller.complete(mapController);
    _mapController = mapController;
  }

  _checkLocationPermission() async {
    bool locationServiceEnabled = await location.serviceEnabled();
    if (!locationServiceEnabled) {
      locationServiceEnabled = await location.requestService();
      if (!locationServiceEnabled) {
        return;
      }
    }

    PermissionStatus locationForAppStatus = await location.hasPermission();
    if (locationForAppStatus == PermissionStatus.denied) {
      await location.requestPermission();
      locationForAppStatus = await location.hasPermission();
      if (locationForAppStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map page"),
      ),
      body: GoogleMap(
        onTap: (position) {
          _currentPosition = position;
          _updateMarkers(currentPosition);
        },
        initialCameraPosition: const CameraPosition(
          target: _defaultPosition,
          zoom: 15,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          Navigator.of(context).pop(currentPosition);
        },
      ),
    );
  }

  void _updateMarkers(LatLng position) {
    _markers.clear();
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: LatLng(position.latitude, position.longitude),
      ));
    });
  }
}
