import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/data/api/api_client.dart';
import 'package:donmexapp/models/signup_body_model.dart';

class AuthRepo {
  final PosterApiClient apiClient;
  late final SharedPreferences sharedPreferences;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> registration(SignUpBody signUpBody) async {
    try {
      return await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBody.toJson());
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // Future<Response> login(String phone, String password) async{
  //     try{
  //       return await apiClient.postData(AppConstants.LOGIN_URI, {"phone":phone, "password":password});
  //     }catch(e){
  //       return Response(statusCode: 1, statusText: e.toString());      }
  // }

  Future<Response> getClientId(String phone, String password) async {
    try {
      // var clientId = ''.obs;
      // final url = AppConstants.LOGIN_URI+'?phone=$phone';
      // final response = await await apiClient.get(url);

      return await apiClient.getData(AppConstants.LOGIN_URI + '&phone=$phone');
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }

    // if (response.statusCode == 200) {
    //   final jsonResponse = json.decode(response.body);
    //   clientId.value = jsonResponse['response'][0]['client_id'];
    //   return clientId.value;
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    //   return null;
    // }
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  Future<bool> saveClientId(String response) async {
    apiClient.response;
    return await sharedPreferences.setString('dm_clientId', response);
  }

  Future<void> saveClientsInfo(String phone, String lastname, String password) async {
    try {
      await sharedPreferences.setString('dm_phone', phone);
      await sharedPreferences.setString('dm_lastname', lastname);
      await sharedPreferences.setString('dm_password', password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey('dm_clientId');
  }

  Future<String> getUserToken() async {
    return await sharedPreferences.getString(AppConstants.TOKEN) ?? "None";
  }

  Future<String> getUserClientID() async {
    return await sharedPreferences.getString('dm_clientId') ?? "None";
  }

  Future<String?> getClientPhone() async {
    return await sharedPreferences.getString('dm_phone') ?? "None";
  }

  Future<String?> getClientName() async {
    return await sharedPreferences.getString('dm_lastname') ?? "None";
  }

//  Future<String> getUserName() async{
//     return await sharedPreferences.getString(AppConstants.NAME)??"None";
//   }
  // Future<Response> login(String phone) async{
  //   return await apiClient.postData(AppConstants.LOGIN_URI,{"phone":phone});
  // }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PHONE);
    sharedPreferences.remove(AppConstants.LASTNAME);
    sharedPreferences.remove(AppConstants.CLIENTID);
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    sharedPreferences.remove(AppConstants.USER_LATITUDE);
    sharedPreferences.remove(AppConstants.USER_LONGITUDE);
    sharedPreferences.remove(AppConstants.PHONE);

    sharedPreferences.remove('dm_phone');
    sharedPreferences.remove('dm_clientId');
    sharedPreferences.remove('dm_firstname');
    sharedPreferences.remove('dm_lastname');
    sharedPreferences.remove('dm_lng');
    sharedPreferences.remove('dm_lat');
    sharedPreferences.remove('dm_address');
    sharedPreferences.remove('dm_useraddress');
    sharedPreferences.remove('dm_clientAddress');
    sharedPreferences.remove('dm_selectedSpotId');

    sharedPreferences.remove('phone');
    sharedPreferences.remove('clientId');
    sharedPreferences.remove('firstname');
    sharedPreferences.remove('lastname');
    sharedPreferences.remove('lng');
    sharedPreferences.remove('address');
    sharedPreferences.remove('lat');

    sharedPreferences.remove('d_phone');
    sharedPreferences.remove('d_clientId');
    sharedPreferences.remove('d_firstname');
    sharedPreferences.remove('d_lastname');
    sharedPreferences.remove('d_lng');
    sharedPreferences.remove('d_address');
    sharedPreferences.remove('d_lat');

    // apiClient.token ='';
    apiClient.updateHeader('');
    return true;
  }
}
