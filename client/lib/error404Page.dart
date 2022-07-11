import 'package:client_common/api/response_models/api_errors.dart';
import 'package:client_common/lenra_application/error_page.dart';
import 'package:flutter/widgets.dart';

class Error404Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ErrorPage(
      apiErrors: ApiErrors.fromJson([]),
      title: "Snap !",
      message: "This page does not exists.",
      contactMessage: "If you think it's a mistake, please leave us an issue at https://github.com/lenra-io/lenra",
    );
  }
}
