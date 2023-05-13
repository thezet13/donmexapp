import 'package:get/get.dart';
import 'package:donmexapp/data/repository/spots_repo.dart';

class SpotsController extends GetxController {
  final SpotsRepo spotsRepo;
  SpotsController({required this.spotsRepo});

  Future<void> getSpots() async {
    Response response = await spotsRepo.getSpots();
    if (response.statusCode == 200) {
      update();
    } else {}
  }
}
