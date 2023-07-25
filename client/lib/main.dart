import 'package:client/appNavigator.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:url_strategy/url_strategy.dart';

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

  int getUserId() {
    if (!Uri.base.queryParameters.containsKey("user")) return 1;
    String userIdStr = Uri.base.queryParameters["user"]!;
    return int.tryParse(userIdStr) ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();

    return LenraTheme(
      themeData: themeData,
      child: MaterialApp.router(
        routerConfig: AppNavigator.router,
        title: 'Lenra - Devtool',
        theme: ThemeData(
          textTheme: TextTheme(bodyText2: themeData.lenraTextThemeData.bodyText),
        ),
      ),
    );
  }
}
