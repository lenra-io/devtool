import 'package:client/models/dev_tools_socket_model.dart';
import 'package:client_app/app.dart';
import 'package:client_app/models/socket_model.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/views/stateful_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:lenra_ui_runner/lenra_application_model.dart';
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
        ChangeNotifierProvider<UserApplicationModel>(create: (context) => UserApplicationModel()),
        ChangeNotifierProvider<LenraApplicationModel>(
          create: (context) => LenraApplicationModel('http://localhost:4000', appName, ''),
        ),
        ChangeNotifierProvider<SocketModel>(
          create: (context) => DevToolsSocketModel(FakeUser(1)),
        ),
      ],
      builder: (BuildContext context, _) {
        return StatefulWrapper(
          onInit: () {
            context.read<UserApplicationModel>().currentApp = appName;
          },
          builder: (context) {
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
      },
    );
  }
}
