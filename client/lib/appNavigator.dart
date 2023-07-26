import 'package:client_common/navigator/common_navigator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lenra_ui_runner/app.dart';
import 'package:lenra_ui_runner/io_components/lenra_route.dart';
import 'package:url_launcher/url_launcher.dart';

class AppNavigator extends CommonNavigator {
  static const String appName = "00000000-0000-0000-0000-000000000000";
  static const String oauth2Token =
      "SFMyNTY.g2gDdAAAAAFkAAVzY29wZW0AAAANYXBwOndlYnNvY2tldG4GAMaoaJKJAWIAAVGA.Mic1j8bSUAmdPLOMCM_XKvebMkIm9SZA9gFC5GAr49M";
  static GoRoute appRoutes = GoRoute(
    name: "appRoutes",
    path: "/:path(.*)",
    pageBuilder: (_, state) {
      return NoTransitionPage(
        child: App(
          appName: appName,
          httpEndpoint: "http://localhost:4001",
          accessToken: oauth2Token,
          wsEndpoint: "ws://localhost:4001/socket/websocket",
          baseRoute: "/",
          routeWidget: LenraRoute(
            "/${state.params['path']!}",
            // Use UniqueKey to make sure that the LenraRoute Widget is properly reloaded with the new route when navigating.
            key: UniqueKey(),
          ),
          navTo: (context, route) {
            // This regex matches http:// and https:// urls
            RegExp exp = RegExp(r"^https?://");
            if (exp.hasMatch(route)) {
              _launchURL(route);
            } else {
              GoRouter.of(context).go(route);
            }
          },
          customParams: {
            "userId": state.queryParams['user'] ?? '1',
          },
        ),
      );
    },
  );

  static GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [appRoutes],
  );
}

class NoTransitionPage extends CustomTransitionPage {
  NoTransitionPage({required Widget child, LocalKey? key})
      : super(
          child: child,
          key: key,
          transitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
}

_launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception("Could not launch url: $url");
  }
}
