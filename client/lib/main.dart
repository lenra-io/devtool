import 'package:client/models/dev_tools_socket_model.dart';
import 'package:client_app/lenra_ui_controller.dart';
import 'package:client_app/models/channel_model.dart';
import 'package:client_app/models/client_widget_model.dart';
import 'package:client_app/models/socket_model.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/views/stateful_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:lenra_ui_runner/components/events/event.dart';
import 'package:lenra_ui_runner/lenra_application_model.dart';
import 'package:lenra_ui_runner/widget_model.dart';
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
          create: (context) => DevToolsSocketModel(),
        ),
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
            context.read<UserApplicationModel>().currentApp = appName;

            context.read<ChannelModel>().createChannel(appName);
            (context.read<WidgetModel>() as ClientWidgetModel).setupListeners();
          },
          builder: (context) {
            return NotificationListener<Event>(
              onNotification: (Event event) => context.read<ChannelModel>().handleNotifications(event),
              child: LenraTheme(
                themeData: themeData,
                child: MaterialApp(
                  title: 'Lenra - DevTools',
                  theme: ThemeData(
                    textTheme: TextTheme(bodyText2: themeData.lenraTextThemeData.bodyText),
                  ),
                  locale: DevicePreview.locale(context),
                  builder: DevicePreview.appBuilder,
                  home: Scaffold(
                    body: LenraUiController(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
