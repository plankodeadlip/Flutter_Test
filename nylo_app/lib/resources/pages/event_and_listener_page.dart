import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/cupertino.dart';

import '../../app/events/and_listener_event.dart';
import '../widgets/productCardWidget.dart';
import 'cart_page.dart';

class EventAndListenerPage extends NyStatefulWidget {
  static RouteView path = ("/profile", (_) => EventAndListenerPage());

  EventAndListenerPage({super.key}) : super(child: () => _EventAndListenerPageState());

  @override
  createState() => _EventAndListenerPageState();
}

class _EventAndListenerPageState extends NyPage<EventAndListenerPage> {
   List<Map<String, dynamic>> _products =  [
    {
      'name': 'ABS POWER 120TI',
      'quantity':3,
      'price': '2.300.000₫',
      'reviews': 200,
      'imageIndex': 1,
    },
    {
      'name': 'AMG 63',
      'quantity':9,
      'price': '2.600.000₫',
      'reviews': 50,
      'imageIndex': 2,
    },
    {
      'name': 'AMG 61 RED',
      'quantity':53,
      'price': '1.530.000₫',
      'reviews': 200,
      'imageIndex': 3,
    },
    {
      'name': 'AMG 61 BLACK',
      'quantity':2,
      'price': '1.530.000₫',
      'reviews': 100,
      'imageIndex': 4,
    },
    {
      'name': 'TI DREAM',
      'quantity':53,
      'price': '2.500.000₫',
      'reviews': 52,
      'imageIndex': 5,
    },
    {
      'name': 'SABRE 18',
      'quantity':12,
      'price': '1.800.000₫',
      'reviews': 98,
      'imageIndex': 6,
    },
    {
      'name': 'PLATINUM 510',
      'quantity':7,
      'price': '1.950.000₫',
      'reviews': 150,
      'imageIndex': 7,
    },
    {
      'name': 'VORTEX 70',
      'quantity':12,
      'price': '1.380.000₫',
      'reviews': 620,
      'imageIndex': 8,
    },
    {
      'name': 'NANO 6600',
      'quantity':14,
      'price': '1.340.000₫',
      'reviews': 310,
      'imageIndex': 9,
    },
    {
      'name': 'TGR 900',
      'quantity':74,
      'price': '1.150.000₫',
      'reviews': 310,
      'imageIndex': 10,
    },
    {
      'name': 'S.D.S 500',
      'quantity':13,
      'price': '1.500.000₫',
      'reviews': 310,
      'imageIndex': 11,
    },
    {
      'name': 'SWEET  SPOOT 800',
      'quantity':200,
      'price': '955.000₫',
      'reviews': 310,
      'imageIndex': 12,
    },
  ];

   bool isMainPage = true;


  @override
  Widget view(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'E-COMERCE',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.activeBlue,
            ),
          ),
          trailing: IconButton(
              onPressed: (){
                updateState((){});
                routeTo(CartPage.path);
              }, 
              icon: Icon(CupertinoIcons.cart, color: CupertinoColors.activeBlue, size: 25,)
          ),
        ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.6
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return productCard(
                    product: _products[index],
                    isAdded: false,
                  );
                },
              ),
            ),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }

}

