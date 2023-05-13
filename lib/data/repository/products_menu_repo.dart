import 'package:get/get.dart';
import '../../app_constants.dart';
import '../api/api_client.dart';

class ProductsMenuRepo extends GetxService {
  final PosterApiClient apiClient;
  ProductsMenuRepo({required this.apiClient});

  Future<Response> getProductsMenu() async {
    return await apiClient.getData(AppConstants.PRODUCTS_MENU_URI);
  }
}
