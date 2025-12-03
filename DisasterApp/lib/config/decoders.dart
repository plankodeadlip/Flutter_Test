import '/app/controllers/map_controller.dart';
import '/app/models/disaster_image.dart';
import '/app/models/disaster_type.dart';
import '/app/models/disaster.dart';
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

  List<Disaster>: (data) => List.from(data).map((json) => Disaster.fromJson(json)).toList(),

  Disaster: (data) => Disaster.fromJson(data),

  List<DisasterType>: (data) => List.from(data).map((json) => DisasterType.fromJson(json)).toList(),

  DisasterType: (data) => DisasterType.fromJson(data),

  List<DisasterImage>: (data) => List.from(data).map((json) => DisasterImage.fromJson(json)).toList(),

  DisasterImage: (data) => DisasterImage.fromJson(data),
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

  MapController: () => MapController(),
};
