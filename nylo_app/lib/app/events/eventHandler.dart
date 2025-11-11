import 'package:nylo_framework/nylo_framework.dart';

class ButtonPressedEvent extends NyEvent {
  final listeners = {
    ButtonPressedListener: ButtonPressedListener(),
  };
}

class ButtonPressedListener extends NyListener {
  handle(dynamic event) async {
    if(event is ButtonPressedEvent) {
      print('Button đã được nhấn');
    }
  }
}
