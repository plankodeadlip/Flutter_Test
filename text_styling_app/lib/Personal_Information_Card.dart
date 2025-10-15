import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class pi_Card extends StatelessWidget {
  const pi_Card({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Personal Information Card',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 350,
            height: 350,// chiều rộng Card
            padding: const EdgeInsets.all(16.0),
            child: const NewBusinessCard(), // nội dung bên trong
          ),
          color: Colors.deepOrange,
        ),
      ),


    );
  }
}

class NewBusinessCard extends StatelessWidget {
  const NewBusinessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> PIContent = [
      {
        'text': 'Trần Huy Hùng',
        'fonts': [GoogleFonts.robotoSlab(), GoogleFonts.archivoBlack()],
        'fontSize': 30.0,
        'fontWeight': FontWeight.bold,
        'color': Colors.black
      },
      {
        'text': 'Học việc',
        'fonts': [GoogleFonts.archivoBlack(), GoogleFonts.robotoSlab()],
        'fontSize': 25.0,
        'fontStyle': FontStyle.italic,
      },
      {
        'text': ' Chỉ là học việc 3 ngày thôi',
        'fonts': [GoogleFonts.archivoBlack(), GoogleFonts.robotoSlab()],
        'fontSize': 20.0,
        'fontStyle': FontStyle.italic,
        'color': Colors.black45,
        'highlight': '3 ngày',
      },
      {
        'text': 'tranhung3q88@gmail.com',
        'fonts': [GoogleFonts.archivoBlack(), GoogleFonts.robotoSlab()],
        'fontSize': 20.0,
        'color': Colors.indigo,
        'decoration': TextDecoration.underline,
      },
    ];

    return ListView.builder(
      shrinkWrap: true, // để ListView không chiếm toàn bộ height
      itemCount: PIContent.length,
      itemBuilder: (context, index) {
        final content = PIContent[index];
        final text = content['text'] as String;
        final fonts = content['fonts'] as List<TextStyle>;
        final words = text.split(' ');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: fonts[1].copyWith(
                    fontSize: content['fontSize'],
                    fontWeight: content['fontWeight'],
                    fontStyle: content['fontStyle'],
                    color: content['color'],
                    decoration: content['decoration'],
                  ),
                ),
        );
      },
    );
  }
}
