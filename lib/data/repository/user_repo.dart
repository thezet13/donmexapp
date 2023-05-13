import 'package:get/get.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/data/api/api_client.dart';

class UserRepo {
  final PosterApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response> getUserInfo(String clientId) async {
    return await apiClient.getData(AppConstants.USER_INFO_URI + '&client_id=$clientId');
  }

  Future<Response> getClientId(String phone) async {
    try {
      return await apiClient.getData(AppConstants.LOGIN_URI + '&phone=$phone');
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
