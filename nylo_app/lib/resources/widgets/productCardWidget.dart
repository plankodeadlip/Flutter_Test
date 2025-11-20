import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../app/events/and_listener_event.dart';

class productCard extends StatefulWidget {
  final Map<String, dynamic> product;

  final bool isAdded ;


  const productCard({super.key, required this.product, required this.isAdded});

  @override
  State<productCard> createState() => _productCardState();
}

class _productCardState extends State<productCard> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.product['quantity'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    bool isAdd = widget.isAdded;
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(width: 1.5, color: CupertinoColors.activeBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ///-------------------------IMAGE------------------------------
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/product${product['imageIndex']}.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                     const Center( child:Icon(CupertinoIcons.photo, size: 40)),

                ),
            ),
          ),

          const SizedBox(height: 4),
          // Phần thông tin sản phẩm và nút thêm giỏ
          //------------------NAME---------------------------
          Text(
            product['name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
          ),
          SizedBox(height: 4),
          ///-------------------PRICE-------------------------
          Text(
            '\$${product['price']}',
            style: TextStyle(
              color: CupertinoColors.systemRed,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          ///--------------------QUANTITY--------------------
          Text(
            'Quantity: $quantity',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          ///----------------------BUTTON---------------------
          !isAdd
              ? (quantity > 0)
                ? SizedBox(
            child: CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 6),
              borderRadius: BorderRadius.circular(10),
              onPressed: () async {
                await event<AndListenerEvent>(data: {'product': product});
                setState(() {
                  quantity --;
                  product['quantity'] = quantity;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Đã thêm ${product['name']} vào giỏ hàng!"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Icon(CupertinoIcons.cart_badge_plus, size: 20),
            ),
          )
              :Text(
            "Đã hết hàng",
            style: TextStyle(
              color: CupertinoColors.inactiveGray,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
              : SizedBox()
        ],
      ),
    );
  }
}
