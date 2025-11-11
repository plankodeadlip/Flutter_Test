import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class HomeControllerController extends Controller {
  int counter = 0;

  @override
  bool get singleton => true;

  @override
  construct(BuildContext context) async {
    super.construct(context);
    print("Khởi tạo Home Controller với Counter : $counter");
  }

  void counterIncrease() {
    counter++;
  }

  void counterReset() {
      counter = 0;
  }

  String get counterShow => "Counter : $counter";
}
