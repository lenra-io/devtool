import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  // String getUserId() {
  //   if (!Uri.base.queryParameters.containsKey("user")) return "1";
  //   String userIdStr = Uri.base.queryParameters["user"]!;
  //   return (int.tryParse(userIdStr) ?? 1).toString();
  // }

  String goTo;

  HomePage(this.goTo);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => GoRouter.of(context).go(goTo),
      child: Text("Go to app"),
    );
  }
}
