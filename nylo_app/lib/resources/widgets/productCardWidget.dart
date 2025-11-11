import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/app/controllers/cart_controller.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../app/events/and_listener_event.dart';

class productCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const productCard({super.key, required this.product});

  @override
  State<productCard> createState() => _productCardState();
}

class _productCardState extends State<productCard> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.product['quantity'];
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(width: 2, color: CupertinoColors.activeBlue),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/product${product['imageIndex']}.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(CupertinoIcons.photo, size: 40);
                  },
                ),
              ),
            ),
          ),

          // Phần thông tin sản phẩm và nút thêm giỏ
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${product['price']}",
                    style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantity: $quantity',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),

                  // Nếu còn hàng thì hiển thị nút thêm vào giỏ
                  quantity > 0
                      ? IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    onPressed: () async {
                      // Gửi event AddToCart
                      await event<AndListenerEvent>(data: {
                        'product': product,
                      });

                      // Giảm số lượng
                      setState(() {
                        quantity--;
                        product['quantity'] = quantity;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Đã thêm ${product['name']} vào giỏ hàng!"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(CupertinoIcons.cart_badge_plus),
                  )
                      : const Text(
                    "Đã hết hàng",
                    style: TextStyle(
                      color: CupertinoColors.inactiveGray,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
