import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class bai5EComerce extends StatefulWidget {
  const bai5EComerce({super.key});

  @override
  State<bai5EComerce> createState() => _bai5EComerceState();
}

class _bai5EComerceState extends State<bai5EComerce> {
  final List<Map<String, dynamic>> _products = const [
    {
      'name': 'ABS POWER 120TI',
      'description':
          'Tối đa 15kg. Công Nghệ Hi-Tech tăng cường 4 vị trí trên khung vợt, chịu va đập tốt hơn. ',
      'price': '2.300.000₫',
      'reviews': 200,
      'imageIndex': 1,
    },
    {
      'name': 'AMG 63',
      'description':
          'Tối đa 10,9kg. Phân khúc vợt cao cấp, chất liệu chịu lực, chịu niệt tốt. Dành cho người chơi cao cấp.',
      'price': '2.600.000₫',
      'reviews': 50,
      'imageIndex': 2,
    },
    {
      'name': 'AMG 61 RED',
      'description':
          'Tối đa 12kg.Màu bạc đỏ. Giá tầm trung nhưng mang nhiều công nghệ của vợt tầm cao cấp.',
      'price': '1.530.000₫',
      'reviews': 200,
      'imageIndex': 3,
    },
    {
      'name': 'AMG 61 BLACK',
      'description':
          'Tối đa 12kg.Màu bạc đen + đỏ. Giá tầm trung nhưng mang nhiều công nghệ của vợt tầm cao cấp.',
      'price': '1.530.000₫',
      'reviews': 100,
      'imageIndex': 4,
    },
    {
      'name': 'TI DREAM',
      'description':
          'Tối đa 15kg. Thiên công,. Vật liệu sợi Titanium, siêu bền, siêu nhẹ. Lựa chọn của vận động viên.',
      'price': '2.500.000₫',
      'reviews': 52,
      'imageIndex': 5,
    },
    {
      'name': 'SABRE 18',
      'description': 'Tối đa 15kg. Nhẹ nhàng và dẻo dai, vừa công vừa thủ',
      'price': '1.800.000₫',
      'reviews': 98,
      'imageIndex': 6,
    },
    {
      'name': 'PLATINUM 510',
      'description':
          'Tối đa 15kg. Độ bền co, chịu lực tốt hơn những loại vợt thông thường',
      'price': '1.950.000₫',
      'reviews': 150,
      'imageIndex': 7,
    },
    {
      'name': 'VORTEX 70',
      'description':
          'Tối đa 15kg. High Elasticity Carbon Graphite Composite tạo nên sự bền bỉ và linh hoạt cho khung vợt',
      'price': '1.380.000₫',
      'reviews': 620,
      'imageIndex': 8,
    },
    {
      'name': 'NANO 6600',
      'description':
          'Tối đa 15kg. Sản xuất trên công nghệ Nano, chất liệu Carbon siêu bền. Dành cho người chơi chuyên nghiệp',
      'price': '1.340.000₫',
      'reviews': 310,
      'imageIndex': 9,
    },
    {
      'name': 'TGR 900',
      'description':
          'Tối đa 15kg. High Elasticity Carbon Graphite Composite tạo nên sự bền bỉ và linh hoạt cho khung vợt',
      'price': '1.150.000₫',
      'reviews': 310,
      'imageIndex': 10,
    },
    {
      'name': 'S.D.S 500',
      'description':
          'Tối đa 15kg. Màu sắc nổi bật. Thiết kế siêu nhẹ, thân vợt dẻo dai linh hoạt',
      'price': '1.500.000₫',
      'reviews': 310,
      'imageIndex': 11,
    },
    {
      'name': 'SWEET  SPOOT 800',
      'description':
          'Tối đa 15kg. Tính năng linh hoạt, dẽ kiểm soát tốc độ cầu. Phù hợp cho người mới',
      'price': '955.000₫',
      'reviews': 310,
      'imageIndex': 12,
    },
  ];

  late List<Map<String, dynamic>> displayedProducts;

  @override
  void initState() {
    super.initState();
    displayedProducts = List.from(_products); // ban đầu hiển thị tất cả
  }

  // 🔹 Hàm lọc sản phẩm "Hot Racquet"
  void showHotRacquet() {
    setState(() {
      displayedProducts = _products
          .where(
            (p) =>
                p['imageIndex'] == 1 ||
                p['imageIndex'] == 2 ||
                p['imageIndex'] == 12,
          )
          .toList();
    });
  }

  void showAll() {
    setState(() {
      displayedProducts = List.from(_products);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 THANH TÌM KIẾM
              Padding(
                padding: EdgeInsets.all(16),
                child: CupertinoSearchTextField(
                  placeholder: 'Search for racquets...',
                ),
              ),

              // 🔹 DANH MỤC CUỘN NGANG
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      categoryCard(
                        'SWEETSPOT',
                        CupertinoIcons.wand_stars,
                        CupertinoColors.destructiveRed,
                      ),
                      SizedBox(width: 12),
                      categoryCard(
                        'AMG',
                        Icons.account_balance_wallet,
                        CupertinoColors.black,
                      ),
                      SizedBox(width: 12),
                      categoryCard(
                        'ABS',
                        Icons.accessible_forward,
                        CupertinoColors.systemOrange,
                      ),
                      SizedBox(width: 12),
                      categoryCard(
                        'PLATINUM',
                        Icons.accessible_forward,
                        Colors.greenAccent,
                      ),
                      SizedBox(width: 12),
                      categoryCard(
                        'VORTEX',
                        CupertinoIcons.rhombus,
                        Colors.deepPurple,
                      ),
                      SizedBox(width: 12),
                      categoryCard(
                        'NANO',
                        CupertinoIcons.eye_slash,
                        Colors.pink,
                      ),
                      categoryCard(
                        'OTHERS',
                        CupertinoIcons.delete_simple,
                        CupertinoColors.systemGrey,
                      ),
                      SizedBox(width: 12),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 TIÊU ĐỀ
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      onPressed: showHotRacquet,
                      child: const Text(
                        'HOT RACQUET',
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      onPressed: showAll,
                      child: const Text(
                        'All',
                        style: TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 GRID SẢN PHẨM
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.59,
                ),
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  final product = displayedProducts[index];
                  final imagePath =
                      'assets/images/product${product['imageIndex']}.png';

                  return productCard(
                    imagePath,
                    product['name'] as String,
                    product['description'] as String,
                    product['price'] as String,
                    product['reviews'] as int,
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CupertinoButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: CupertinoColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard(
    String imagePath,
    String name,
    String description,
    String price,
    int reviews,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 5, color: CupertinoColors.activeBlue),
        ),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🖼 Ảnh sản phẩm
              Padding(
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    width: 140,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('❌ Error loading image: $error');
                      return Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey4,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          CupertinoIcons.photo,
                          size: 40,
                          color: CupertinoColors.systemGrey3,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 📄 Nội dung sản phẩm
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: CupertinoColors.label,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // 💰 Giá
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: CupertinoColors.systemRed,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // ⭐ Review
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          CupertinoIcons.star_fill,
                          color: CupertinoColors.systemYellow,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '($reviews)',
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Icon(
                            CupertinoIcons.heart,
                            color: CupertinoColors.systemGrey2,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ❤️ Icon yêu thích
            ],
          ),
        ),
      ),
    );
  }
}
