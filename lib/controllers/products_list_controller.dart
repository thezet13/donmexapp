import 'package:get/get.dart';
import 'package:donmexapp/models/products_model.dart';
import '../data/repository/products_list_repo.dart';

class ProductsListController extends GetxController {
  final ProductsListRepo productsListRepo;
  ProductsListController({required this.productsListRepo});
  List<dynamic> _productsList = [];
  List<dynamic> get productsList => _productsList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getProductsList() async {
    Response response = await productsListRepo.getProductsList();
    if (response.statusCode == 200) {
      //print("got list");
      _productsList = [];
      _productsList.addAll(Products.fromJson(response.body).products);
      //print(_productsList);
      _isLoaded = true;
      update();
    } else {}
  }
}
