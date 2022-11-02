import 'package:client/homePage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lenra_ui_runner/app.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:lenra_components/theme/lenra_theme.dart';
import 'package:lenra_components/theme/lenra_theme_data.dart';

void main() async {
  setPathUrlStrategy();
  runApp(
    // DevicePreview(
    //   builder: (context) => DevTools(),
    // ),
    DevTools(),
  );
}

class DevTools extends StatelessWidget {
  static const String appName = "00000000-0000-0000-0000-000000000000";

  static const String baseRoute = "/app/" + appName;

  @override
  Widget build(BuildContext context) {
    return App(
      appName: appName,
      wsEndpoint: "ws://localhost:4000/socket/websocket",
      httpEndpoint: "http://localhost:4000",
      accessToken: "",
      baseRoute: baseRoute,
//      customParams: {"userId": getUserId()},
      builder: (BuildContext context, List<RouteBase> routes) {
        var themeData = LenraThemeData();
        routes.addAll([
          GoRoute(
            path: "/",
            builder: (c, state) => HomePage(baseRoute),
          ),
        ]);

        GoRouter router = GoRouter(
          routes: routes,
        );
        return LenraTheme(
          themeData: themeData,
          child: MaterialApp.router(
            title: 'Lenra - DevTools',
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            routerDelegate: router.routerDelegate,
          ),
        );
      },
    );

    // var themeData = LenraThemeData();

    // return LenraTheme(
    //   themeData: themeData,
    //   child: MaterialApp.router(
    //     title: 'Lenra - DevTools',
    //     theme: ThemeData(
    //       textTheme: TextTheme(bodyText2: themeData.lenraTextThemeData.bodyText),
    //     ),
    //     routeInformationParser: router.routeInformationParser,
    //     routeInformationProvider: router.routeInformationProvider,
    //     routerDelegate: router.routerDelegate,
    //     // locale: DevicePreview.locale(context),
    //     // builder: DevicePreview.appBuilder,
    //     // onGenerateRoute: (RouteSettings settings) {
    //     //   Widget? pageView;
    //     //   if (settings.name != null) {
    //     //     var uriData = Uri.parse(settings.name!);
    //     //     //uriData.path will be your path and uriData.queryParameters will hold query-params values

    //     //     switch (uriData.path) {
    //     //       case '/':
    //     //         pageView = HomePage();
    //     //         break;
    //     //     }
    //     //   }

    //     //   if (pageView == null) return null;

    //     //   return MaterialPageRoute(builder: (BuildContext context) => pageView!);
    //     // },
    //   ),
    // );
  }
}
