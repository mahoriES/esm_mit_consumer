import 'package:eSamudaay/utilities/keys.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlacePicker(
        apiKey: Keys.googleAPIkey, // Put YOUR OWN KEY here.
        onPlacePicked: (result) {
          // Handle the result in your way
          print(result?.formattedAddress);
          // print(result?.a);
//          if (result?.formattedAddress != null) {
//            addressController.text =
//                result?.formattedAddress;
//          }
////                                                if (result?.postalCode !=
////                                                    null) {
////                                                  pinCodeController.text =
////                                                      result?.postalCode;
////                                                }
//          latitude =
//              result.geometry.location.lat.toString();
//          longitude =
//              result.geometry.location.lng.toString();
          print(result.adrAddress);
          Navigator.of(context).pop();
        },
//                                              initialPosition: HomePage.kInitialPosition,
        useCurrentLocation: true,
      ),
    );
  }
}
