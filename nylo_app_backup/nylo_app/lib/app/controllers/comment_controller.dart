import 'package:flutter_app/app/networking/api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../models/comment.dart';


import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';


class CommentController extends Controller {
  List<Comment> comments = [];

  Future<void> loadComments(int postId) async {
    comments = await Comment.getCommentsByPostId(postId);
  }
}
