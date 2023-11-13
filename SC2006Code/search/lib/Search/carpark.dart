import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../Components/constant.dart';
import 'package:geocoding/geocoding.dart';
import 'package:search/Navigation/NavigationScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:csv/csv.dart';

class CarParkInfo {
  final String totalLots;
  final String lotType;
  final String lotsAvailable;
  final String address;

  CarParkInfo({required this.totalLots, required this.lotType, required this.lotsAvailable, required this.address});

  factory CarParkInfo.fromJson(Map<String, dynamic> json) {
    return CarParkInfo(
      totalLots: json['total_lots'],
      lotType: json['lot_type'],
      lotsAvailable: json['lots_available'],
      address: json['address'],
    );
  }
}

class CarParkData {
  final String carparkNumber;
  final String updateDatetime;
  final List<CarParkInfo> carparkInfo;

  CarParkData({required this.carparkNumber, required this.updateDatetime, required this.carparkInfo,});

  factory CarParkData.fromJson(Map<String, dynamic> json) {
    var list = json['carpark_info'] as List;
    List<CarParkInfo> carparkInfoList = list.map((i) => CarParkInfo.fromJson(i)).toList();

    return CarParkData(
      carparkNumber: json['carpark_number'],
      updateDatetime: json['update_datetime'],
      carparkInfo: carparkInfoList,
    );
  }
}

class CarParkItem {
  final String timestamp;
  final List<CarParkData> carparkData;

  CarParkItem({required this.timestamp, required this.carparkData});

  factory CarParkItem.fromJson(Map<String, dynamic> json) {
    var list = json['carpark_data'] as List;
    List<CarParkData> carparkDataList = list.map((i) => CarParkData.fromJson(i)).toList();

    return CarParkItem(
      timestamp: json['timestamp'],
      carparkData: carparkDataList,
    );
  }
}

class CarParkCoordinate {
  final String id;
  final double x;
  final double y;

  CarParkCoordinate({required this.id, required this.x, required this.y});
}

Future<LatLng?> _getLatLngFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return LatLng(locations[0].latitude, locations[0].longitude);
    }
  } catch (e) {
    print("Error getting location: $e");
  }
  return null;
}

class MyCarParks extends StatefulWidget{
  final LatLng destination; // Add this line
  const MyCarParks({super.key, required this.destination});
  @override
  State<MyCarParks> createState()=>_MyCarParks();
}

class _MyCarParks extends State<MyCarParks>{
  final List<Marker> _markers = <Marker>[];
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();

  @override
  void initState(){
    super.initState();
    loadData();

}

loadData() async{
  final String csvData =
  await rootBundle.loadString('assets/HDBCarparkInformation.csv');
  List<List<dynamic>> rowsAsListOfValues =
  const CsvToListConverter().convert(csvData, eol: '\n');
  // print(csvData);
  // print(rowsAsListOfValues.length);
  rowsAsListOfValues.take(10).forEach((row) {
    _getLatLngFromAddress(row[1]).then((value) {
      Marker createdMarker = Marker( //add second marker
          markerId: MarkerId(row[0]),
          position: value!,
          //position of marker
          infoWindow: const InfoWindow( //popup info
            title: 'Parking Lot',
          ),
          icon: BitmapDescriptor.defaultMarker,
          //Icon for Marker
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("${MarkerId(row[1])}"),
                  //content: Text("Number of available slots is ${listOfCarParks["items"]}"),
                  actions: [
                    TextButton(
                      child: Text("Ok"),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavScreen(destination: value),
                        ),
                      ),
                    )
                  ],
                ),
            ) ;
          }
      );
      print("marker has been created");
      if (createdMarker != null) {
        print("MARKER ID IS${createdMarker.markerId}");
        _markers.add(createdMarker);
        setState(() {
        });
        print("num of markers = ${_markers.length}");
      }
    });
    });
}

  int findLotsAvailable(String jsonData, String carparkNumber) {
    var data = jsonDecode(jsonData);
    var carparkData = data['items'][0]['carpark_data'];

    for (var carpark in carparkData) {
      if (carpark['carpark_number'] == carparkNumber) {
        var lotsAvailable = carpark['carpark_info'][0]['lots_available'];
        print('Lots available in $carparkNumber: $lotsAvailable');
        return lotsAvailable;
      }
    }

    print('Carpark number $carparkNumber not found.');
    return 0;
  }

  Future<List<CarParkItem>> fetchCarParks() async {
    final response = await http.get(Uri.parse('https://api.data.gov.sg/v1/transport/carpark-availability'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['items'];
      return jsonResponse.map((data) => CarParkItem.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load car park data');
    }
  }

  @override
  Widget build(BuildContext context){
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
        body:GoogleMap(
          onMapCreated: ((GoogleMapController controller) =>
              _mapController.complete(controller)),
          initialCameraPosition: CameraPosition(
            target: widget.destination,
            zoom: 15,
          ),
          markers: Set<Marker>.of(_markers),
        ),
    );
  }
}
