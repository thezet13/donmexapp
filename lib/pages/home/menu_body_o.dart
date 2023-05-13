// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shop/controllers/products_menu_controller.dart';
// import 'package:shop/routes/route_helper.dart';
// import 'package:shop/utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shop/utils/dimensions.dart';
// import 'package:shop/widgets/bottom_sheet_widget.dart';
// import 'package:shop/widgets/categories_with_products.dart';
// import 'package:shop/widgets/top_bar_status.dart';
// import '../../app_constants.dart';

// class MenuBody extends StatefulWidget {
//   final VoidCallback toAccountPage;

//   MenuBody({Key? key, required this.toAccountPage}) : super(key: key);

//   @override
//   State<MenuBody> createState() => _MenuBodyState();
// }

// class _MenuBodyState extends State<MenuBody> {
//   final GlobalKey<TopBarStatusState> topBarStatusKey = GlobalKey<TopBarStatusState>();

//   get height => null;
//   PageController pageController = PageController(viewportFraction: 0.95);

//   String? _serviceMode;
//   //ValueNotifier<String> dmServiceModeNotifier = ValueNotifier<String>('');

//   Future<void> _loadServiceMode() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _serviceMode = prefs.getString('dm_serviceMode');
//       //dmServiceModeNotifier.value = prefs.getString('dm_serviceMode') ?? '';
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     _loadServiceMode();

//     _serviceMode = Get.find<SharedPreferences>().getString('dm_serviceMode');
//     if (_serviceMode == null || _serviceMode!.isEmpty) {
//       showBottomSheetWidget();
//     } else {
//       print('service mode: ' + _serviceMode.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//               height: MediaQuery.of(context).viewPadding.top + 5,
//               width: MediaQuery.of(context).size.width,
//               child: SizedBox(height: MediaQuery.of(context).viewPadding.top)),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             GetBuilder<ProductsMenuController>(builder: (controller) {
//               return GestureDetector(
//                   onTap: widget.toAccountPage,
//                   child: Container(
//                     padding: EdgeInsets.only(
//                       left: Dimensions.w5 * 3,
//                       right: Dimensions.w5 * 3.7,
//                       top: Dimensions.h5 * 3.7,
//                       bottom: Dimensions.h5 * 3.7,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(0),
//                         bottomLeft: Radius.circular(0),
//                         topRight: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//                       color: AppColors.colorDarkestGreen,
//                     ),
//                     child: Icon(Icons.person, size: 32, color: AppColors.colorGreen),
//                   ));
//             }),
//             //
//             GestureDetector(
//               onTap: () {
//                 print('GestureDetector onTap triggered');
//                 //openOptionsBottomSheet();
//               },
//               child: Container(
//                 width: Dimensions.w20 * 11,
//                 height: Dimensions.w5 * 15,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     bottomLeft: Radius.circular(10),
//                     topRight: Radius.circular(10),
//                     bottomRight: Radius.circular(10),
//                   ),
//                   color: AppColors.colorBlack,
//                 ),
//                 child: Padding(
//                     padding: EdgeInsets.only(
//                       left: Dimensions.w20,
//                       right: Dimensions.w20,
//                       top: Dimensions.h10,
//                       bottom: Dimensions.h5 * 3,
//                     ),
//                     child: TopBarStatus(key: topBarStatusKey)),
//               ),
//             ),
//             GetBuilder<ProductsMenuController>(builder: (controller) {
//               return GestureDetector(
//                 onTap: () {
//                   if (controller.totalItems >= 1) Get.toNamed(RouteHelper.getCartPage());
//                 },
//                 child: Container(
//                   padding: EdgeInsets.only(
//                     left: Dimensions.w5 * 3,
//                     right: Dimensions.w5 * 3,
//                     top: Dimensions.h5 * 3,
//                     bottom: Dimensions.h5 * 3,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       bottomLeft: Radius.circular(10),
//                       topRight: Radius.circular(0),
//                       bottomRight: Radius.circular(0),
//                     ),
//                     color: AppColors.colorDarkestGreen,
//                   ),
//                   child: Stack(children: [
//                     Icon(
//                       Icons.shopping_bag_outlined,
//                       size: 42,
//                       color: AppColors.colorOrange,
//                     ),
//                     controller.totalItems >= 1
//                         ? Positioned(
//                             left: 0,
//                             top: 0,
//                             child: Icon(Icons.circle, size: 32, color: AppColors.colorOrange))
//                         : //empty cart
//                         Container(),
//                     controller.totalItems >= 1
//                         ? Positioned(
//                             left: 10,
//                             top: 5,
//                             child: Text(Get.find<ProductsMenuController>().totalItems.toString(),
//                                 style: TextStyle(fontSize: 18, color: AppColors.colorWhite)))
//                         : //empty cart
//                         Container(),
//                   ]),
//                 ),
//               );
//             })
//           ]),
//           SizedBox(height: 30),
//           GetBuilder<ProductsMenuController>(builder: (theProduct) {
//             return theProduct.isLoaded
//                 ? Column(
//                     children: [
//                       CategoryWithProducts(categoryName: 'Burritos'),
//                       CategoryWithProducts(categoryName: 'Bowls'),
//                     ],
//                   )
//                 : Center(child: CircularProgressIndicator(color: AppColors.colorDarkGreen));
//           }),
//         ],
//       ),
//     );
//   }

//   // void showBottomSheetWidget() {
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     showModalBottomSheet(
//   //       context: context,
//   //       backgroundColor: Colors.transparent,
//   //       builder: (BuildContext context) => BottomSheetWidget(),
//   //       isScrollControlled: true,
//   //       shape: RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//   //       ),
//   //     );
//   //   });
//   // }
//   void showBottomSheetWidget() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) => BottomSheetWidget(
//           onOptionSelected: (option) {
//             topBarStatusKey.currentState!.updateServiceMode(option);
//           },
//         ),
//         isScrollControlled: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//       );
//     });
//   }

//   void openOptionsBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) => BottomSheetWidget(
//         onOptionSelected: (option) {
//           topBarStatusKey.currentState!.updateServiceMode(option);
//         },
//       ),
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//     );
//   }

// // ignore: unused_element
//   Widget _buildPageItem(int index, productsList) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             Get.toNamed(RouteHelper.getProductMenuItem(index, "home"));
//           },
//           child: Container(
//             height: 250,
//             margin: EdgeInsets.only(left: 5, right: 5),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: NetworkImage(AppConstants.BASE_URL + productsList.photoOrigin!),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
