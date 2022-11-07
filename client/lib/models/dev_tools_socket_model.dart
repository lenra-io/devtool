import 'package:client_common/utils/connexion_utils_stub.dart'
    if (dart.library.io) 'package:client_common/utils/connexion_utils_io.dart'
    if (dart.library.js) 'package:client_common/utils/connexion_utils_web.dart';
import 'package:lenra_ui_runner/models/socket_model.dart';
import 'package:lenra_ui_runner/socket/lenra_channel.dart';
import 'package:phoenix_wings/phoenix_wings.dart';

class DevToolsSocketModel extends SocketModel {
  PhoenixSocket _socket;

  DevToolsSocketModel(int userId, String appName)
      : this._socket = createPhoenixSocket(
          "ws://localhost:4000/socket/websocket",
          {"userId": userId.toString(), "app": appName},
        ) {
    this._socket.connect();
  }

  LenraChannel channel(String channelName, Map<String, dynamic> params) {
    return new LenraChannel(this._socket, channelName, params);
  }
}
