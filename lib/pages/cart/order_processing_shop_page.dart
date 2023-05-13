import 'package:donmexapp/routes/route_helper.dart';
import 'package:donmexapp/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:donmexapp/controllers/order_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

class OrderProcessingShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    String getStatusText(String statusValue) {
      switch (statusValue) {
        case '10':
          return 'Accepted';
        case '20':
          return 'Preparing';
        case '30':
          return 'Packing';
        case '40':
          return 'Courier is delivering';
        case '50':
          return 'Delivered';
        case '60':
          return 'Closed';
        default:
          return 'Обрабатывается';
      }
    }

    return WillPopScope(
        onWillPop: () async {
          showExitConfirmation(context);
          return Future.value(false); // Prevent default back button behavior
        },
        child: Scaffold(
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Obx(() {
                if (orderController.orderStatus.value == '7') {
                  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('DENIED', style: TextStyle(color: AppColors.colorWhite, fontSize: 36))
                  ]);
                } else if (orderController.orderStatus.value.isEmpty) {
                  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Ваш заказ обрабатывается',
                        style: TextStyle(color: AppColors.colorWhite, fontSize: 36)),
                    SizedBox(height: 50),
                    CircularProgressIndicator()
                  ]);
                } else {
                  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    orderController.orderStatus.value.isNotEmpty
                        ? Text(
                            "Order status: ${orderController.orderStatus.value}",
                            style: TextStyle(color: AppColors.colorWhite, fontSize: 26),
                          )
                        : CircularProgressIndicator(),
                    orderController.transactionId.value.isNotEmpty
                        ? Text(
                            "Transaction ID: ${orderController.transactionId.value}",
                            style: TextStyle(color: AppColors.colorWhite, fontSize: 26),
                          )
                        : CircularProgressIndicator(),
                    orderController.processingStatus.value.isNotEmpty
                        ? Text(
                            "Processing Status: ${getStatusText(orderController.processingStatus.value)}",
                            style: TextStyle(color: AppColors.colorWhite, fontSize: 26))
                        : CircularProgressIndicator(),
                  ]);
                }
              }),
              const SizedBox(height: 100),
              Obx(() {
                if (orderController.processingStatus.value == '50') {
                  playDeliverySound();
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.initial);
                    },
                    child: Text('close'),
                  );
                } else if (orderController.orderStatus.value == '7') {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.initial);
                    },
                    child: Text('close'),
                  );
                }
                return const Text('');
              })
            ],
          )),
        ));
  }

  void showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.colorDarkGreen,
          title: Text(
            'Donmex'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 23),
          ),
          content: Text(
            'want_to_quit'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Yes'.tr,
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
              onPressed: () {
                // Close the app
                SystemNavigator.pop();

                // Close the confirmation dialog
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                'No'.tr,
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
              onPressed: () {
                // Close the confirmation dialog without performing any action
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  playDeliverySound() async {
    Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000, 500, 1000, 500, 2000]);

    final player = AudioPlayer();
    final audioFile =
        "assets/latin_drums.mp3"; // Replace this with the correct path to your audio file
    await player.setAsset(audioFile);
    await player.play();
  }
}
