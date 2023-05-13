import 'package:flutter/material.dart';
import 'package:donmexapp/models/spots_model.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/controllers/spots_controller.dart';
import 'package:get/get.dart';

class SpotSelectionBottomSheet extends StatefulWidget {
  final Function(String) onSpotSelected;

  SpotSelectionBottomSheet({required this.onSpotSelected});

  @override
  _SpotSelectionBottomSheetState createState() => _SpotSelectionBottomSheetState();
}

class _SpotSelectionBottomSheetState extends State<SpotSelectionBottomSheet> {
  List<dynamic> spots = [];
  Spot? selectedSpot;

  String? spotName;
  String? spot_id;

  bool firstLoad = true;
  bool isLoading = true;

  Future<void> _initializeSelectedSpot() async {
    if (firstLoad) {
      final prefs = await SharedPreferences.getInstance();
      spotName = prefs.getString('dm_selectedSpotName');
      if (prefs.containsKey('dm_selectedSpotName')) {
        await getSelectedSpotName();
        print('1 ' + spotName.toString());
      } else {
        setState(() {
          selectedSpot = null;
        });
        print('2 ' + spotName.toString());
      }
      firstLoad = false;
    }
  } // Future<void> _initializeSelectedSpot() async {
  //   if (firstLoad) {
  //     final prefs = await SharedPreferences.getInstance();
  //     if (prefs.containsKey('dm_selectedSpotName')) {
  //       await getSelectedSpotName();
  //     }
  //     firstLoad = false;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _loadSpots();
    _initializeSelectedSpot();
    //  getSelectedAddress();
    //  getSelectedSpotName();
  }

  Future<void> _loadSpots() async {
    Response response = await Get.find<SpotsController>().spotsRepo.getSpots();
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> spotsData = response.body['response'];
      await saveSpotIds(spotsData);
      setState(() {
        spots = spotsData.map((spotData) => Spot.fromJson(spotData)).toList();
        isLoading = false;
      });

      getSelectedSpotName();
      getSelectedAddress();
    } else {
      print('Failed to load spots');
    }
  }

  // void _onSpotSelected(String address) {
  //   setState(() {});
  //   widget.onSpotSelected(address);
  // }

  Future<void> saveSpotIds(List<dynamic> spotsData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var spot in spotsData) {
      // String spotId = spot['spot_id'] as String;
      // String address = spot['address'] as String;
      // String spot_name = spot['name'] as String;

      // String spotKey = 'dm_spot$spotId';
      // String addressKey = 'dm_spot${spotId}_address';

      // await prefs.setInt(spotKey, spotId);
      // await prefs.setString(addressKey, address);
    }
  }

  Future<void> saveSelectedSpotId(String spot_id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dm_selectedSpotId', spot_id);
    print(spot_id);
  }

  Future<void> saveSelectedAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dm_selectedAddress', address);
  }

  Future<void> saveSelectedSpotName(String spot_name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dm_selectedSpotName', spot_name);
    print(spot_name);
  }

  Future<void> getSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('dm_selectedAddress');
    if (address != null) {
      setState(() {
        for (var spot in spots) {
          if (spot.address == address) {
            selectedSpot = spot;
            break;
          }
        }
      });
    }
  }

  Future<void> getSelectedSpotName() async {
    final prefs = await SharedPreferences.getInstance();
    String? spot_name = prefs.getString('dm_selectedSpotName');
    if (spot_name != null) {
      setState(() {
        for (var spot in spots) {
          if (spot.spot_name == spot_name) {
            selectedSpot = spot;
            break;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.2,
      padding: EdgeInsets.only(top: Dimensions.h30, left: Dimensions.w10),
      decoration: BoxDecoration(
        color: AppColors.colorDarkGreen3,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.colorGreen))
          : ListView.builder(
              itemCount: spots.length,
              itemBuilder: (BuildContext context, int index) {
                final spot = spots[index];
                final spot_id = spot.spot_id;
                final spot_name = spot.spot_name;
                final address = spot.address;
                //bool isSelected = selectedSpot?.spot_id == spot.spot_id;
                bool isSelected = selectedSpot?.spot_id == spot.spot_id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSpot = spot;
                    });
                    widget.onSpotSelected(spot_name);
                    saveSelectedAddress(address);
                    saveSelectedSpotName(spot_name);
                    saveSelectedSpotId(spot_id);

                    Navigator.pop(context);
                  },
                  child: ListTile(
                    //title: Text('${spot.spot_id}: $address.tr',
                    title: Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.h20, left: Dimensions.w5 * 3, bottom: Dimensions.h20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: Dimensions.w5 * 3),
                            child: spotName != null && isSelected
                                ? Icon(Icons.check_circle, size: 32, color: AppColors.colorWhite)
                                : Icon(Icons.adjust_outlined,
                                    size: 32, color: AppColors.colorGreen),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                spot_name.toString().tr,
                                style: spotName != null && isSelected
                                    ? TextStyle(fontSize: 24, color: AppColors.colorWhite)
                                    : TextStyle(fontSize: 24, color: AppColors.colorGreen),
                                textAlign: TextAlign.left,
                              ),
                              Text(address.toString().tr,
                                  style: spotName != null && isSelected
                                      ? TextStyle(fontSize: 16, color: AppColors.colorWhite)
                                      : TextStyle(fontSize: 16, color: AppColors.colorGreen)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
