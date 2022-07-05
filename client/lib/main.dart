import 'package:client_app/app.dart';
import 'package:client_app/models/channel_model.dart';
import 'package:client_app/models/client_widget_model.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/views/stateful_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
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
  static const String appName = "00000000-0000-0000-0000-000000000000";

  int getUserId() {
    if (!Uri.base.queryParameters.containsKey("user")) return 1;
    String userIdStr = Uri.base.queryParameters["user"]!;
    return int.tryParse(userIdStr) ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SocketModel>(create: (context) {
          return DevToolsSocketModel(getUserId());
        }),
        ChangeNotifierProxyProvider<SocketModel, ChannelModel>(
          create: (context) => ChannelModel(socketModel: context.read<SocketModel>()),
          update: (_, socketModel, channelModel) {
            if (channelModel == null) {
              return ChannelModel(socketModel: socketModel);
            }
            return channelModel.update(socketModel);
          },
        ),
        ChangeNotifierProxyProvider<ChannelModel, WidgetModel>(
          create: (context) => ClientWidgetModel(channelModel: context.read<ChannelModel>()),
          update: (_, channelModel, clientWidgetModel) => clientWidgetModel!,
        ),
      ],
      builder: (BuildContext context, _) {
        return StatefulWrapper(
          onInit: () {
<<<<<<< HEAD
            context.read<UserApplicationModel>().currentApp = appName;
=======
            context.read<ChannelModel>().createChannel(appName);
            (context.read<WidgetModel>() as ClientWidgetModel).setupListeners();
>>>>>>> 2bfc43c (wip)
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
