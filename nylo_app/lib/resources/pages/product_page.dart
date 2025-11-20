import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ProductPage extends NyStatefulWidget {

  static RouteView path = ("/product", (_) => ProductPage());
  
  ProductPage({super.key}) : super(child: () => _ProductPageState());
}

class _ProductPageState extends NyPage<ProductPage> {

  @override
  get init => () {

  };

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product")
      ),
      body: SafeArea(
         child: Container(),
      ),
    );
  }
}
