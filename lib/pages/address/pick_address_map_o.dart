import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:donmexapp/base/custom_button.dart';
import 'package:donmexapp/controllers/location_controller.dart';
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

  @override
  void initState() {
    super.initState();
    // if (Get.find<LocationController>().addressList.isEmpty) {
    //   _initialPosition = LatLng(40.404561317116496, 49.93065394540004);
    //   _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
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
                              : () {
                                  if (locationController.pickPosition.latitude != 0 &&
                                      locationController.pickPlacemark.name != null) {
                                    if (widget.fromAddress) {
                                      if (widget.googleMapController != null) {
                                        print('clicked on this');
                                        widget.googleMapController!.moveCamera(
                                            CameraUpdate.newCameraPosition(CameraPosition(
                                                target: LatLng(
                                          locationController.pickPosition.latitude,
                                          locationController.pickPosition.longitude,
                                        ))));
                                        locationController.setAddressData();
                                      }
                                      Get.toNamed(RouteHelper.getCartOrderPage());
                                    } else {
                                      print('but what?');
                                    }
                                  }
                                },
                        )
                  // child: locationController.isLoading?Center(child: CircularProgressIndicator(),): CustomButton(
                  //   buttonText: locationController.inZone?widget.fromAddress?'Pick Address':'Pick Location':'Service is not available',
                  //   onPressed: (locationController.buttonDisabled||locationController.loading)?null:(){
                  //     if(locationController.pickPosition.latitude!=0&&
                  //     locationController.pickPlacemark.name!=null){
                  //       if(widget.fromAddress){
                  //         if(widget.googleMapController!=null){
                  //           print('clicked on this');
                  //           widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                  //             locationController.pickPosition.latitude,
                  //             locationController.pickPosition.longitude,
                  //           ))));
                  //           locationController.setAddressData();
                  //         }
                  //         Get.toNamed(RouteHelper.getAddressPage());
                  //       }
                  //     }
                  //   },
                  // )

                  )
            ],
          ),
        ),
      ));
    });
  }
}
