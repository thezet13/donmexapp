import 'package:donmexapp/controllers/language_controller.dart';
import 'package:donmexapp/controllers/location_controller.dart';
import 'package:donmexapp/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';

class Location_Dialogue extends StatelessWidget {
  final GoogleMapController mapController;
  final Function(String) onAddressSelected;

  const Location_Dialogue({Key? key, required this.mapController, required this.onAddressSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Container(
      padding: EdgeInsets.all(Dimensions.h10),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.r10)),
        child: SizedBox(
            width: Dimensions.screenWidth,
            child: SizedBox(
                width: Dimensions.screenWidth,
                child: GetBuilder<LocalizationController>(builder: (localizationController) {
                  return SingleChildScrollView(
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _controller,
                          textInputAction: TextInputAction.search,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                              hintText: 'search_location'.tr,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(style: BorderStyle.none, width: 0)),
                              hintStyle: const TextStyle(fontSize: 18))),
                      /*  ***************** */
                      onSuggestionSelected: (Prediction suggestion) {
                        Get.find<LocationController>().setLocation(
                            suggestion.placeId!, suggestion.description!, mapController);
                        Get.find<LocationController>().setSelectedAddress(suggestion.description!);
                        // onAddressSelected(suggestion.description!);
                        // Get.find<LocationController>().setSelectedAddress(suggestion.description!);
                        Get.back();
                      },
                      // onSuggestionSelected: (Prediction suggestion) {
                      //   Get.find<LocationController>().setLocation(
                      //       suggestion.placeId!, suggestion.description!, mapController);
                      //   onAddressSelected(suggestion.description!);
                      //   Get.back();
                      // },
                      suggestionsCallback: (pattern) async {
                        return await Get.find<LocationController>()
                            .searchLocation(context, pattern);
                      },
                      itemBuilder: (context, Prediction suggestion) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: Dimensions.h10,
                            bottom: Dimensions.h5,
                            left: Dimensions.h10,
                          ),
                          child: Row(children: [
                            const Icon(Icons.location_on),
                            Expanded(
                                child: Text(
                              suggestion.description!,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 18),
                            ))
                          ]),
                        );
                      },
                    ),
                  );
                }))),
      ),
    );
  }
}
