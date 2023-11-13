import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:search/Components/constant.dart';

class NavScreen extends StatefulWidget {
  final LatLng destination; // Add this line
  const NavScreen({super.key, required this.destination}); // Modify this line


  @override
  State<NavScreen> createState() => _NavScreen();
}

class _NavScreen extends State<NavScreen> {
  final Location _locationController = Location();

  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  static const LatLng _pGooglePlex = LatLng(1.3483, 103.6832);
  LatLng? _current;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then((value) => {
      _getPolylinePoints().then(
            (coordinates) => generatePolyline(coordinates),
      )
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor5LightTheme,
        centerTitle: true,
        leading:  Padding(
          padding: const EdgeInsets.only(
            left: defaultPadding,
          ),
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),)
            ],
          ),
        ),
        title: const Text(
          "ParkerApp",
          style: TextStyle(color: textColorLightTheme),
        ),
      ),
        body: _current == null
          ? const Center(
            child: Text("Loading...."),
          )
          : GoogleMap(
        onMapCreated: ((GoogleMapController controller) =>
            _mapController.complete(controller)),
        initialCameraPosition: CameraPosition(
          target: widget.destination,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("_currLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _current!,
          ),
          const Marker(
            markerId: MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePlex,
          ),
          Marker(
            markerId: const MarkerId("_DestinationLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: widget.destination,
          ),
        },
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  Future<void> _cameraToPostion(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 15);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }
    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentlocation) {
      if (currentlocation.latitude != null &&
          currentlocation.longitude != null) {
        setState(() {
          _current =
              LatLng(currentlocation.latitude!, currentlocation.longitude!);
          _cameraToPostion(_current!);
        });
      }
    });
  }

  Future<List<LatLng>> _getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinepoints = PolylinePoints();
    PolylineResult result = await polylinepoints.getRouteBetweenCoordinates(
      Firebase.app().options.apiKey,
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      PointLatLng(widget.destination.latitude, widget.destination.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyline(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId('route1');
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
