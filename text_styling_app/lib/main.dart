import 'package:flutter/material.dart';
import 'package:text_styling_app/Personal_Information_Card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TextStylingScreen());
  }
}

class TextStylingScreen extends StatefulWidget {
  @override
  State<TextStylingScreen> createState() => _TextStylingScreenState();
}

class _TextStylingScreenState extends State<TextStylingScreen> {
  final TextStyle baseStyle = const TextStyle(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Styling Co Them ListVIew'),
        centerTitle: true ,
        backgroundColor: Colors.deepPurple,
      ),
      body: const myListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const pi_Card()));
        },
        label: Text('Personal Information', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
 class myListView extends StatelessWidget{
  const myListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listViewContent = [
      {
        'text':'Tram nam trong coi nguoi ta,',
        'fontSize': 25.0,
      },
      {
        'text':'Chu tai chu menh kheo la ghet nhau.',
        'fontSize':25.0,
        'fontWeight': FontWeight.bold,
      },
      {
        'text':'Trai qua mot cuoc be dau,',
        'fontSize':25.0,
        'fontStyle': FontStyle.italic,
      },
      {
        'text':'Nhung dieu trong thay ma dau don long.',
        'fontSize':25.0,
        'decoration':TextDecoration.underline,
      },
      {
        'text':'La gi bi sac tu vong,',
        'fontSize':25.0,
        'decoration': TextDecoration.lineThrough,
      },
      {
        'text':'Troi xanh quen thoi ma hong danh ghen.',
        'fontSize': 25.0,
        'colors' : [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple, Colors.black],
      },
      {
        'text':'Cao thom lan gio truoc den,',
        'fontSize':25.0,
        'backgroundColor':Colors.black54,
        'color':Colors.white38,
      },
      {
        'text':'Phong tinh co luc con truyen su xanh.',
        'fontSize':25.0,
        'shadow': [
          Shadow(
            color:Colors.black,
            offset: Offset(2, 2),
            blurRadius: 8.0
          )
        ],
        'backgroundColor':Colors.black12
      },
      {
        'text': 'Rang nam Gia Tinh trieu Minh,',
        'fontSize':25.0,
        'letterSpacing': 3.0
      },
      {
        'text': 'Bon phuon phang lang, hai kinh vung vang.',
        'fontSize':25.0,
        'wordSpacing':10.0
      },
    ];
    return ListView.builder(
      itemCount: listViewContent.length,
      itemBuilder: (context, index){
        final content = listViewContent[index];
        final text = content['text'] as String;
        final colors = content['colors'];
        if (colors != null && colors is List<Color>){
          final words = text.split(' ');
          return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RichText(
              text: TextSpan(
                children: [
                  for(int i = 0; i< words.length;i++)
                    TextSpan(
                      text: '${words[i]}',
                      style: TextStyle(
                        color: colors[i % colors.length],
                        fontSize: content['fontSize'],
                        fontWeight: content['fontWeight'],
                        fontStyle: content['fontStyle'],
                        decoration: content['decoretion'],
                        backgroundColor: content['backgroundColor'],
                        letterSpacing: content['letterSpacing'],
                        wordSpacing: content['wordSpacing'],
                        shadows: content['shadow'],
                      )
                    )
                ]
              ),
            )

          );
        }else{
          return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
                text,
              style: TextStyle(
                fontSize: content['fontSize'],
                fontWeight: content['fontWeight'],
                fontStyle: content['fontStyle'],
                decoration: content['decoretion'],
                color: content['color'],
                backgroundColor: content['backgroundColor'],
                letterSpacing: content['letterSpacing'],
                wordSpacing: content['wordSpacing'],
                shadows: content['shadow'],
              ),
            ),
          );
        }
      },

    );
  }
 }