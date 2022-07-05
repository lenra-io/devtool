import 'package:client/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
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
          if (pageView != null) {
            return MaterialPageRoute(builder: (BuildContext context) => pageView!);
          }
        },
      ),
    );
  }
}
