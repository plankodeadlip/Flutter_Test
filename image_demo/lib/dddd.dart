import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GalleryAnimationPage extends StatefulWidget {
  const GalleryAnimationPage({super.key});

  @override
  State<GalleryAnimationPage> createState() => _GalleryAnimationPageState();
}

class _GalleryAnimationPageState extends State<GalleryAnimationPage> {
  final List<Map<String, String>> imagesProperty = [
    {"url":"https://i.pinimg.com/736x/34/21/08/3421088daeee009cf774bbc19a6d56e4.jpg", "title": "Sunset View"},
    {"url":"https://i.pinimg.com/1200x/41/0c/84/410c84fd9ba852b2624b9713be3ac6c8.jpg","title": "Mountain Peak"},
    {"url":"https://i.pinimg.com/736x/16/d8/5a/16d85ac678d0720b46117cc91e984c40.jpg", "title": "Ocean Waves"},
    {"url":"https://i.pinimg.com/736x/93/aa/02/93aa02f8f43d2bae66ffb5721a4dd8f3.jpg", "title": "Forest Path"},
    {"url":"https://i.pinimg.com/736x/eb/12/d8/eb12d807a5a590a645c83579e659a290.jpg", "title": "City Lights"},
    {"url":"https://i.pinimg.com/736x/7a/43/19/7a431950e278e19042a7686f00615b6a.jpg", "title": "Desert Dunes"},
    {"url":"https://i.pinimg.com/736x/80/76/2b/80762bc808916ecb454576ce519976b1.jpg", "title": "Winter Snow"},
    {"url":"https://i.pinimg.com/736x/d2/39/16/d23916fc15fbd3de91ecab3b7bc5011d.jpg", "title": "Spring Bloom"}
  ];

  String? selectedImage;
  String? selectedTitle;
  bool showFull = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showFull
          ? null
          : AppBar(
        title: const Text('Gallery Animation'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Masonry Grid View
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: imagesProperty.length,
              itemBuilder: (context, index)  {
                final image = imagesProperty[index];
                return GestureDetector(
                  onTap: () => _openFullscreen(image["url"]!, image["title"]!),
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
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        image["title"]!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Fullscreen image overlay
          if (selectedImage != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              top: showFull ? 0 : MediaQuery.of(context).size.height,
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showFull ? 1 : 0,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.primaryDelta! > 15) {
                      _closeFullscreen();
                    }
                  },
                  child: Container(
                    color: Colors.white,
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
                          top: 40,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: _closeFullscreen,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.black,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Title overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Text(
                              selectedTitle ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
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

  void _openFullscreen(String imageUrl, String title) {
    setState(() {
      selectedImage = imageUrl;
      selectedTitle = title;
    });
    // Small delay to ensure the widget is built before animating
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        showFull = true;
      });
    });
  }

  void _closeFullscreen() {
    setState(() {
      showFull = false;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        selectedImage = null;
        selectedTitle = null;
      });
    });
  }
}