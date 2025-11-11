import '/app/controllers/controller.dart';
import 'package:nylo_framework/nylo_framework.dart';
class CartController extends Controller {
  static final CartController _instance = CartController._internal();
  factory CartController() => _instance;
  CartController._internal();

  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  static CartController instance() => _instance;

  void addProduct(Map<String, dynamic> product) {

    if (product['quantity'] <= 0) {
      NyLogger.error("Sản phẩm '${product['name']}' đã hết hàng!");
      return;
    }

    final index =  cart.indexWhere(
            (item) => item['imageIndex'] == product ['imageIndex']);

    if(index != -1){
      cart[index]['quantity'] +=1;
    }else{
      cart.add({
        'name':product['name'],
        'price':product['price'],
        'quantity':1,
        'imageIndex':product['imageIndex'],
      });
    }
    product['quantity'] -= 1;
    NyLogger.info('${product['name']} added to cart!');
  }

  List<Map<String, dynamic>> get items => cart;

}

