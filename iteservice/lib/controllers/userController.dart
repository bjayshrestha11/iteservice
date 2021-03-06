import 'package:get/get.dart';
import 'package:iteservice/controllers/controllers.dart';
import 'package:iteservice/models/dbUser.dart';
import 'package:iteservice/services/firebaseApi.dart';
import 'package:iteservice/utilities/utls.dart';

class UserController extends GetxController {
  Rx<DbUser> dbUser = Rx<DbUser>(
    DbUser(
      name: "IT e-Service",
      username: "074bcsit012.bijay",
      number: null,
      profilePhoto: "",
      email: "074bcsit012.bijay@scst.edu.np",
    ),
  );

  getDbUser(String username)async{
    dbUser.value = await FirebaseApi.getDbUserById(username);
    print("DbUser: ${dbUser.value.name}");
    update();
  }

  @override
  void onInit() {
    String username = Utils.getUsername(Get.find<FirebaseAuthController>().user!.email!);
    getDbUser(username);
    super.onInit();
  }
}
