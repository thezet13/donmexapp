import 'package:get/get.dart';
import 'package:donmexapp/app_constants.dart';
import 'package:donmexapp/data/api/api_client.dart';
import 'package:donmexapp/models/order_model.dart';

class OrderRepo {
  final PosterApiClient apiClient;
//  final SharedPreferences sharedPreferences;

  OrderRepo({required this.apiClient});

  Future<Response> addOrder(OrderModel orderModel) async {
    try {
      return await apiClient.postData(AppConstants.ADD_ORDER_URI, orderModel.toJson());
    } catch (e) {
      print('from addAdress repo what is error ${e.toString()}');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> fetchTransactionId(String orderId) async {
    try {
      return await apiClient.getData('${AppConstants.GET_ORDER_URI}&incoming_order_id=$orderId');
    } catch (e) {
      print('from order repo error ${e.toString()}');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> fetchProcessingStatus(String transactionId) async {
    try {
      return await apiClient
          .getData('${AppConstants.GET_PROCESS_URI}&transaction_id=$transactionId');
    } catch (e) {
      print('from order repo error ${e.toString()}');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
