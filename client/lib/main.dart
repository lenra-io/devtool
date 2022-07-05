import 'package:client/models/dev_tools_socket_model.dart';
import 'package:client_app/app.dart';
import 'package:client_app/models/socket_model.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  runApp(
    // DevicePreview(
    //   builder: (context) => DevTools(),
    // ),
    DevTools(),
  );
}

class DevTools extends StatelessWidget {
  static const String appName = "00000000-0000-0000-0000-000000000000";

  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SocketModel>(
          create: (context) => DevToolsSocketModel(),
        ),
      ],
      builder: (BuildContext context, _) {
        return LenraTheme(
          themeData: themeData,
          child: MaterialApp(
            title: 'Lenra - DevTools',
            theme: ThemeData(
              textTheme: TextTheme(bodyText2: themeData.lenraTextThemeData.bodyText),
            ),
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            home: App(appName: appName),
          ),
        );
      },
    );
  }
}
