import '/resources/pages/http_methods_page.dart';
import '/resources/pages/cart_page.dart';
import '/resources/pages/event_and_listener_page.dart';
import '/resources/pages/third_nylo_page.dart';
import '/resources/pages/second_nylo_page.dart';
import '/resources/pages/first_nylo_page.dart';
import '/resources/pages/not_found_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
|
| * [Tip] Add authentication 🔑
| Run the below in the terminal to add authentication to your project.
| "dart run scaffold_ui:main auth"
|
| * [Tip] Add In-app Purchases 💳
| Run the below in the terminal to add In-app Purchases to your project.
| "dart run scaffold_ui:main iap"
|
| Learn more https://nylo.dev/docs/6.x/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
       //router.add(HomePage.path).initialRoute();

      // Add your routes here ...
      // router.add(NewPage.path, transitionType: TransitionType.fade());

      // Example using grouped routes
      // router.group(() => {
      //   "route_guards": [AuthRouteGuard()],
      //   "prefix": "/dashboard"
      // }, (router) {
      //
      // });
      router.route("/", (context) => HomePage(), initialRoute: true);
      router.add(NotFoundPage.path).unknownRoute();
      router.route("/first", (context) => HomePage());
      router.route("/second", (context) => ProfilePage());
      router.route("/third", (context)=> SettingPage());
      router.route("/cart_event", (context)=> EventAndListenerPage());
      router.route("/cart", (context)=> CartPage());
      router.route("/http_method", (context)=> HttpMethodsPage());
});
