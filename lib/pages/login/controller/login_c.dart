import 'package:get/state_manager.dart';
import 'package:xxxcloundclassroom/libspro/getx_untils.dart';

import '../../../compents/common_widgets.dart';
import '../../../config/controller/user_state_controller.dart';
import '../../../config/dataconfig/page_id_config.dart';
import '../../../config/models/user_model.dart';

class Loginc extends GetxController {
  void taplogin() async {
    String msg = '';
    UserModel model = UserModel();
    model.surname = "利剑";
    model.pwd = "123456";
    model.workPermitNum = "123455678";
    configlogin(model: model);
  }

  void configlogin({required UserModel model}) async {
    await UserStateController.current.loadSucess(model);
    showtoastmsg("登陆成功", ontap: () {
      currentTo(name: PageIdConfig.home);
    });
  }
}
