import 'package:flutter/material.dart';

class bai3CustomImageBoxFit extends StatelessWidget {
  const bai3CustomImageBoxFit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue, size: 30),
        ),
        title: Text(
          'CUSTOM IMAGE BOXFIT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(20), child:
      Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                boxFitSeperator('Boxfit : Boxfit.cover', BoxFit.cover),
                SizedBox(height: 10),
                boxFitSeperator('Boxfit : Boxfit.contain', BoxFit.contain),
                SizedBox(height: 10),
                boxFitSeperator('Boxfit : Boxfit.fill', BoxFit.fill),
                SizedBox(height: 10),
                boxFitSeperator('Boxfit : Boxfit.fitWidth', BoxFit.fitWidth),
                SizedBox(height: 10),
                boxFitSeperator('Boxfit : Boxfit.fitHeight', BoxFit.fitHeight),
              ],
            )

        ,)),
    );
  }
  Widget boxFitSeperator (String text, BoxFit fitType){
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(23),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.network(
'https://i.pinimg.com/736x/4d/7b/d8/4d7bd8eb669c7473a4aaf8fde252ba20.jpg',
                fit: fitType,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error_outline, color: Colors.red, size: 48),
                  );
                },
              ),
              Positioned(
                top: 12, // khoảng cách từ trên xuống
                left: 12, // khoảng cách từ trái qua
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black, // nền mờ để dễ đọc
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                     text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}

