import 'package:client_app/app.dart';
import 'package:client_app/models/socket_model.dart';
import 'package:flutter/material.dart';
import 'package:lenra_ui_runner/lenra_application_model.dart';
import 'package:provider/provider.dart';

import 'models/dev_tools_socket_model.dart';

class HomePage extends StatelessWidget {
  static const String appName = "00000000-0000-0000-0000-000000000000";

  int getUserId() {
    if (!Uri.base.queryParameters.containsKey("user")) return 1;
    String userIdStr = Uri.base.queryParameters["user"]!;
    return int.tryParse(userIdStr) ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<LenraApplicationModel>(
        create: (context) => LenraApplicationModel('http://localhost:4000', appName, ''),
      ),
      ChangeNotifierProvider<SocketModel>(
        create: (context) {
          return DevToolsSocketModel(getUserId());
        },
      ),
    ], builder: (BuildContext context, _) => App(appName: appName));
  }
}
