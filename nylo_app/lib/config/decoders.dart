import '/app/controllers/comment_controller.dart';
import '/app/models/comment.dart';
import '/app/models/post.dart';
import '/app/controllers/http_methods_controller.dart';
import '/app/controllers/cart_controller.dart';
import '/app/controllers/home_controller_controller.dart';
import '/app/controllers/home_controller.dart';
import '/app/models/user.dart';
import '/app/networking/api_service.dart';

/* Model Decoders
|--------------------------------------------------------------------------
| Model decoders are used in 'app/networking/' for morphing json payloads
| into Models.
|
| Learn more https://nylo.dev/docs/6.x/decoders#model-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> modelDecoders = {
  Map<String, dynamic>: (data) => Map<String, dynamic>.from(data),

  List<User>: (data) =>
      List.from(data).map((json) => User.fromJson(json)).toList(),
  //
  User: (data) => User.fromJson(data),

  // User: (data) => User.fromJson(data),

  List<Post>: (data) => List.from(data).map((json) => Post.fromJson(json)).toList(),

  Post: (data) => Post.fromJson(data),

  List<Comment>: (data) => List.from(data).map((json) => Comment.fromJson(json)).toList(),

  Comment: (data) => Comment.fromJson(data),
};

/* API Decoders
| -------------------------------------------------------------------------
| API decoders are used when you need to access an API service using the
| 'api' helper. E.g. api<MyApiService>((request) => request.fetchData());
|
| Learn more https://nylo.dev/docs/6.x/decoders#api-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> apiDecoders = {
  ApiService: () => ApiService(),

  // ...
};

/* Controller Decoders
| -------------------------------------------------------------------------
| Controller are used in pages.
|
| Learn more https://nylo.dev/docs/6.x/controllers
|-------------------------------------------------------------------------- */
final Map<Type, dynamic> controllers = {
  HomeController: () => HomeController(),
  // ...
  HomeControllerController: () => HomeControllerController(),

  CartController: () => CartController(),

  HttpMethodsController: () => HttpMethodsController(),

  CommentController: () => CommentController(),
};

