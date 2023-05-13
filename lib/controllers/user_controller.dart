import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donmexapp/data/repository/user_repo.dart';
import 'package:donmexapp/models/response_model.dart';
import 'package:donmexapp/models/user_model.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({required this.userRepo});

  bool _isLoading = false;
  late UserModel _userModel;

  bool get isLoading => _isLoading;
  UserModel get userModel => _userModel;

  Future<ResponseModel> getUserInfo(clientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final clientId = prefs.getString('dm_clientId');

    Response response = await userRepo.getUserInfo(clientId!);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      _userModel = UserModel.fromJson(response.body);
      print('user firstname: ' + _userModel.firstname.toString());

      print('user lastname: ' + _userModel.lastname.toString());
      print('user addressId: ' + _userModel.addressId.toString());
      print('user address: ' + _userModel.address.toString());

      prefs.setString('dm_clientAddress', _userModel.address);

      _isLoading = true;
      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }
}
