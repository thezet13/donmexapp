import 'dart:async';
import 'dart:convert';

import 'package:donmexapp/routes/route_helper.dart';
import 'package:get/get.dart';
import 'package:donmexapp/data/repository/order_repo.dart';
import 'package:donmexapp/models/order_model.dart';
import 'package:donmexapp/models/response_model.dart';
import 'package:get_storage/get_storage.dart';

class OrderController extends GetxController {
  final OrderRepo orderRepo;
  OrderController({required this.orderRepo});
  bool _loading = false;
  bool get loading => _loading;
  Timer? _statusTimer;

  RxString orderStatus = ''.obs;
  RxString transactionId = ''.obs;
  RxString processingStatus = ''.obs;

  Future<ResponseModel> addOrder(OrderModel orderModel) async {
    transactionId.value = '';
    orderStatus.value = '';
    processingStatus.value = '';

    _loading = true;
    update();

    Response response = await orderRepo.addOrder(orderModel);

    late ResponseModel responseModel;

    var responseJson = jsonDecode(jsonEncode(response.body));
    if (response.statusCode == 200) {
      var _orderId = responseJson['response']['incoming_order_id'];

      responseModel = ResponseModel(true, response.statusText!);

      // Fetch and store the updated transaction_id
      int? fetchedTransactionId;
      int? fetchedOrderStatus;
      while (fetchedTransactionId == null && fetchedOrderStatus != 7) {
        Response fetchedTransactionIdResponse =
            await orderRepo.fetchTransactionId(_orderId.toString());
        if (fetchedTransactionIdResponse.statusCode == 200) {
          Map<String, dynamic> jsonResponse = fetchedTransactionIdResponse.body;
          print("jsonResponse: $jsonResponse"); // Print the entire jsonResponse
          fetchedTransactionId = jsonResponse['response']['transaction_id'];
          fetchedOrderStatus = jsonResponse['response']['status'];
          print("Current status order: $fetchedOrderStatus"
              " Current transaction_id: $fetchedTransactionId"); // Print the current transaction_id
        } else {
          print("Failed to fetch updated transaction_id");
        }
        if (fetchedTransactionId == null && fetchedOrderStatus != 7) {
          await Future.delayed(const Duration(seconds: 5));
        }
      }

      transactionId.value = fetchedTransactionId.toString();
      orderStatus.value = fetchedOrderStatus.toString();
      print('transactionId.value: ' + transactionId.value);
      print('orderStatus.value: ' + orderStatus.value);

      void startProcessingStatusUpdates() {
        _statusTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
          if (transactionId.value.isNotEmpty) {
            String? fetchedProcessStatus;
            Response processResponse = await orderRepo.fetchProcessingStatus(transactionId.value);
            if (processResponse.statusCode == 200) {
              Map<String, dynamic> jsonResponse = processResponse.body;
              // print('Current fetchedProcess response: ' + jsonResponse.toString());
              List<dynamic> responseArray = jsonResponse['response'] ?? [];

              if (responseArray.isNotEmpty) {
                fetchedProcessStatus = responseArray[0]['processing_status'];
                processingStatus.value = fetchedProcessStatus.toString();

                // Check if processingStatus is 60 and cancel the timer
                if (int.parse(processingStatus.value) == 60) {
                  timer.cancel();
                  Get.toNamed(RouteHelper.getInitial());
                }
              }
            } else {
              throw Exception('Failed to fetch processing status');
            }
            processingStatus.value = fetchedProcessStatus.toString();
            print('processingStatus.value: ' + processingStatus.value);
          }
        });
      }

      transactionId.value = fetchedTransactionId.toString();

      startProcessingStatusUpdates();
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    super.onClose();
  }
}
