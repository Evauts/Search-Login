import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:search/Components/locationsuggestionlist.dart';
import 'package:search/Components/network_util.dart';
import '../Components/constant.dart';
import 'package:geocoding/geocoding.dart';
import '../Components/auto_complete_prediction.dart';
import '../Components/place_ac_response.dart';

enum ActiveTextField {
  CurrentLocation,
  Destination,
}

class MySearchPage extends StatefulWidget {
  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _DestinationController = TextEditingController();
  List<AutocompletePrediction> placepredictions = [];
  ActiveTextField _activeTextField = ActiveTextField.CurrentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

  void placeAutocomplete(String reply) async {
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": reply,
      "key": apiKey,
    });
    String? response = await NetworkUtil.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placepredictions = result.predictions!;
          print("Placepredictions length: ${placepredictions.length}");
          for (var prediction in placepredictions) {
            print("Prediction: ${prediction.description}");
          }
        });
      }
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
            child: Icon(Icons.arrow_back),
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
                onChanged: (value) {
                  setState(() {
                    _activeTextField = ActiveTextField.CurrentLocation;
                    placeAutocomplete(value);
                  });
                },
                controller: _currentLocationController,
                decoration: InputDecoration(
                  labelText: 'Current Location',
                  border: OutlineInputBorder(),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.my_location),
                    onPressed: _getCurrentLocation,
                  ),
                ),
              ),
            ),
            Container(
              color: secondaryColor10LightTheme,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _activeTextField = ActiveTextField.Destination;
                    placeAutocomplete(value);
                  });
                },
                controller: _DestinationController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                  label: const Text("Search Carpark"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor20LightTheme,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: placepredictions.length,
                itemBuilder: (context, index) => LocationSuggestion(
                  location: placepredictions[index].description!,
                  controller:
                      _activeTextField == ActiveTextField.CurrentLocation
                          ? _currentLocationController
                          : _DestinationController,
                  press: () {
                    setState(() {
                      if (_activeTextField == ActiveTextField.CurrentLocation) {
                        _currentLocationController.text =
                            placepredictions[index].description!;
                      } else {
                        _DestinationController.text =
                            placepredictions[index].description!;
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
