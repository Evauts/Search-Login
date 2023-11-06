import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'constant.dart';
import 'package:geocoding/geocoding.dart';

class MySearchPage extends StatefulWidget {
  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _DestinationController = TextEditingController();

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    googlePlace = GooglePlace(apiKey);
  }

  @override
  void dispose() {
    _currentLocationController.dispose();
    _DestinationController.dispose();
    super.dispose();
  }

  _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          String currentLocation =
              "${placemark.name},${placemark.administrativeArea},${placemark.country}";
          setState(() {
            _currentLocationController.text = currentLocation;
          });
        } else {
          // Fallback mechanism if no address information is found
          setState(() {
            _currentLocationController.text =
                "Address information not available";
          });
        }
      } else {
        print('Location permission not granted');
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        _currentLocationController.text =
            "Error occurred while fetching location";
      });
    }
  }

  autocompleteSearch(String input) async {
    var result = await googlePlace.autocomplete.get(input);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor5LightTheme,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: defaultPadding,
          ),
          child: CircleAvatar(
            backgroundColor: secondaryColor10LightTheme,
            child: Icon(Icons.location_on),
          ),
        ),
        title: Text(
          "ParkerApp",
          style: TextStyle(color: textColorLightTheme),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              color: secondaryColor10LightTheme,
              child: TextFormField(
                controller: _currentLocationController,
                decoration: InputDecoration(
                  labelText: 'Current Location',
                  border: OutlineInputBorder(),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.my_location),
                    onPressed: _getCurrentLocation,
                  ),
                ),
                onChanged: (input) async {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 1000), () {
                    if (input.isNotEmpty) {
                      autocompleteSearch(input);
                    } else {
                      //clear
                    }
                  });
                },
              ),
            ),
            const Divider(
              height: 4,
              thickness: 4,
              color: secondaryColor10LightTheme,
            ),
            Container(
              color: secondaryColor10LightTheme,
              child: TextFormField(
                controller: _DestinationController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
