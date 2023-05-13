import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/data/api/api_client.dart';
import 'package:donmexapp/models/address_model.dart';

class LocationRepo {
  final GoogleApiClient googleApiClient;
  final PosterApiClient posterApiClient;

  final SharedPreferences sharedPreferences;

  LocationRepo(
      {required this.posterApiClient,
      required this.googleApiClient,
      required this.sharedPreferences});

  Future<Response> getAddressfromGeocode(LatLng latlng) async {
    return await googleApiClient
        .getData(AppConstants.GEOCODE_URI + '&latlng=${latlng.latitude},${latlng.longitude}');
  }

  //Future<Response> getUserAddress() async{
  //  try{ return await posterApiClient.getData(AppConstants.ADDRESS_LIST_URI);
  //     }catch(e){
  //     print(e);
  //      return Response(statusCode: 1, statusText: e.toString());
  //   }

  String getUserAddress() {
    return sharedPreferences.getString('dm_useraddress') ?? '';
  }

  Future<void> printUserAddress() async {
    try {
      final user = sharedPreferences.getString('dm_useraddress') ?? '';
      print('print user address: ' + user);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Response> getAddress(AddressModel addressModel,
      {String? token, Map<String, String>? headers}) async {
    if (token != null) {
      googleApiClient.updateHeader(token);
    } else {
      googleApiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    }
    if (headers != null) {
      headers.addAll(googleApiClient.mainHeaders);
    } else {
      headers = googleApiClient.mainHeaders;
    }
    //return await posterApiClient.postData(AppConstants.ADD_USER_ADDRESS, addressModel.toJson());
    return await posterApiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }

  Future<Response> addAddress(AddressModel addressModel) async {
    try {
      return await posterApiClient.postData(AppConstants.ADD_USER_ADDRESS, addressModel.toJson());
    } catch (e) {
      print('from addAdress repo what is error ${e.toString()}');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> getAllAddress() async {
    try {
      final clientId = sharedPreferences.getString('dm_clientId') ?? '';
      return await posterApiClient.getData(AppConstants.ADDRESS_LIST_URI + '&client_id=$clientId');
    } catch (e) {
      print(e);
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<bool> saveUserAddress(String address) async {
    //apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    return await sharedPreferences.setString('dm_useraddress', address);
  }

  // Future<Response> getZone(LatLng latlng) async {
  //   return await apiClient.getData('${AppConstants.ZONE_URI}&latlng=${latlng.latitude},${latlng.longitude}');
  //  }
  // Future<Response> getZone(String lat, String lng) async {
  //   var latitude;
  //   var longitude;
  //   return await apiClient.getData('${AppConstants.GEOCODE_URI}&latlng=${lat.latitude},${lng.longitude}');
  //  }

  Future<Response> getClientId(String phone) async {
    try {
      return await posterApiClient.getData(AppConstants.LOGIN_URI + '&phone=$phone');
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> getClientAddressId(String clientId) async {
    try {
      return await posterApiClient.getData(AppConstants.USER_INFO_URI + '&client_id=$clientId');
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> getZone() async {
    try {
      return await googleApiClient.getData(AppConstants.ZONES);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> searchLocation(String text) async {
    return await googleApiClient.getData('${AppConstants.SEARCH_LOCATION_URI}&input=$text');
  }

  // Future<Response> searchLocation(String text, {String? region, String? components}) async {
  //   String apiKey = 'AIzaSyCaOgQ61F98HEbHbKpMZKEXwoYWs5AUmAo';
  //   String url = 'https://maps.googleapis.com${AppConstants.SEARCH_LOCATION_URI}?key=$apiKey';

  //   Uri uri = Uri.parse(url).replace(
  //     queryParameters: {
  //       'input': text,
  //       if (region != null) 'region': region,
  //       if (components != null) 'components': components,
  //     },
  //   );

  //   return await apiClient.getData(uri.toString());
  // }

  Future<Response> setLocation(String placeId) async {
    return await googleApiClient.getData('${AppConstants.PLACE_DETAILS_URI}&placeid=$placeId');
  }
}
