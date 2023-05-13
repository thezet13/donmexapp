import 'package:donmexapp/models/response_model.dart';
import 'package:donmexapp/pages/cart/order_processing_delivery_page.dart';
import 'package:donmexapp/pages/cart/order_processing_shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/controllers/cart_controller.dart';
import 'package:donmexapp/controllers/language_controller.dart';
import 'package:donmexapp/controllers/location_controller.dart';
import 'package:donmexapp/controllers/navigation_controller.dart';
import 'package:donmexapp/controllers/order_controller.dart';
import 'package:donmexapp/controllers/user_controller.dart';
import 'package:donmexapp/models/order_model.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/mid_text.dart';
import 'package:vibration/vibration.dart';

class CartOrderPage extends StatefulWidget {
  const CartOrderPage({Key? key}) : super(key: key);

  @override
  State<CartOrderPage> createState() => _CartOrderPageState();
}

class _CartOrderPageState extends State<CartOrderPage> {
  late bool _userLoggedIn;
  late final SharedPreferences sharedPreferences;
  late final String? _clientId =
      Get.find<AuthController>().authRepo.sharedPreferences.getString('dm_clientId');
  late final String? _serviceMode =
      Get.find<AuthController>().authRepo.sharedPreferences.getString('dm_serviceMode');
  late final String? _spotId =
      Get.find<AuthController>().authRepo.sharedPreferences.getString('dm_selectedSpotId');
  late final String? _lastname = Get.find<UserController>().userModel.lastname;
  final TextEditingController _addressControler = TextEditingController();
  CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(40.404561317116496, 49.93065394540004), zoom: 14);

  late LatLng _initialPosition = const LatLng(40.404561317116496, 49.93065394540004);

  String mapTheme = '';

  @override
  void initState() {
    super.initState();
    _userLoggedIn = Get.find<AuthController>().userLoggedIn();
//  print('initialized');

    DefaultAssetBundle.of(context).loadString('assets/maptheme/dark_theme.json').then((value) {
      mapTheme = value;
    });

    // final prefs = Get.find<AuthController>().authRepo.sharedPreferences;
    //final _clientId = prefs.getString('dm_clientId');
    // final _serviceMode = prefs.getString('dm_serviceMode');

//  print('clientId from iniState = ' + clientId.toString());

// ignore: unnecessary_null_comparison
    if (_userLoggedIn && Get.find<UserController>().userModel == null) {
      Get.find<UserController>().getUserInfo(_clientId);
//   print('clientId = ' + clientId.toString());
    }

    if (Get.find<LocationController>().addressList.isNotEmpty) {
      print('Address in not empty');
      /*
  bug fix
  */

      // print('getUserAddress()'+Get.find<LocationController>().getUserAddress().toString());
      // if(Get.find<LocationController>().getUserAddressFromLocalStorage()=="") {
      //   Get.find<LocationController>().saveUserAddress(Get
      //   .find<LocationController>()
      //   .addressList
      //   .last);
      // }

      Get.find<LocationController>().getUserAddress();
      _cameraPosition = CameraPosition(
          target: LatLng(
        double.parse(Get.find<LocationController>().getAddress["lat"]),
        double.parse(Get.find<LocationController>().getAddress["lng"]),
      ));
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress["lat"]),
        double.parse(Get.find<LocationController>().getAddress["lng"]),
      );
    } else {
      print('address is empty');
      Get.find<LocationController>().getUserAddress();
      _cameraPosition = CameraPosition(
          target: LatLng(
        double.parse(Get.find<LocationController>().getAddress["lat"]),
        double.parse(Get.find<LocationController>().getAddress["lng"]),
      ));
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress["lat"]),
        double.parse(Get.find<LocationController>().getAddress["lng"]),
      );
    }
  }

  String _selectedOption = "Delivery";
  String _name = "";
  String _comments = "";

  //final _nameController = TextEditingController();
  final _commentsController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.colorDarkGreen,
        body: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/donmex_wall.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).viewPadding.top,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(height: MediaQuery.of(context).viewPadding.top)),
          GetBuilder<LocationController>(
            builder: (locationController) {
              _addressControler.text = '${locationController.placemark.name ?? ''}'
                  '${locationController.placemark.locality ?? ''}'
                  '${locationController.placemark.postalCode ?? ''}'
                  '${locationController.placemark.country ?? ''}';
              print('address: ' + _addressControler.text);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.h5 * 9, left: Dimensions.w5 * 3),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteHelper.cartPage);
                              print('tapped');
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                left: Dimensions.w5 * 4,
                                right: Dimensions.w5 * 2,
                                top: Dimensions.h5 * 3,
                                bottom: Dimensions.h5 * 3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: AppColors.colorBlack,
                              ),
                              child:
                                  Icon(Icons.arrow_back_ios, size: 22, color: AppColors.colorGreen),
                            )),
                        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          GetBuilder<LocalizationController>(builder: (localizationController) {
                            return Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Text('title_order'.tr,
                                    style: TextStyle(fontSize: 28, color: AppColors.colorWhite)));
                          }),
                        ]),
                        SizedBox(width: Dimensions.w20 * 2.5)
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.h20, left: Dimensions.h10 / 5),
                      child: Visibility(
                        visible: false,
                        child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: EdgeInsets.only(left: Dimensions.h20, right: Dimensions.h20),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: locationController.addressTypeList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        locationController.setAddressTypeIndex(index);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions.h20, vertical: Dimensions.h10),
                                          margin: EdgeInsets.all(Dimensions.h10 / 4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.h10),
                                            border:
                                                Border.all(width: 1, color: AppColors.colorGreen),
                                            color: AppColors.colorDarkGreen,
                                          ),
                                          child: Icon(
                                            index == 0
                                                ? Icons.home_filled
                                                : index == 1
                                                    ? Icons.work
                                                    : Icons.location_on,
                                            color: locationController.addressTypeIndex == index
                                                ? AppColors.colorGreen
                                                : Theme.of(context).disabledColor,
                                          )));
                                },
                              ),
                            )),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: Dimensions.w10, right: Dimensions.w10),
                        child: _cartInfo()),
                    // Padding(
                    //   padding: EdgeInsets.only(left: Dimensions.w10, right: Dimensions.w10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       _buildOptionButton("Delivery", Icons.delivery_dining),
                    //       _buildOptionButton("In shop", Icons.store),
                    //       _buildOptionButton("Take away", Icons.takeout_dining),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 16.0),
                    if (_selectedOption == "Delivery") ...[
                      //_clientNameField(),
                      // _buildCommentsField(),
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.h20, right: Dimensions.h20),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: Dimensions.h10, top: Dimensions.h20, bottom: Dimensions.h5),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Delivery address',
                                    style: TextStyle(
                                        color: AppColors.colorWhite, fontWeight: FontWeight.w300),
                                  )),
                            ),
                            //Text(locationController.addressMode),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: Dimensions.h10,
                                  top: Dimensions.h5 * 3,
                                  right: Dimensions.h10,
                                  bottom: Dimensions.h5 * 3,
                                ), // Add padding inside the box decoration
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), // Add border radius
                                  border: Border.all(
                                      color: AppColors.colorDisabledG), // Add border color
                                ),
                                child: Row(
                                  // Wrap the Text and Icons with a Row widget
                                  children: [
                                    Icon(Icons.location_on,
                                        color: AppColors
                                            .colorGreen), // Add Location icon before the text
                                    const SizedBox(
                                        width: 5), // Add some space between the icon and the text
                                    Expanded(
                                      // Add Expanded to prevent overflow
                                      child: _addressControler.text.isEmpty
                                          ? Text(
                                              Get.find<UserController>().userModel.address,
                                              maxLines: 1, // Limit the text to one line
                                              overflow: TextOverflow
                                                  .ellipsis, // Add ellipsis when the text is too long
                                              style: TextStyle(
                                                color: AppColors.colorGreen,
                                                fontSize: 16,
                                              ),
                                            )
                                          : Text(
                                              _addressControler.text,
                                              maxLines: 1, // Limit the text to one line
                                              overflow: TextOverflow
                                                  .ellipsis, // Add ellipsis when the text is too long
                                              style: TextStyle(
                                                color: AppColors.colorGreen,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                        width:
                                            5), // Add some space between the text and the Edit icon
                                    GestureDetector(
                                      onTap: () {
                                        Get.find<NavigationController>()
                                            .setPreviousRoute('cartOrderPage');
                                        Get.toNamed(RouteHelper.getAddressPage());
                                      },
                                      child: Icon(Icons.edit, color: AppColors.colorGreen),
                                    ), // Add Edit icon after the text
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //     height: 120,
                      //     width: MediaQuery.of(context).size.width,
                      //     margin: EdgeInsets.only(
                      //         left: Dimensions.h20, right: Dimensions.h20, top: Dimensions.h10 / 3),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(0),
                      //         border: Border.all(width: 1, color: AppColors.colorDarkGreen2)),
                      //     child: Stack(
                      //       children: [
                      //         GoogleMap(
                      //             mapType: MapType.normal,
                      //             initialCameraPosition:
                      //                 CameraPosition(target: _initialPosition, zoom: 17),
                      //             onTap: (latlng) {
                      //               Get.find<NavigationController>()
                      //                   .setPreviousRoute('cartOrderPage');
                      //               Get.toNamed(RouteHelper.getAddressPage());
                      //             },
                      //             zoomControlsEnabled: false,
                      //             compassEnabled: false,
                      //             indoorViewEnabled: false,
                      //             mapToolbarEnabled: false,
                      //             myLocationEnabled: false,
                      //             scrollGesturesEnabled: false,
                      //             buildingsEnabled: false,
                      //             onCameraIdle: () {
                      //               locationController.updatePosition(_cameraPosition, true);
                      //             },
                      //             onCameraMove: ((position) => _cameraPosition = position),
                      //             onMapCreated: (GoogleMapController controller) {
                      //               controller.setMapStyle(mapTheme);
                      //               locationController.setMapController(controller);
                      //             }),
                      //         Center(
                      //           child: !locationController.loading
                      //               ? Image.asset(
                      //                   "assets/images/marker.png",
                      //                   height: 45,
                      //                   width: 45,
                      //                 )
                      //               : CircularProgressIndicator(),
                      //         ),
                      //       ],
                      //     )),
                    ] else if (_selectedOption == "In shop") ...[
                      _clientNameField(),
                      _buildCommentsField(),
                    ] else if (_selectedOption == "Take away") ...[
                      _clientNameField(),
                    ],
                  ],
                ),
              );
            },
          ),
        ]),
        bottomNavigationBar: GetBuilder<OrderController>(
          builder: (orderController) {
            return Container(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                margin: const EdgeInsets.only(left: 0, right: 0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: Color.fromARGB(255, 0, 120, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: Row(children: [
                      // _isButtonEnabled() && _addressControler.text.isNotEmpty
                      //     ? GestureDetector(
                      //         onTap: () async {
                      //           final cartController = Get.find<CartController>();
                      //           final _items = cartController.items;
                      //           List<Products> productsList = [];

                      //           _items.forEach((key, value) {
                      //             List<Modification> modificationsList =
                      //                 value.modifications!.map((mod) {
                      //               return Modification(
                      //                   m: mod['id']!,
                      //                   a: '1'); // Assuming '1' is the quantity for now
                      //             }).toList();

                      //             productsList.add(Products(
                      //               productId: value.productId,
                      //               count: value.quantity,
                      //               modification: modificationsList,
                      //             ));
                      //           });

                      //           OrderModel _orderModel = OrderModel(
                      //             spotId: _spotId,
                      //             clientId: _clientId,
                      //             lastname: _lastname,
                      //             serviceMode: _serviceMode,
                      //             products: productsList,
                      //             address: _addressControler.text,
                      //           );

                      //           print(_orderModel);

                      //           orderController.addOrder(_orderModel).then((response) {
                      //             if (response.isSuccess) {
                      //               print('order sent');
                      //             } else {
                      //               Get.snackbar("Order", "Something went wrong");
                      //             }
                      //           });
                      //         },
                      //         child: Container(
                      //           padding: EdgeInsets.only(
                      //               top: Dimensions.h5 * 5,
                      //               bottom: Dimensions.h5 * 5,
                      //               left: Dimensions.h30,
                      //               right: Dimensions.h30),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.only(
                      //               topRight: Radius.circular(Dimensions.r20),
                      //               topLeft: Radius.circular(Dimensions.r20),
                      //               bottomRight: Radius.circular(Dimensions.r20),
                      //               bottomLeft: Radius.circular(Dimensions.r20),
                      //             ),
                      //             color: AppColors.colorBlack,
                      //           ),
                      //           child: Row(
                      //             children: [
                      //               GetBuilder<LocalizationController>(
                      //                   builder: (localizationController) {
                      //                 return MidText(
                      //                     text: 'button_confirm'.tr, color: AppColors.colorGreen);
                      //                 //MidText(text: controller.totalAmount.toStringAsFixed(2) + " ₼"),
                      //               }),
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     :
                      GestureDetector(
                        onTap: () async {
                          final cartController = Get.find<CartController>();
                          final _items = cartController.items;
                          List<Products> productsList = [];

                          _items.forEach((key, value) {
                            List<Modification> modificationsList = value.modifications!.map((mod) {
                              return Modification(
                                  m: mod['id']!, a: '1'); // Assuming '1' is the quantity for now
                            }).toList();

                            productsList.add(Products(
                              productId: value.productId,
                              count: value.quantity,
                              modification: modificationsList,
                            ));
                          });

                          OrderModel _orderModel = OrderModel(
                            spotId: _spotId,
                            clientId: _clientId,
                            lastname: _lastname,
                            serviceMode: _serviceMode,
                            products: productsList,
                            address: _addressControler.text,
                          );

                          // orderController.addOrder(_orderModel).then((response) {
                          //   if (response.isSuccess) {
                          //     print('order sent');
                          //   } else {
                          //     Get.snackbar("Order", "Something went wrong");
                          //   }
                          // });

                          // Navigate to the OrderProcessingPage and pass the addOrder future
                          orderController.addOrder(_orderModel).then((response) {
                            if (response.isSuccess) {
                              print('order sent');
                              // Navigate to OrderProcessingPage after order is sent
                            } else {
                              Get.snackbar("Order", "Something went wrong");
                            }
                          });

                          if (_serviceMode == '1') {
                            Get.to(() => OrderProcessingShopPage());
                          } else if (_serviceMode == '2') {
                            Get.to(() => OrderProcessingShopPage());
                          } else if (_serviceMode == '3') {
                            Get.to(() => OrderProcessingDeliveryPage());
                          }

                          Vibration.vibrate();
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.h5 * 5,
                              bottom: Dimensions.h5 * 5,
                              left: Dimensions.h30,
                              right: Dimensions.h30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.r20),
                              topLeft: Radius.circular(Dimensions.r20),
                              bottomRight: Radius.circular(Dimensions.r20),
                              bottomLeft: Radius.circular(Dimensions.r20),
                            ),
                            color: AppColors.colorBlack,
                          ),
                          child: Row(
                            children: [
                              GetBuilder<LocalizationController>(builder: (localizationController) {
                                return MidText(
                                    text: 'button_confirm'.tr, color: AppColors.colorGreen);
                                //MidText(text: controller.totalAmount.toStringAsFixed(2) + " ₼"),
                              }),
                            ],
                          ),
                        ),
                      )
                    ]))
                  ],
                ));
          },
        ));
  }

  Widget _buildOptionButton(String option, IconData icon) {
    final isActive = option == _selectedOption;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 100,
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedOption = option;
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                backgroundColor: isActive
                    ? MaterialStateProperty.all<Color>(AppColors.colorDisabledG)
                    : MaterialStateProperty.all<Color>(AppColors.colorDisabledB),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  icon,
                  size: 36,
                  color: AppColors.colorGreen,
                ),
                const SizedBox(height: 4),
                DefaultTextStyle(
                  style: const TextStyle(fontSize: 14),
                  child: Text(option),
                ),
              ])),
        ),
      ),
    );
  }

  Widget _clientNameField() {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.h20, right: Dimensions.h20),
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: Dimensions.h10, top: Dimensions.h20, bottom: Dimensions.h5),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name',
                  style: TextStyle(color: AppColors.colorWhite, fontWeight: FontWeight.w300),
                )),
          ),
          Container(
            padding: EdgeInsets.only(
              left: Dimensions.h10,
              top: Dimensions.h5 * 3,
              right: Dimensions.h10,
              bottom: Dimensions.h5 * 3,
            ), // Add padding inside the box decoration
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Add border radius
              border: Border.all(color: AppColors.colorDisabledG), // Add border color
            ),
            child: Row(
              // Wrap the Text and Icons with a Row widget
              children: [
                Icon(Icons.person,
                    color: AppColors.colorGreen), // Add Location icon before the text
                const SizedBox(width: 5), // Add some space between the icon and the text
                Expanded(
                  // Add Expanded to prevent overflow
                  child: Text(
                    Get.find<UserController>().userModel.lastname,
                    maxLines: 1, // Limit the text to one line
                    overflow: TextOverflow.ellipsis, // Add ellipsis when the text is too long
                    style: TextStyle(
                        color: AppColors.colorGreen, fontSize: 16), // Set the text color to white
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Widget _buildNameField() {
  //   return GetBuilder<UserController>(builder: (userController) {
  //     _nameController.text = userController.userModel.lastname;
  //     return Padding(
  //       padding: EdgeInsets.only(left: Dimensions.h20, right: Dimensions.h20),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(
  //                 left: Dimensions.h10, top: Dimensions.h10, bottom: Dimensions.h10 / 2),
  //             child: Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   'Name',
  //                   style: TextStyle(color: AppColors.colorWhite, fontWeight: FontWeight.w300),
  //                 )),
  //           ),
  //           AppTextField(
  //               textController: _nameController,
  //               hintText: _nameController.text,
  //               readOnly: true,
  //               textColor: AppColors.colorGreen,
  //               icon: Icons.person),
  //         ],
  //       ),
  //     );
  //   });
  // }

  Widget _cartInfo() {
    return GetBuilder<CartController>(builder: (_cartController) {
      return _cartController.getItems.isNotEmpty
          ? Column(children: [
              GetBuilder<CartController>(builder: (cartController) {
                var _cartList = cartController.getItems;

                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [
                      Text(
                        _cartController.totalItems.toString(),
                        style: TextStyle(color: AppColors.colorWhite),
                      ),
                      Text(
                        " x ",
                        style: TextStyle(color: AppColors.colorWhite),
                      ),
                      Text(
                        _cartController.totalAmount.toStringAsFixed(2) + " ₼",
                        style: TextStyle(color: AppColors.colorWhite),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //     height: 200,
                  //     child: ListView.builder(
                  //         itemCount: _cartList.length,
                  //         itemBuilder: (_, index) {
                  //           var selectedModifications = _cartList[index].modifications ?? [];
                  //           var modificationNames =
                  //               selectedModifications.map((e) => e['name']).toList();
                  //           return GestureDetector(
                  //               onTap: () {
                  //                 var productIndex = Get.find<ProductsMenuController>()
                  //                     .productsMenu
                  //                     .indexOf(_cartList[index].product!);
                  //                 if (productIndex >= 0) {
                  //                   Get.toNamed(
                  //                       RouteHelper.getProductMenuItem(productIndex, "cartpage"));
                  //                 } else {}
                  //               },
                  //               child: Column(
                  //                 children: [
                  //                   Text(
                  //                     " x " + _cartController.totalItems.toString(),
                  //                     style: TextStyle(color: AppColors.colorWhite),
                  //                   ),
                  //                   Text(
                  //                     " x " + _cartController.totalAmount.toString(),
                  //                     style: TextStyle(color: AppColors.colorWhite),
                  //                   ),
                  //                   Text(
                  //                     _cartController.totalAmount.toStringAsFixed(2) + " ₼",
                  //                     style: TextStyle(color: AppColors.colorWhite),
                  //                   ),
                  //                   Text(
                  //                     " x " + _cartController.getItems[index].quantity.toString(),
                  //                     style: TextStyle(color: AppColors.colorWhite),
                  //                   ),
                  //                   Text(
                  //                     _cartController.getItems[index].productId.toString(),
                  //                     style: TextStyle(color: AppColors.colorWhite),
                  //                   ),
                  //                   Text(
                  //                     _cartController.getItems[index].productName!.tr,
                  //                     style: TextStyle(color: AppColors.colorWhite),
                  //                   ),
                  //                   Text(
                  //                     modificationNames.join(', '),
                  //                     style: TextStyle(color: AppColors.colorWhite),
                  //                   ),
                  //                 ],
                  //               ));
                  //         })),
                );
              }),
            ])
          : GetBuilder<LocalizationController>(builder: (localizationController) {
              return const Text('Cart is empty');
            });
    });
  }

  Widget _buildCommentsField() {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.h20, right: Dimensions.h20),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: Dimensions.h10, top: Dimensions.h10, bottom: Dimensions.h10 / 2),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Comments',
                  style: TextStyle(color: AppColors.colorWhite, fontWeight: FontWeight.w300),
                )),
          ),
          TextField(
            controller: _commentsController,
            style: TextStyle(color: AppColors.colorWhite),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: AppColors.colorWhite),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.h10),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: AppColors.colorGreen,
                  )),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.h10),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: AppColors.colorGreen,
                  )),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.h10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _comments = value;
              });
            },
          ),
        ],
      ),
    );
  }

  bool _isButtonEnabled() {
    if (_selectedOption == "Delivery" ||
        _selectedOption == "In shop" ||
        _selectedOption == "Take away") {
      return true;
    } else {
      return false;
    }
  }
}
