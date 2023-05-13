import 'package:get/get.dart';
import '../../app_constants.dart';
import '../api/api_client.dart';

class ProductsListRepo extends GetxService {
  final PosterApiClient apiClient;
  ProductsListRepo({required this.apiClient});

  Future<Response> getProductsList() async {
    return await apiClient.getData(AppConstants.PRODUCTS_LIST_URI);
  }
}
