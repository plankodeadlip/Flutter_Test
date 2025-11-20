import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/cupertino.dart';

import '../../app/controllers/cart_controller.dart';
import '../../app/events/and_listener_event.dart';
import '../widgets/productCardWidget.dart';

class CartPage extends NyStatefulWidget {
  static RouteView path = ("/cart", (_) => CartPage());

  CartPage({super.key}) : super(child: () => _CartPageState());

  @override
  createState() => _CartPageState();
}

class _CartPageState extends NyPage<CartPage> {
  final cartController = CartController.instance();

  @override
  Widget view(BuildContext context) {
    final items = cartController.cart;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Cart',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
      child: SafeArea(
        child: items.isEmpty
            // 🧺 Nếu giỏ hàng trống
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.cart,
                      size: 80,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Giỏ hàng trống',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hãy thêm vài sản phẩm để bắt đầu mua sắm!',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.systemGrey2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.7),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return productCard(product: items[index], isAdded: true);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
