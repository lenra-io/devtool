import 'package:client/models/dev_tools_socket_model.dart';
import 'package:flutter/material.dart';
import 'package:fr_lenra_client/components/stateful_wrapper.dart';
import 'package:fr_lenra_client/lenra_application/lenra_ui_controller.dart';
import 'package:fr_lenra_client/models/channel_model.dart';
import 'package:fr_lenra_client/models/client_widget_model.dart';
import 'package:fr_lenra_client/models/context_model.dart';
import 'package:fr_lenra_client/models/socket_model.dart';
import 'package:fr_lenra_client/models/user_application_model.dart';
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

class DevTools extends StatefulWidget {
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DevToolsState();
  }
}

class DevToolsState extends State<DevTools> {
  static const String appName = "test";
  bool isInitialized = false;
  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();

    return MaterialApp(
        home: MultiProvider(
      providers: [
        ChangeNotifierProvider<UserApplicationModel>(create: (context) => UserApplicationModel()),
        ChangeNotifierProvider<ContextModel>(create: (context) => ContextModel()),
        ChangeNotifierProvider<SocketModel>(create: (context) => DevToolsSocketModel()),
        ChangeNotifierProvider<LenraApplicationModel>(
          create: (context) => LenraApplicationModel('http://localhost:4000', appName, ''),
        ),
        ChangeNotifierProxyProvider2<SocketModel, ContextModel, ChannelModel>(
          create: (context) =>
              ChannelModel(socketModel: context.read<SocketModel>(), contextModel: context.read<ContextModel>()),
          update: (_, socketModel, contextModel, channelModel) {
            if (channelModel == null) {
              return ChannelModel(socketModel: socketModel, contextModel: contextModel);
            }
            return channelModel.update(socketModel, contextModel);
          },
        ),
        ChangeNotifierProxyProvider<ChannelModel, WidgetModel>(
          create: (context) => ClientWidgetModel(channelModel: context.read<ChannelModel>()),
          update: (_, channelModel, clientWidgetModel) => clientWidgetModel!,
        ),
      ],
      builder: (BuildContext context, _) {
        return StatefulWrapper(
          onInit: (){

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
                    body: FutureBuilder(
                      builder: (context, _) {
                        WidgetsBinding.instance?.addPostFrameCallback((_){
                        context.read<UserApplicationModel>().currentApp = appName;
                        context.read<ContextModel>().mediaQueryData = MediaQuery.of(context);
                        if (context.read<ChannelModel>().channel == null) {
                            context.read<ChannelModel>().createChannel(appName);
                        }
                        (context.read<WidgetModel>() as ClientWidgetModel).setupListeners();
                         setState(() {
                            isInitialized = true;
                          });
                        });
                      return isInitialized ? LenraUiController() : CircularProgressIndicator();
                    }),
                  ),
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
