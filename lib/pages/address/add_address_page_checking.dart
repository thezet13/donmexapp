import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/controllers/language_controller.dart';
import 'package:donmexapp/controllers/location_controller.dart';
import 'package:donmexapp/controllers/user_controller.dart';
import 'package:donmexapp/models/address_model.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:donmexapp/widgets/app_text_field.dart';
import 'package:donmexapp/widgets/mid_text.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  late bool _userLoggedIn;

  TextEditingController _addressControler = TextEditingController();
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(40.404561317116496, 49.93065394540004), zoom: 14);

  late LatLng _initialPosition = LatLng(40.404561317116496, 49.93065394540004);

  final _clientId = AppConstants.CLIENTID;

  @override
  void initState() {
    super.initState();
    _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    print('initialized');

    final prefs = Get.find<AuthController>().authRepo.sharedPreferences;
    final clientId = prefs.getString(AppConstants.CLIENTID);
//  print('clientId = ' + clientId.toString());

    if (_userLoggedIn) {
      Get.find<UserController>().getUserInfo(clientId);
      print('clientId 1 = ' + clientId.toString());
    }

// ignore: unnecessary_null_comparison
    if (_userLoggedIn && Get.find<UserController>().userModel == null) {
      Get.find<UserController>().getUserInfo(clientId);
      print('clientId 2 = ' + clientId.toString());
    }
    print('UserInfo' + Get.find<UserController>().getUserInfo(clientId).toString());
    print('addressList = ' + Get.find<LocationController>().addressList.toString());

    if (Get.find<LocationController>().addressList.isNotEmpty) {
      /*
  bug fix
  */
      Get.find<LocationController>().getUserAddress();
      print('getUserAddress()' + Get.find<LocationController>().getUserAddress().toString());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.colorDarkGreen,
        appBar: AppBar(
          title: Text("Address page"),
          backgroundColor: AppColors.colorDarkGreen,
        ),
        body: GetBuilder<LocationController>(
          builder: (locationController) {
            _addressControler.text = '${locationController.placemark.name ?? ''}'
                '${locationController.placemark.locality ?? ''}'
                '${locationController.placemark.postalCode ?? ''}'
                '${locationController.placemark.country ?? ''}';

            if (Get.find<LocationController>().addressList.isNotEmpty) {
              _addressControler.text = Get.find<LocationController>().getUserAddress().address;
              print(
                  'getting from getUserA().address: ${locationController.getUserAddress().address}');
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 0, color: Theme.of(context).primaryColor)),
                      child: Stack(
                        children: [
                          GoogleMap(
                              initialCameraPosition:
                                  CameraPosition(target: _initialPosition, zoom: 17),
                              zoomControlsEnabled: true,
                              compassEnabled: false,
                              indoorViewEnabled: true,
                              mapToolbarEnabled: false,
                              myLocationEnabled: true,
                              onCameraIdle: () {
                                locationController.updatePosition(_cameraPosition, true);
                              },
                              onCameraMove: ((position) => _cameraPosition = position),
                              onMapCreated: (GoogleMapController controller) {
                                locationController.setMapController(controller);
                              })
                        ],
                      )),
                  SizedBox(
                    height: Dimensions.h20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.h20, left: Dimensions.h10 / 5),
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
                                        border: Border.all(width: 1, color: AppColors.colorGreen),
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
                  SizedBox(
                    height: Dimensions.h20,
                  ),
                  SizedBox(
                    height: Dimensions.h20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.h30, right: Dimensions.h20),
                    child: MidText(text: "Delivery address"),
                  ),
                  SizedBox(
                    height: Dimensions.h20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.h20, right: Dimensions.h20),
                    child: AppTextField(
                        textController: _addressControler,
                        hintText: _addressControler.text,
                        icon: Icons.location_on,
                        readOnly: false,
                        textColor: AppColors.colorWhite),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: GetBuilder<LocationController>(
          builder: (locationController) {
            return Container(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                margin: EdgeInsets.only(left: 0, right: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  //color:  Color.fromARGB(255, 0, 120, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.only(
                            top: Dimensions.h10,
                            bottom: Dimensions.h10,
                            left: Dimensions.h10,
                            right: Dimensions.h10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(Dimensions.r20),
                            topLeft: Radius.circular(Dimensions.r20),
                            bottomRight: Radius.circular(Dimensions.r20),
                            bottomLeft: Radius.circular(Dimensions.r20),
                          ),
                          color: AppColors.colorBlack,
                        ),
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              AddressModel _addressModel = AddressModel(
                                addressType: locationController
                                    .addressTypeList[locationController.addressTypeIndex],
                                address: _addressControler.text,
                                latitude: locationController.position.latitude.toString(),
                                longitude: locationController.position.longitude.toString(),
                                clientId: _clientId,
                              );
                              locationController.addAddress(_addressModel).then((response) {
                                if (response.isSuccess) {
                                  Get.toNamed(RouteHelper.initial);
                                  Get.snackbar("Address", "Added successfully");
                                } else {
                                  Get.snackbar("Address", "Couldnt save address");
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: Dimensions.h20,
                                  bottom: Dimensions.h20,
                                  left: Dimensions.h20,
                                  right: Dimensions.h20),
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
                                  GetBuilder<LocalizationController>(
                                      builder: (localizationController) {
                                    return MidText(
                                        text: 'button_save'.tr, color: AppColors.colorGreen);
                                    //MidText(text: controller.totalAmount.toStringAsFixed(2) + " ₼"),
                                  }),
                                  SizedBox(width: Dimensions.h10),
                                ],
                              ),
                            ),
                          ),
                        ]))
                  ],
                ));
          },
        ));
  }
}
