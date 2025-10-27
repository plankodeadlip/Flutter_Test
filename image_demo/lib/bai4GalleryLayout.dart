import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class bai4GalleryLayout extends StatefulWidget {
  const bai4GalleryLayout({super.key});

  @override
  State<bai4GalleryLayout> createState() => _bai4GalerryLayout();
}

class _bai4GalerryLayout extends State<bai4GalleryLayout> {
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
  String? selectedImage;
  String? selectedTitle;
  bool showFull = false;
  String userName = 'Tran Huy Hung';
  String userContent = '*Post Content*';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showFull
          ? null
          : AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              title: Text(
                'CUSTOM IMAGE',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8),

            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: imagesProperty.length,
              itemBuilder: (context, index) {
                final image = imagesProperty[index];
                return GestureDetector(
                  onTap: () => onFullScreen(image["url"]!, image["title"]!),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          image["url"]!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error_outline),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        image["title"]!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          if (selectedImage != null)
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              top: showFull ? 0 : MediaQuery.of(context).size.height,
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: showFull ? 1 : 0,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.primaryDelta! > 15) {
                      offFullScreen();
                    }
                  },
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.9),
                    child: Stack(
                      children: [
                        Center(
                          child: InteractiveViewer(
                            child: Image.network(
                              selectedImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: offFullScreen,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 200,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Colors.black, Colors.black.withValues(alpha: 0.5)], begin: AlignmentGeometry.bottomCenter, end: AlignmentGeometry.topCenter),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userName ,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 26,
                                    )
                                ),
                                Text('1 hour ago',style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 18,
                                )),
                                Spacer(),
                                Text(userContent ,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 26,
                                    )
                                ),
                                Text(
                                  selectedTitle ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 30,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void onFullScreen(String imageUrl, String title) {
    setState(() {
      selectedImage = imageUrl;
      selectedTitle = title;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        showFull = true;
      });
    });
  }

  void offFullScreen() {
    setState(() {
      showFull = false;
    });
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        selectedImage = null;
        selectedTitle = null;
      });
    });
  }
}
