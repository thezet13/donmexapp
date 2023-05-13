import 'package:get/get.dart';
import 'package:donmexapp/app_constants.dart';
import '../api/api_client.dart';

class SpotsRepo extends GetxService {
  final PosterApiClient apiClient;
  SpotsRepo({required this.apiClient});

  Future<Response> getSpots() async {
    return await apiClient.getData(AppConstants.SPOTS_URI);
  }
}
