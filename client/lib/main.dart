import 'package:client/homePage.dart';
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
  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();

    return LenraTheme(
      themeData: themeData,
      child: MaterialApp(
        title: 'Lenra - DevTools',
        theme: ThemeData(
          textTheme: TextTheme(bodyText2: themeData.lenraTextThemeData.bodyText),
        ),
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        onGenerateRoute: (RouteSettings settings) {
          Widget? pageView;
          if (settings.name != null) {
            var uriData = Uri.parse(settings.name!);
            //uriData.path will be your path and uriData.queryParameters will hold query-params values

            switch (uriData.path) {
              case '/':
                pageView = HomePage();
                break;
            }
          }

          if (pageView == null) return null;

          return MaterialPageRoute(builder: (BuildContext context) => pageView!);
        },
      ),
    );
  }
}
