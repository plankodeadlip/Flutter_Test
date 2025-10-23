import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class bai5SocialMediaButton extends StatefulWidget {
  const bai5SocialMediaButton({super.key});

  @override
  State<bai5SocialMediaButton> createState() => _bai5SocialMediaButtonState();
}

class _bai5SocialMediaButtonState extends State<bai5SocialMediaButton> {
  int likeCounter = 66;
  bool isLiked = false;
  String comment = '';
  int cmtCounter = 30;
  bool isShare = false;
  int shareCounter = 0;

  bool showTextField = false; // ẩn/hiện ô nhập
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // 🔹 thêm focus node

  void likeClicked() {
    setState(() {
      if (isLiked) {
        likeCounter--;
      } else {
        likeCounter++;
      }
      isLiked = !isLiked;
    });
  }

  void cmtClicked() {
    setState(() {
      showTextField = !showTextField;
    });

    if (showTextField) {
      // 🔹 bật bàn phím sau khi render
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    } else {
      FocusScope.of(context).unfocus(); // ẩn bàn phím khi tắt
    }
  }

  void submitComment(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        comment = value;
        cmtCounter++;
        showTextField = false;
        _controller.clear();
      });
      FocusScope.of(context).unfocus(); // ẩn bàn phím sau khi gửi
    }
  }

  void shareClicked(){
    setState(() {
      shareCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'SOCIAL MEDIA POST',
          style: TextStyle(fontSize: 23, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
        body: Stack(
          children: [
            // 🩵 Toàn bộ nội dung chính
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SafeArea(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue, width: 3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage('assets/images/avatar.png'),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Tran Huy Hung',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    '1 giờ trước',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          postContent('#*Post Content*#', 'assets/images/post.png'),

                          // 🔹 Nút like, comment, share
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Like
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.all(10),child: Row(
                                      children: [
                                        Icon(CupertinoIcons.heart_fill, color: CupertinoColors.activeBlue,size: 26,),
                                        SizedBox(width: 2,),
                                        Text(
                                          '$likeCounter',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),),
                                    IconButton(
                                      icon: Icon(
                                        isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                        color: isLiked ? Colors.red : Colors.grey,
                                        size: 26,
                                      ),
                                      onPressed: likeClicked,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                // Comment
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.all(10),child: Row(
                                      children: [
                                        Icon(CupertinoIcons.chat_bubble_fill, color: CupertinoColors.activeBlue,size: 26,),
                                        SizedBox(width: 2,),
                                        Text(
                                          '$cmtCounter',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),),
                                    IconButton(
                                      icon: Icon(
                                        CupertinoIcons.chat_bubble_text,
                                        color: Colors.grey,
                                        size: 26,
                                      ),
                                      onPressed: cmtClicked,
                                    ),
                                  ],
                                ),
                                // Share
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.all(10),child: Row(
                                      children: [
                                        Icon(CupertinoIcons.share_solid, color: CupertinoColors.activeBlue,size: 26,),
                                        SizedBox(width: 2,),
                                        Text(
                                          '$shareCounter',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),),
                                    IconButton(
                                      icon: Icon(
                                        CupertinoIcons.share,
                                        color:Colors.grey,
                                        size: 26,
                                      ),
                                      onPressed: shareClicked,
                                    ),
                                  ],
                                ),                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 🩵 Ô nhập bình luận đè lên trên cùng
            if (showTextField)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: "Nhập bình luận...",
                            border: InputBorder.none,
                          ),
                          onSubmitted: submitComment,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            submitComment(_controller.text);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
    );
  }
}

Widget postContent(String? text, String? imagePath) {
  return Container(
    width: double.infinity,
    height: 320,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != null && text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        if (imagePath != null && imagePath.isNotEmpty)
          Expanded(
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
      ],
    ),
  );
}
