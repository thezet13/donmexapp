import 'dart:convert';
//import 'package:donmexapp/data/api/api_checker.dart';
import 'package:donmexapp/base/show_error_snackbar.dart';
import 'package:donmexapp/data/api/api_checker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/data/repository/location_repo.dart';
import 'package:donmexapp/models/address_model.dart';
import 'package:donmexapp/models/response_model.dart';
import 'package:google_maps_webservice/src/places.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});
  bool _loading = false;

  late Position _position;
  late Position _pickPosition;

  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;
  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;
  late List<AddressModel> _allAddressList;
  List<AddressModel> get allAddressList => _allAddressList;
  int _addressTypeIndex = 0;

  List<String> _addressTypeList = [""];
  List<String> get addressTypeList => _addressTypeList;
  int get addressTypeIndex => _addressTypeIndex;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  bool _updateAddressData = true;
  bool _changeAddress = true;

  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;

  bool _isLoading = false; // for service zone
  bool get isLoading => _isLoading;
  bool _inZone = false; // user in zone or not
  bool get inZone => _inZone;
  bool _buttonDisabled = true; // showing and hiding btn
  bool get buttonDisabled => _buttonDisabled;

  List<Prediction> _predictionList = [];

  RxString _selectedAddress = "".obs;
  String get selectedAddress => _selectedAddress.value;
  void setSelectedAddress(String address) => _selectedAddress.value = address;

  void updatePosition(CameraPosition position, bool fromAddress) async {
    if (_updateAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        } else {
          _pickPosition = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        }

        // ResponseModel _responseModel=
        //   await getZone(position.target.latitude.toString(), position.target.longitude.toString(), false);
        // _buttonDisabled=!_responseModel.isSuccess;

        // if (_changeAddress) {
        //   String _address = await getAddressfromGeocode(
        //       LatLng(position.target.latitude, position.target.longitude));
        //   fromAddress
        //       ? _placemark = Placemark(name: _address)
        //       : _pickPlacemark = Placemark(name: _address);
        // } this is working version
        if (_changeAddress) {
          String _address = await getAddressfromGeocode(
              LatLng(position.target.latitude, position.target.longitude));
          fromAddress
              ? _placemark = Placemark(name: _address)
              : _pickPlacemark = Placemark(name: _address);
        }
      } catch (e) {
        print(e);
      }

      _loading = false;
      update();
    } else {
      _updateAddressData = true;
    }
  }

  Future<String> getAddressfromGeocode(LatLng latlng) async {
    String _address = 'choose_place'.tr;
    Response response = await locationRepo.getAddressfromGeocode(latlng);

    if (response.body["status"] == 'OK') {
      // Retrieve the address components
      List<dynamic> addressComponents = response.body["results"][0]['address_components'];

      // Filter out the city and country components
      List<dynamic> filteredComponents = addressComponents.where((component) {
        return !component['types'].contains('locality') && !component['types'].contains('country');
      }).toList();

      // Exclude the city from the filtered components if it exists
      if (filteredComponents
          .any((component) => component['types'].contains('administrative_area_level_1'))) {
        filteredComponents
            .removeWhere((component) => component['types'].contains('administrative_area_level_1'));
      }

      // Concatenate the filtered components to form the address without city and country
      _address = filteredComponents.map((component) => component['long_name']).join(', ');
      _address = filteredComponents.map((component) => component['long_name']).join(', ');

      print("Printing address from Google: " + _address);
    } else {
      print("Error getting the Google API");
    }

    update();
    return _address;
  }

  late Map<String, dynamic> _getAddress;
  Map get getAddress => _getAddress;

  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    /* MAP                              SH GET: USER_ADDRESS */
    _getAddress = jsonDecode(locationRepo.getUserAddress());

    /* convert above result to MODEL */
    _addressModel = AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));

    return _addressModel;
  }

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();

    Response response = await locationRepo.addAddress(addressModel);

    ResponseModel responseModel;
    if (response.statusCode == 200) {
      await getAddressList(); //gets list of addresses and stores to {address}

      String message = response.body["response"];
      responseModel = ResponseModel(true, message);

      await saveUserAddress(addressModel);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];

      print('all addresses:' + response.body["response"][0]["addresses"].toString());

      response.body["response"][0]["addresses"].forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  Future<bool> saveUserAddress(AddressModel addressModel) async {
    Map<String, dynamic> addressData = {
      'id': addressModel.addressId,
      'comment': addressModel.addressType,
      'address1': addressModel.address,
      'lat': addressModel.latitude,
      'lng': addressModel.longitude,
    };
    // String userAddress = jsonEncode(addressModel.toJson());
    String userAddress = jsonEncode(addressData);
    return await locationRepo.saveUserAddress(userAddress);
  }

  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }

  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress();
  }

  void setAddressData() {
    _position = _pickPosition;
    _placemark = _pickPlacemark;
    _updateAddressData = false;
    update();
  }

  Future<int> getClientAddressId() async {
    _isLoading = true;
    update();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final clientId = preferences.getString('dm_clientId');
    late int _addressId;
    late String _clientAddress;

    Response response = await locationRepo.getClientAddressId(clientId!);
    print('from location controller: ' + response.body.toString());

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(jsonEncode(response.body));
      //print('what is response 1' + response.body.toString());

      _addressId = jsonResponse['response'][0]['addresses'][0]['id'];
      _clientAddress = jsonResponse['response'][0]['addresses'][0]['address1'];
      //print('what is response 2 ' + addressId.toString());

      preferences.setInt('dm_clientAddressId', _addressId);
      preferences.setString('dm_clientAddress', _clientAddress);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      _addressId = 0;
    }
    _isLoading = false;
    update();
    return _addressId;
  }

  Future<String> getAddressId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final addressId = preferences.getString('dm_clientAddressId');
    //print('adressID from ' + addressId.toString());
    return addressId ?? '';
  }

  Future<Map<String, List<dynamic>>> fetchDataFromUrl(String url) async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data.map((key, value) => MapEntry<String, List<dynamic>>(key, value as List<dynamic>));
    }

    throw Exception('Failed to fetch points from $url');
  }

  Future<Map<String, List<dynamic>>> fetchPoints() async {
    String primaryUrl = 'http://donmex.az/data/zones.json';
    String secondaryUrl = 'http://donmex.byethost6.com/data/zones.json';

    try {
      return await fetchDataFromUrl(primaryUrl);
    } catch (e) {
      print('Error fetching zones from primary URL: $e');
      try {
        return await fetchDataFromUrl(secondaryUrl);
      } catch (e) {
        showErrorSnackBar('not_loaded_zones'.tr, title: 'sorry'.tr);
        print('Error fetching zones from secondary URL: $e');
        return {
          'error': ['try again, restart app']
        };
      }
    }
  }

  //before adding second url
  //Future<Map<String, List<dynamic>>> fetchPoints() async {
  //   String url = 'http://donmex.az/data/zones.json';
  //   try {
  //     var response = await http.get(Uri.parse(url));
  //     print('zones: ' + response.body);

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body) as Map<String, dynamic>;

  //       // Iterate through the keys and create a map entry for each key
  //       print('data: ' + data.toString());
  //       return data
  //           .map((key, value) => MapEntry<String, List<dynamic>>(key, value as List<dynamic>));
  //     } else {
  //       throw Exception('Failed to fetch points');
  //     }
  //   } catch (e) {
  //     showErrorSnackBar('not_loaded_zones'.tr, title: 'sorry'.tr);

  //     print('Error fetching zones: $e');
  //     return {
  //       'error': ['try again, restart app']
  //     };
  //   }
  // }

  void fetchData() async {
    var points = await fetchPoints();

    if (points.containsKey('error')) {
      // Show error message to the user
      showErrorSnackBar('not_loaded_zones'.tr, title: 'sorry'.tr);
    } else {
      print('proccess');
    }
  }
  //before not loading zones and show message
  //Future<Map<String, List<dynamic>>> fetchPoints() async {
  //   String url = 'http://donmex.az/data/zones.json';
  //   var response = await http.get(Uri.parse(url));
  //   print('zones: ' + response.body);

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body) as Map<String, dynamic>;

  //     // Iterate through the keys and create a map entry for each key
  //     return data.map((key, value) => MapEntry<String, List<dynamic>>(key, value as List<dynamic>));
  //   } else {
  //     throw Exception('Failed to fetch points');
  //   }
  // }

  Future<List<Prediction>> searchLocation(
    BuildContext context,
    String text,
  ) async {
    if (text.isNotEmpty) {
      //     String city = 'Baku'; // Replace this with your desired city
      //     String country = 'AZ'; // Replace this with the corresponding country code

      Response response = await locationRepo.searchLocation(text);
      //         region: country, components: 'locality:$city|country:$country');
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _predictionList = [];
        print('prediction:' + response.body.toString());
        response.body['predictions']
            .forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  // Future<List<Prediction>> searchLocation(
  //   BuildContext context,
  //   String text,
  // ) async {
  //   if (text.isNotEmpty) {
  //     String city = 'Baku'; // Replace this with your desired city
  //     String country = 'AZ'; // Replace this with the corresponding country code

  //     Response response = await locationRepo.searchLocation(text,
  //         region: country, components: 'locality:$city|country:$country');
  //     if (response.statusCode == 200 && response.body['status'] == 'OK') {
  //       _predictionList = [];
  //       print('prediction:' + response.body.toString());
  //       response.body['predictions']
  //           .forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
  //     } else {
  //       ApiChecker.checkApi(response);
  //     }
  //   }
  //   return _predictionList;
  // }

  // Future<List<Prediction>> searchLocation(
  //   BuildContext context,
  //   String text,
  // ) async {
  //   if (text.isNotEmpty) {
  //     Response response = await locationRepo.searchLocation(text);
  //     if (response.statusCode == 200 && response.body['status'] == 'OK') {
  //       _predictionList = [];
  //       print('prediction:' + response.body.toString());
  //       response.body['predictions']
  //           .forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
  //     } else {
  //       ApiChecker.checkApi(response);
  //     }
  //   }
  //   return _predictionList;
  // }

  setLocation(String placeId, String address, GoogleMapController mapController) async {
    _loading = true;
    update();
    PlacesDetailsResponse detail;
    Response response = await locationRepo.setLocation(placeId);
    detail = PlacesDetailsResponse.fromJson(response.body);
    _pickPosition = Position(
      latitude: detail.result.geometry!.location.lat,
      longitude: detail.result.geometry!.location.lng,
      accuracy: 1,
      timestamp: DateTime.now(),
      altitude: 1,
      speed: 1,
      heading: 1,
      speedAccuracy: 1,
    );
    _pickPlacemark = Placemark(name: address);
    _changeAddress = true;
    _loading = false;
    if (!mapController.isNull) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng,
          ),
          zoom: 18)));
    }
    update();
  }

  // Future<List<dynamic>> fetchPoints() async {
  //   String url = 'http://donmex.az/data/zones.json';
  //   var response = await http.get(Uri.parse(url));
  //   print('zones: ' + response.body);

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body) as Map<String, dynamic>;
  //     List<dynamic> zone1Coordinates = data['zone_1'] as List<dynamic>;

  //     // Print out zone_1 coordinates
  //     print('zone_1 coordinates: $zone1Coordinates');

  //     return zone1Coordinates;
  //   } else {
  //     throw Exception('Failed to fetch points');
  //   }
  // }
}
