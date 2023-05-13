import 'dart:convert';

import 'package:get/get.dart';
import 'package:donmexapp/models/products_model.dart';

import '../data/repository/cart_repo.dart';
import '../models/cart_model.dart';
import '../utils/colors.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;

  CartController({required this.cartRepo});
  Map<int, CartModel> _items = {};

  Map<int, CartModel> get items => _items;

  /* storage for sharedPreferences */
  List<CartModel> storageItems = [];

  Map<int, List<String>> _modifications = {};

  int generateUniqueKey(int productId, List<Map<String, String>> selectedModifications) {
    List<String> modificationIds = selectedModifications.map((e) => e['id']!).toList();
    modificationIds.sort(); // Sort the modification IDs to ensure consistency
    String uniqueKeyString = "$productId-${modificationIds.join('-')}";
    return uniqueKeyString.hashCode;
  }

  Map<int, bool> modificationsListToMap(List<Map<String, String>> modificationsList) {
    return modificationsList.asMap().map((index, modification) {
      int uniqueIndex = int.parse(modification['id']!);
      return MapEntry(uniqueIndex, true);
    });
  }

  void addItem(ProductsModel product, int quantity, Map<int, bool> selectedModifications) {
    var totalQuantity = 0;
    List<Map<String, String>> selectedModificationsList = [];

    double totalModificationsPrice = 0;
    var productPrice = double.parse(product.price!.s1!) * 0.01;

    product.groupModifications?.asMap().forEach((index, group) {
      group.modifications?.asMap().forEach((modIndex, modification) {
        int uniqueIndex = group.dishModificationGroupId! * 1000 + modIndex;
        if (selectedModifications[uniqueIndex] == true) {
          totalModificationsPrice += modification.price ?? 0;
          selectedModificationsList.add({
            'name': modification.name!.tr, // Changed the way you add modifications to the list
            'id': modification.dishModificationId.toString(), // Added the modification ID
          });
        }
      });
    });
    _modifications[product.productId!] = selectedModificationsList.map((e) => e['name']!).toList();

    int uniqueKey = generateUniqueKey(product.productId!, selectedModificationsList);

    double totalPrice = productPrice + totalModificationsPrice;
    product.price!.s1 = (totalPrice * 100).toStringAsFixed(2);
    // String finalPrice = (totalPrice * 100).toStringAsFixed(2);
    // price: Price(s1: finalPrice),

    if (_items.containsKey(uniqueKey)) {
      _items.update(uniqueKey, (value) {
        int newQuantity = value.quantity! + quantity;

        if (newQuantity <= 0) {
          _items.remove(uniqueKey);
          return value; // Return the original value
        } else {
          return CartModel(
            productId: value.productId,
            productName: value.productName,
            photoOrigin: value.photoOrigin,
            price: value.price,
            quantity: newQuantity,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
            modifications: selectedModificationsList,
          );
        }
      });
    } else {
      if (quantity > 0) {
        _items.putIfAbsent(uniqueKey, () {
          return CartModel(
            productId: product.productId!,
            productName: product.productName,
            photoOrigin: product.photoOrigin,
            price: product.price,
            quantity: quantity,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
            modifications: selectedModificationsList,
          );
        });
      } else {
        Get.snackbar(
          "Warning",
          "You should add at least 1 item",
          backgroundColor: AppColors.colorGreen,
          colorText: AppColors.colorWhite,
        );
      }
    }

    cartRepo.addToCartList(getItems);
    update();
  }

  // void addItem(ProductsModel product, int quantity, Map<int, bool> selectedModifications) {
  //   var totalQuantity = 0;
  //   List<Map<String, String>> selectedModificationsList = [];

  //   double totalModificationsPrice = 0;
  //   var productPrice = double.parse(product.price!.s1!) * 0.01;

  //   product.groupModifications?.asMap().forEach((index, group) {
  //     group.modifications?.asMap().forEach((modIndex, modification) {
  //       int uniqueIndex = group.dishModificationGroupId! * 1000 + modIndex;
  //       if (selectedModifications[uniqueIndex] == true) {
  //         totalModificationsPrice += modification.price ?? 0;
  //         selectedModificationsList.add({
  //           'name': modification.name!, // Changed the way you add modifications to the list
  //           'id': modification.dishModificationId.toString(), // Added the modification ID
  //         });
  //       }
  //     });
  //   });
  //   _modifications[product.productId!] = selectedModificationsList.map((e) => e['name']!).toList();

  //   double totalPrice = productPrice + totalModificationsPrice;
  //   product.price!.s1 = (totalPrice * 100).toStringAsFixed(2);
  //   // String finalPrice = (totalPrice * 100).toStringAsFixed(2);
  //   // price: Price(s1: finalPrice),

  //   if (_items.containsKey(product.productId)) {
  //     _items.update(product.productId!, (value) {
  //       totalQuantity = value.quantity! + quantity;

  //       return CartModel(
  //         productId: value.productId,
  //         productName: value.productName,
  //         photoOrigin: value.photoOrigin,
  //         price: value.price,
  //         quantity: value.quantity! + quantity,
  //         isExist: true,
  //         time: DateTime.now().toString(),
  //         product: product,
  //         modifications: selectedModificationsList,
  //       );
  //     });

  //     if (totalQuantity <= 0) {
  //       _items.remove(product.productId);
  //     }
  //   } else {
  //     if (quantity > 0) {
  //       _items.putIfAbsent(product.productId!, () {
  //         return CartModel(
  //           productId: product.productId!,
  //           productName: product.productName,
  //           photoOrigin: product.photoOrigin,
  //           price: product.price,
  //           quantity: quantity,
  //           isExist: true,
  //           time: DateTime.now().toString(),
  //           product: product,
  //           modifications: selectedModificationsList,
  //         );
  //       });
  //     } else {
  //       Get.snackbar(
  //         "Warning",
  //         "You should at least 1 item",
  //         backgroundColor: AppColors.colorGreen,
  //         colorText: AppColors.colorWhite,
  //       );
  //     }
  //   }

  //   cartRepo.addToCartList(getItems);
  //   update();
  // }

  int getQuantity(ProductsModel product) {
    var quantity = 0;

    if (_items.containsKey(product.productId!)) {
      _items.forEach((key, value) {
        if (key == product.productId!) {
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });

    return totalQuantity;
  }

  List<CartModel> get getItems {
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  double get totalAmount {
    double total = 0;

    _items.forEach((key, value) {
      var pv = double.parse(value.price!.s1!);
      var pvf = pv * 0.01;

      total += value.quantity! * pvf;
      print(total.toStringAsFixed(2));
    });
    return total;
  }

  List<CartModel> getCartData() {
    setCart = cartRepo.getCartList();
    return storageItems;
  }

  set setCart(List<CartModel> items) {
    storageItems = items;
    //print("Lenght of cart items" + storageItems.length.toString());

    for (int i = 0; i < storageItems.length; i++) {
      _items.putIfAbsent(storageItems[i].product!.productId!, () => storageItems[i]);
    }
  }

  void addToHistory() {
    cartRepo.addToCartHistoryList();
    clear();
  }

  void clear() {
    _items = {};
    update();
  }

  List<CartModel> getCartHistoryList() {
    return cartRepo.getCartHistoryList();
  }

  set setItems(Map<int, CartModel> setItems) {
    _items = {};
    _items = setItems;
  }

  void addToCartList() {
    cartRepo.addToCartList(getItems);
    update();
  }

  void clearCartHistory() {
    cartRepo.clearCartHistory();
    update();
  }
}
