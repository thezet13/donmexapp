import 'package:get/get.dart';
import 'package:donmexapp/controllers/cart_controller.dart';
import 'package:donmexapp/models/products_model.dart';
import 'package:donmexapp/utils/colors.dart';
import '../data/repository/products_menu_repo.dart';
import '../models/cart_model.dart';

class ProductsMenuController extends GetxController {
  final ProductsMenuRepo productsMenuRepo;
  ProductsMenuController({required this.productsMenuRepo});

  List<ProductsModel> _productsMenu = [];
  List<ProductsModel> get productsMenu => _productsMenu;
  late CartController _cart;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _quantity = 0;
  int get quantity => _quantity;
  int _inCartItems = 0;
  int get inCartItems => _inCartItems + _quantity;

  @override
  void onInit() {
    super.onInit();
    _cart = Get.find<CartController>();
  }

  Future<void> getProductsMenu() async {
    Response response = await productsMenuRepo.getProductsMenu();
    if (response.statusCode == 200) {
      _productsMenu = [];
      _productsMenu.addAll(Products.fromJson(response.body).products);
      _isLoaded = true;

      update();
    } else {}
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
    } else {
      _quantity = checkQuantity(_quantity - 1);
    }
    update();
  }

  int checkQuantity(int quantity) {
    if ((_inCartItems + quantity) < 0) {
      Get.snackbar(
        "Donmex",
        "Oops! You cannot reduce!",
        backgroundColor: AppColors.colorGreen,
        colorText: AppColors.colorWhite,
      );
      if (_inCartItems > 0) {
        _quantity = -_inCartItems;
        return _quantity;
      }
      return 0;
    } else if ((_inCartItems + quantity) > 20) {
      Get.snackbar(
        "Donmex",
        "Oops! You cannot add more!",
        backgroundColor: AppColors.colorGreen,
        colorText: AppColors.colorWhite,
      );
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(ProductsModel product, CartController cart, {required int quantity}) {
    _quantity = 1;
    _inCartItems = 0;
    _cart = cart;
  }

  void addItem(ProductsModel product, Map<int, bool> selectedModifications) {
    _cart.addItem(product, _quantity, selectedModifications);
    _quantity = 0;
    _inCartItems = _cart.getQuantity(product);

    _cart.items.forEach((key, value) {});

    update();
  }

  int get totalItems {
    return _cart.totalItems;
  }

  List<CartModel> get getItems {
    return _cart.getItems;
  }

  String getTotalPrice(ProductsModel product, ProductsMenuController productsMenu) {
    double totalProductPrice = double.parse(product.price!.s1!) * productsMenu.quantity;
    return '${totalProductPrice.toStringAsFixed(2)}';
  }

  void updateProductPrice(ProductsModel product, Map<int, bool> selectedModifications) {
    double basePrice = double.tryParse(product.price!.s1!) ?? 0;
    double modificationsPrice = 0;

    product.groupModifications!.forEach((group) {
      group.modifications!.forEach((modification) {
        int uniqueIndex = group.dishModificationGroupId! * 1000 + modification.dishModificationId!;
        if (selectedModifications[uniqueIndex] == true) {
          modificationsPrice += modification.price ?? 0;
        }
      });
    });

    double updatedPrice = basePrice + modificationsPrice;
    product.price!.s1 = updatedPrice.toStringAsFixed(2);
    update();
  }

  String getTotalPriceTwo(ProductsModel product, ProductsMenuController productsMenu,
      Map<int, bool> selectedModifications) {
    double totalProductPrice = double.parse(product.price!.s1!) * productsMenu.quantity;

    // Calculate the total price of checked modifications
    double totalModificationsPrice = 0;
    product.groupModifications?.asMap().forEach((index, group) {
      group.modifications?.asMap().forEach((modIndex, modification) {
        int uniqueIndex = group.dishModificationGroupId! * 1000 + modIndex;
        if (selectedModifications[uniqueIndex] == true) {
          var modificationFinal = modification.price! * 100;
          totalModificationsPrice += modificationFinal;
        }
      });
    });

    // Add the total price of checked modifications to the totalProductPrice
    totalProductPrice += totalModificationsPrice * productsMenu.quantity;
    var totalProductPriceFinal = totalProductPrice * 0.01;

    return '${totalProductPriceFinal}';
  }
}
