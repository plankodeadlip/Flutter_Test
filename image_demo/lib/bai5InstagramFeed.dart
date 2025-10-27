import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class bai5InstagramFeed extends StatelessWidget {
  const bai5InstagramFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = 'Tran Huy Hung';
    final String postContent = 'Hello World!';
    final String likeCount = '23K';
    final String cmtCount = '138';
    final String rtwCount = '1.462';
    final String shareCount = '1.873';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Color(0xFF833AB4),
                Color(0xFFFD1D1D),
                Color(0xFFF56040),
                Color(0xFFFFDC80),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ).createShader(bounds);
          },
          child: Text(
            'Instagram Feed',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF833AB4),
                  Color(0xFFFD1D1D),
                  Color(0xFFF56040),
                  Color(0xFFFFDC80),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                'assets/images/avatar.png',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.music_note_2,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Tháng Tư Là Lời Nói Dối Của Em',
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Image.network(
                      'https://i.pinimg.com/736x/eb/12/d8/eb12d807a5a590a645c83579e659a290.jpg',
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 6),
                    Text(postContent, style: TextStyle(fontSize: 18, color: Colors.white),),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildItem(likeCount, icon: CupertinoIcons.heart),
                        SizedBox(width: 10),
                        buildItem(cmtCount, icon: CupertinoIcons.chat_bubble),
                        SizedBox(width: 10),
                        buildItem(rtwCount, icon: CupertinoIcons.arrow_2_squarepath),
                        SizedBox(width: 10),
                        buildItem(shareCount, icon: CupertinoIcons.paperplane),
                        SizedBox(width: 10),
                        Spacer(),
                        IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.bookmark, color: Colors.white,))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildItem(String count, {required IconData icon}) {
    return Row(
      mainAxisSize: MainAxisSize.min, // 👈 Không chiếm hết chiều ngang
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(width: 2),
        Text(count, style: TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }


}
