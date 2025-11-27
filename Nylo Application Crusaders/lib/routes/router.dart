import '/resources/pages/welcome_page.dart';
import '/resources/pages/login_page.dart';
import '/resources/pages/authgate_page.dart';
import '/resources/pages/not_found_page.dart';
import '/resources/pages/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
|
| * [Tip] Add authentication 🔑
| Run the below in the terminal to route authentication to your project.
| "dart run scaffold_ui:main auth"
|
| * [Tip] Add In-app Purchases 💳
| Run the below in the terminal to route In-app Purchases to your project.
| "dart run scaffold_ui:main iap"
|
| Learn more https://nylo.dev/docs/6.x/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      // Initial route - AuthGate kiểm tra trạng thái đăng nhập
      router.route("/", (context) => AuthgatePage()).initialRoute();

      // Các routes khác
      router.route("/home", (context) => HomePage());
      router.route("/login", (context) => LoginPage());

      // Unknown route handler
      router.route(NotFoundPage.path, (context) => NotFoundPage()).unknownRoute();
  router.add(WelcomePage.path);
});
