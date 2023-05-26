import 'package:client/main.dart';
import 'package:client_common/navigator/common_navigator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lenra_ui_runner/app.dart';
import 'package:lenra_ui_runner/io_components/lenra_route.dart';

class AppNavigator extends CommonNavigator {
  static GoRoute appRoutes = GoRoute(
    name: "appRoutes",
    path: "/:path(.*)",
    pageBuilder: (_, state) {
      return NoTransitionPage(
        child: App(
          appName: DevTools.appName,
          httpEndpoint: "http://localhost:4001",
          accessToken: "",
          wsEndpoint: "ws://localhost:4001/socket/websocket",
          baseRoute: "/",
          routeWidget: LenraRoute(
            "/${state.params['path']!}",
            // Use UniqueKey to make sure that the LenraRoute Widget is properly reloaded with the new route when navigating.
            key: UniqueKey(),
          ),
          navTo: (context, route) {
            GoRouter.of(context).go(route);
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
