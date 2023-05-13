import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/app_constants.dart';

class GoogleApiClient extends GetConnect implements GetxService {
  late String? token;
  late String? response;
  final String googleBaseUrl;
  late SharedPreferences sharedPreferences;
  late Map<String, String> _mainHeaders;
  Map<String, String> get mainHeaders => _mainHeaders;

  GoogleApiClient({required this.googleBaseUrl, required this.sharedPreferences}) {
    baseUrl = googleBaseUrl;
    response = AppConstants.GOOGLE_MAP_API;
    token = AppConstants.TOKEN;

    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(
    String uri,
  ) async {
    try {
      Response response = await get(uri);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postDataToPoster(String uri, dynamic body) async {
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}

class PosterApiClient extends GetConnect implements GetxService {
  late String? token;
  late String? response;
  final String posterBaseUrl;
  late SharedPreferences sharedPreferences;
  late Map<String, String> _mainHeaders;
  Map<String, String> get mainHeaders => _mainHeaders;

  PosterApiClient({required this.posterBaseUrl, required this.sharedPreferences}) {
    //baseUrl = posterBaseUrl;
    response = AppConstants.POSTER_BASE_URL;
    token = AppConstants.TOKEN;

    // baseUrl = posterBaseUrl;
    // response = AppConstants.POSTER_BASE_URL;
    // token = AppConstants.TOKEN;

    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(
    String uri,
  ) async {
    try {
      Response response = await get('https://joinposter.com${uri}');
      return response;
    } catch (e) {
      print('from poster api error ${e.toString()}');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response = await post('https://joinposter.com${uri}', body, headers: _mainHeaders);
      print('response ${response}');
      return response;
    } catch (e) {
      print('from google client what is error ${e.toString()}');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
