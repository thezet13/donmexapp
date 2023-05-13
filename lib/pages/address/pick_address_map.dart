import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/base/custom_button.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/controllers/location_controller.dart';
import 'package:donmexapp/models/address_model.dart';
import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';

class PickAddressMap extends StatefulWidget {
  const PickAddressMap(
      {Key? key, required this.fromSignup, required this.fromAddress, this.googleMapController})
      : super(key: key);

  final bool fromSignup;
  final bool fromAddress;
  final GoogleMapController? googleMapController;

  @override
  _PickAddressMapState createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  // ignore: unused_field
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  late final SharedPreferences sharedPreferences;
  late String? _clientId =
      Get.find<AuthController>().authRepo.sharedPreferences.getString('dm_clientId');

  @override
  void initState() {
    super.initState();
    if (Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = LatLng(double.parse(Get.find<LocationController>().getAddress["lat"]),
          double.parse(Get.find<LocationController>().getAddress["lng"]));
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    } else {
      if (Get.find<LocationController>().addressList.isNotEmpty) {
        _initialPosition = LatLng(double.parse(Get.find<LocationController>().getAddress["lat"]),
            double.parse(Get.find<LocationController>().getAddress["lng"]));
        _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      String _currentAddress = '${locationController.pickPlacemark.name ?? ""}';

      return Scaffold(
          body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Stack(
            children: [
              GoogleMap(
                  initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
                  zoomControlsEnabled: false,
                  onCameraMove: (CameraPosition cameraPosition) {
                    _cameraPosition = cameraPosition;
                  },
                  onCameraIdle: () {
                    Get.find<LocationController>().updatePosition(_cameraPosition, false);
                  }),
              Center(
                child: !locationController.loading
                    ? Image.asset(
                        "assets/images/pick_marker.png",
                        height: 50,
                        width: 50,
                      )
                    : CircularProgressIndicator(),
              ),
              Positioned(
                top: Dimensions.h30,
                left: Dimensions.h20,
                right: Dimensions.h20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.h10),
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.colorDarkGreen,
                      borderRadius: BorderRadius.circular(Dimensions.h10)),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 25, color: AppColors.colorOrange),
                      Expanded(
                          child: Text(
                        '${locationController.pickPlacemark.name ?? ""}',
                        style: TextStyle(color: AppColors.colorWhite, fontSize: Dimensions.h20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 50,
                  left: Dimensions.w20,
                  right: Dimensions.w20,
                  child: locationController.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          buttonText: 'Pick Address',
                          onPressed: locationController.loading
                              ? null
                              : () async {
                                  if (widget.fromAddress) {
                                    final addressId = await locationController.getClientAddressId();

                                    print(_clientId);
                                    print(addressId);
                                    print(_currentAddress);
                                    print(locationController.pickPosition.longitude.toString());

                                    AddressModel _addressModel = AddressModel(
                                      addressType: locationController,
                                      address: _currentAddress,
                                      latitude: locationController.pickPosition.latitude.toString(),
                                      longitude:
                                          locationController.pickPosition.longitude.toString(),
                                      clientId: _clientId,
                                      addressId: addressId,
                                    );

                                    locationController.addAddress(_addressModel).then((response) {
                                      if (response.isSuccess) {
                                        // Get.toNamed(RouteHelper.getCartOrderPage());
                                        Get.snackbar("Address", "Added successfully");
                                      } else {
                                        Get.snackbar("Address", "Couldnt save address");
                                      }
                                    });

                                    Get.toNamed(RouteHelper.getCartOrderPage());
                                  } else {
                                    print('but what?');
                                  }
                                },
                        ))
            ],
          ),
        ),
      ));
    });
  }
}
