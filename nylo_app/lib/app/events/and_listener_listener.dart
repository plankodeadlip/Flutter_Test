import 'package:nylo_framework/nylo_framework.dart';
import '../controllers/cart_controller.dart';

class AndListenerListener extends NyListener {
  @override
  handle(Map<dynamic, dynamic>? event) async {
    if (event == null) return;

    final product = event['product'];
    if (product != null && product is Map<String, dynamic>) {
      final cartController = CartController.instance();
      cartController.addProduct(product);
    }
  }
}
