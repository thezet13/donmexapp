//import 'package:donmexapp/pages/address/widgets/search_location_dialogue_page.dart';
import 'package:donmexapp/base/show_error_snackbar.dart';
import 'package:donmexapp/pages/address/widgets/search_location_dialogue_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/controllers/auth_controller.dart';
import 'package:donmexapp/controllers/location_controller.dart';
import 'package:donmexapp/controllers/navigation_controller.dart';
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
  late GoogleMapController _mapController;
  final TextEditingController _addressController = TextEditingController();

  late bool _userLoggedIn;
  late final SharedPreferences sharedPreferences;
  late final String? _clientId =
      Get.find<AuthController>().authRepo.sharedPreferences.getString('dm_clientId');
  var _clientAddress =
      Get.find<AuthController>().authRepo.sharedPreferences.getString('dm_clientAddress');

  String? _currentAddress;
  Position? _currentPosition;
  String? _currentZone;

  Map<String, List<LatLng>> _polygonsData = {};

  List<LatLng> MyPoints = const [];
  List<LatLng> polygonPoints = const [
    LatLng(40.423307, 49.930280),
  ];

  final LocationController locationController = Get.find<LocationController>();

  Future<void> _getUserCurrentLocation() async {
    print('Getting user current location...');
    try {
      Position currentPosition =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      LatLng currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);

      // Move the map camera to the user's current location
      locationController.mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLatLng, zoom: 19),
        ),
      );

      // Update pick_marker position
      locationController.updatePosition(
        CameraPosition(target: currentLatLng, zoom: 19),
        false,
      );

      //Check if the currentLatLng is inside any of the zones
      String? currentZone = _getCurrentZone(currentLatLng);
      if (currentZone != null) {
        print('You are in $currentZone');
      } else {
        print('You are not in any zone');
      }

      print('Current LatLng: $currentLatLng');
    } catch (e) {
      print(e);
    }
  }

  final TextEditingController _addressControler = TextEditingController();
  CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(40.404561317116496, 49.93065394540004), zoom: 14);

  late LatLng _initialPosition = const LatLng(40.404561317116496, 49.93065394540004);

  //final LocationController locationController = Get.find<LocationController>();

  String mapTheme = '';

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    _getUserCurrentLocation();
    return true;
  }

  String? _getCurrentZone(LatLng point) {
    for (String zoneName in _polygonsData.keys) {
      List<LatLng> zonePolygon = _polygonsData[zoneName]!;
      if (_pointInPolygon(point, zonePolygon)) {
        print('Checking zone $zoneName');

        return zoneName;
      }
    }
    return null;
  }

  bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    bool isInside = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      if (((polygon[i].longitude > point.longitude) != (polygon[j].longitude > point.longitude)) &&
          (point.latitude <
              (polygon[j].latitude - polygon[i].latitude) *
                      (point.longitude - polygon[i].longitude) /
                      (polygon[j].longitude - polygon[i].longitude) +
                  polygon[i].latitude)) {
        isInside = !isInside;
        print('Point inside the polygon: $isInside');
      }
    }
    return isInside;
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    LatLng currentLatLng = cameraPosition.target;

    String? currentZone = _getCurrentZone(currentLatLng);
    _currentZone = currentZone;

    if (currentZone != null) {
      print('You are in $currentZone');
    } else {
      print('You are not in any zone');
    }
  }

  Future<void> _saveCurrentZone() async {
    final prefs = await SharedPreferences.getInstance();
    String zoneId = _currentZone!.replaceAll(RegExp(r'\D'), '');

    print('Zone ID to be saved: $zoneId'); // Add this line

    try {
      await prefs.setString('dm_selectedSpotId', zoneId);
      print('Zone ID saved: $zoneId');
    } catch (e) {
      print('Error saving zone ID: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _userLoggedIn = Get.find<AuthController>().userLoggedIn();

    DefaultAssetBundle.of(context).loadString('assets/maptheme/light_theme.json').then((value) {
      mapTheme = value;
    });

    final prefs = Get.find<AuthController>().authRepo.sharedPreferences;
    final clientId = prefs.getString('dm_clientId');
    final useraddress = prefs.getString('dm_useraddress');
    final lat = prefs.getString('dm_lat');
    print('dm_useraddress' + useraddress.toString());

    // ignore: unnecessary_null_comparison
    if (_userLoggedIn && Get.find<UserController>().userModel == null) {
      Get.find<UserController>().getUserInfo(clientId);
    }

    if (useraddress == null) {
      _handleLocationPermission();
    } else if (useraddress.isNotEmpty && lat != '0.0000000000') {
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
      _handleLocationPermission();
    }

    locationController.fetchPoints().then((zones) {
      setState(() {
        Map<String, List<LatLng>> polygons = {}; // Declare the polygons variable here
        polygons = zones.map((key, points) {
          return MapEntry(
              key, points.map((point) => LatLng(point['latitude'], point['longitude'])).toList());
        });

        // Store the polygons data in the state
        _polygonsData = polygons;
      });
    }).catchError((error) {
      print('Error fetching zones: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: AppColors.colorDarkGreen,
        body: GetBuilder<LocationController>(
          builder: (locationController) {
            _addressControler.text = '${locationController.placemark.name ?? ''}'
                '${locationController.placemark.locality ?? ''}'
                '${locationController.placemark.postalCode ?? ''}'
                '${locationController.placemark.country ?? ''}';

            if (Get.find<LocationController>().addressList.isNotEmpty) {}
            return SafeArea(
              child: SizedBox(
                width: double.maxFinite,
                child: Stack(
                  children: [
                    Container(
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
                              cameraTargetBounds: CameraTargetBounds(
                                LatLngBounds(
                                  northeast: const LatLng(40.44655, 50.00815),
                                  southwest: const LatLng(40.31971, 49.78190),
                                ),
                              ),
                              zoomControlsEnabled: true,
                              minMaxZoomPreference: const MinMaxZoomPreference(1, 22),
                              compassEnabled: false,
                              indoorViewEnabled: false,
                              mapToolbarEnabled: false,
                              myLocationEnabled: true,
                              onCameraIdle: () {
                                locationController.updatePosition(_cameraPosition, true);
                              },
                              onCameraMove: ((position) {
                                _cameraPosition = position;
                                _onCameraMove(position);
                              }),
                              onMapCreated: (GoogleMapController controller) {
                                _mapController = controller;
                                controller.setMapStyle(mapTheme);
                                locationController.setMapController(controller);
                              },
                              polygons: Set<Polygon>.of(
                                _polygonsData.entries.map(
                                  (entry) => Polygon(
                                    polygonId: PolygonId(entry.key),
                                    points: entry.value,
                                    strokeWidth: 0,
                                    fillColor: Color.fromRGBO(0, 175, 122, 0.2),
                                  ),
                                ),
                              ),

                              //   polygons: polygonPoints.isNotEmpty
                              //       ? {
                              //           Polygon(
                              //               polygonId: const PolygonId("1"),
                              //               points: polygonPoints,
                              //               strokeWidth: 0,
                              //               fillColor: Color.fromRGBO(0, 175, 122, 0.2))
                              //         }
                              //       : {},
                              //
                            ),
                            Center(
                              child: !locationController.loading
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 45),
                                      child: Icon(Icons.location_on_sharp,
                                          size: 90, color: AppColors.colorDarkerGreen),
                                    )

                                  // Image.asset(
                                  //     "assets/images/pick_marker2.png",
                                  //     height: 125,
                                  //     width: 125,
                                  //   )
                                  : const CircularProgressIndicator(),
                            ),
                          ],
                        )),
                    Positioned(
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
                    Positioned(
                      top: Dimensions.h20,
                      left: Dimensions.w20,
                      right: Dimensions.w20,
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.colorDarkGreen,
                            borderRadius: BorderRadius.circular(Dimensions.h10)),
                        child: GetBuilder<LocationController>(
                          builder: (locationController) {
                            return AppTextField(
                              textController: _addressControler,
                              hintText: _addressControler.text,
                              textColor: AppColors.colorWhite,
                              icon: Icons.location_on,
                              readOnly: true,
                              // ...
                            );
                          },
                        ),
                        // AppTextField(
                        //   textController: _addressControler,
                        //   hintText: _addressControler.text,
                        //   textColor: AppColors.colorWhite,
                        //   icon: Icons.location_on,
                        //   readOnly: true,
                        // ),
                      ),
                    ),
                    Positioned(
                      top: Dimensions.h30,
                      right: Dimensions.w30,
                      child: GestureDetector(
                          onTap: () {
                            Get.dialog(Location_Dialogue(
                                mapController: _mapController,
                                onAddressSelected: (address) {
                                  setState(() {
                                    _addressController.text = address;
                                  });
                                }));
                          },
                          child: Stack(
                            children: [
                              const Positioned(
                                child: Icon(Icons.lens_rounded,
                                    size: 42, color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              Positioned(
                                left: 9,
                                top: 10,
                                child: Icon(Icons.search, size: 22, color: AppColors.colorGreen),
                              ),
                            ],
                          )),
                    ),
                    Positioned(
                        top: Dimensions.h20 * 3,
                        right: Dimensions.w20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 32),
                            Container(
                              margin: EdgeInsets.all(Dimensions.r10),
                              padding: EdgeInsets.all(Dimensions.r10),
                              decoration: BoxDecoration(
                                color: AppColors.colorWhite,
                                borderRadius: BorderRadius.circular(Dimensions.h20 * 5),
                              ),
                              child: GestureDetector(
                                onTap: _getUserCurrentLocation,
                                // remove the default padding

                                child: Icon(Icons.my_location,
                                    size: 22, color: AppColors.colorDarkerGreen),
                              ),
                            )
                          ],
                        )),
                    Positioned(
                        top: Dimensions.h20 * 3,
                        left: Dimensions.w20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 32),
                            Container(
                              margin: EdgeInsets.all(Dimensions.r10),
                              padding: EdgeInsets.all(Dimensions.r10),
                              decoration: BoxDecoration(
                                color: AppColors.colorBlack,
                                borderRadius: BorderRadius.circular(Dimensions.h20 * 5),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  String previousRoute =
                                      Get.find<NavigationController>().previousRoute.value;
                                  if (previousRoute == 'accountPage') {
                                    Get.toNamed(RouteHelper.getAccountPage());
                                    print('account');
                                  } else if (previousRoute == 'cartOrderPage') {
                                    Get.toNamed(RouteHelper.getCartOrderPage());
                                  } else if (previousRoute == 'selectServiceModeWidget') {
                                    Get.toNamed(RouteHelper.getInitial());
                                  }
                                },
                                // remove the default padding

                                child:
                                    Icon(Icons.close, size: 22, color: AppColors.colorDarkerGreen),
                              ),
                            )
                          ],
                        )),
                    Positioned(
                      bottom: Dimensions.h20,
                      left: Dimensions.w20 * 3,
                      right: Dimensions.w20 * 3,
                      child: locationController.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.colorGreen,
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                if (_userLoggedIn) {
                                  if (_clientAddress == _addressControler.text) {
                                    String previousRoute =
                                        Get.find<NavigationController>().previousRoute.value;
                                    if (previousRoute == 'accountPage') {
                                      Get.toNamed(RouteHelper.getAccountPage());
                                      print('account');
                                    } else if (previousRoute == 'cartOrderPage') {
                                      Get.toNamed(RouteHelper.getCartOrderPage());
                                    } else if (previousRoute == 'selectServiceModeWidget') {
                                      Get.toNamed(RouteHelper.getInitial());
                                    }
                                  } else {
                                    if (_currentZone != null) {
                                      _saveCurrentZone();

                                      final addressId =
                                          await locationController.getClientAddressId();
                                      print('addressID after login:' + addressId.toString());

                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      preferences.setString('dm_lat',
                                          locationController.position.latitude.toString());
                                      preferences.setString(
                                          'dm_clientAddress', _addressControler.text);

                                      print(_clientId);
                                      print(addressId);

                                      AddressModel _addressModel = AddressModel(
                                        addressType: locationController
                                            .addressTypeList[locationController.addressTypeIndex],
                                        address: _addressControler.text,
                                        latitude: locationController.position.latitude.toString(),
                                        longitude: locationController.position.longitude.toString(),
                                        clientId: _clientId,
                                        addressId: addressId,
                                      );

                                      locationController.addAddress(_addressModel).then((response) {
                                        if (response.isSuccess) {
                                          String previousRoute =
                                              Get.find<NavigationController>().previousRoute.value;
                                          if (previousRoute == 'accountPage') {
                                            Get.toNamed(RouteHelper.getAccountPage());
                                            print('account');
                                          } else if (previousRoute == 'cartOrderPage') {
                                            Get.toNamed(RouteHelper.getCartOrderPage());
                                          } else if (previousRoute == 'selectServiceModeWidget') {
                                            Get.toNamed(RouteHelper.getInitial());
                                          }
                                          print(previousRoute);
                                        } else {
                                          // showErrorSnackBar(
                                          //     title: 'sorry'.tr, 'address_not_saved');
                                          Get.toNamed(RouteHelper.getInitial());
                                        }
                                      });
                                    } else {
                                      print('you are not in zone dude');
                                    }
                                  }
                                } else {
                                  Get.toNamed(RouteHelper.signupPage);
                                }
                              },
                              child: _userLoggedIn
                                  ? Container(
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
                                          color: _clientAddress == _addressControler.text
                                              ? AppColors.colorDarkerGreen
                                              : _currentZone != null
                                                  ? AppColors.colorDarkerGreen
                                                  : Colors.grey),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: MidText(
                                                  text: _clientAddress == _addressControler.text
                                                      ? 'button_leave_address'.tr
                                                      : _currentZone != null
                                                          ? 'button_deliver'.tr
                                                          : 'not_in_zone'.tr,
                                                  color: AppColors.colorWhite)),
                                          SizedBox(width: Dimensions.h10),
                                        ],
                                      ),
                                    )
                                  : Container(
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
                                        color: _currentZone != null
                                            ? AppColors.colorDarkerGreen
                                            : Colors.grey,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: MidText(
                                                  text: _currentZone != null
                                                      ? 'button_register'.tr
                                                      : 'not_in_zone'.tr,
                                                  color: AppColors.colorWhite)),
                                          SizedBox(width: Dimensions.h10),
                                        ],
                                      ),
                                    )),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: AppColors.colorDarkGreen,
              title: const Text(
                'Donmex',
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
              content: Text(
                'exit_the_map'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Yes'.tr,
                    style: const TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'No'.tr,
                    style: const TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
    );
  }
}
