import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';

class bai5ImageCarousel extends StatefulWidget {
  const bai5ImageCarousel({super.key});

  @override
  State<bai5ImageCarousel> createState() => _bai5ImageCarousel();
}

class _bai5ImageCarousel extends State<bai5ImageCarousel> {
  final List<Map<String, String>> imagesProperty = [
    {
      "url":
          "https://i.pinimg.com/736x/34/21/08/3421088daeee009cf774bbc19a6d56e4.jpg",
      "title": "Potato",
    },
    {
      "url":
          "https://i.pinimg.com/1200x/41/0c/84/410c84fd9ba852b2624b9713be3ac6c8.jpg",
      "title": "Moo Deng",
    },
    {
      "url":
          "https://i.pinimg.com/736x/16/d8/5a/16d85ac678d0720b46117cc91e984c40.jpg",
      "title": "LeChonk",
    },
    {
      "url":
          "https://i.pinimg.com/736x/93/aa/02/93aa02f8f43d2bae66ffb5721a4dd8f3.jpg",
      "title": "Froglet",
    },
    {
      "url":
          "https://i.pinimg.com/736x/eb/12/d8/eb12d807a5a590a645c83579e659a290.jpg",
      "title": "Blink",
    },
    {
      "url":
          "https://i.pinimg.com/736x/7a/43/19/7a431950e278e19042a7686f00615b6a.jpg",
      "title": "Cow Boy",
    },
    {
      "url":
          "https://i.pinimg.com/736x/80/76/2b/80762bc808916ecb454576ce519976b1.jpg",
      "title": "Mask",
    },
    {
      "url":
          "https://i.pinimg.com/736x/d2/39/16/d23916fc15fbd3de91ecab3b7bc5011d.jpg",
      "title": "(..)",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.blue,
            size: 30,
          ),
        ),
        title: Text(
          'Image Carousel',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 4, color: Colors.blue),
              ),
              child: CarouselSlider.builder(
                itemCount: imagesProperty.length,
                itemBuilder: (context, index, realIdx) {
                  final product = imagesProperty[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox.expand(child: Image.network(
                          product["url"]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric( // ⭐ Thêm padding
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            product["title"]!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 2),
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
