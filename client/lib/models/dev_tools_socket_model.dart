import 'package:client_app/models/socket_model.dart';
import 'package:client_app/socket/lenra_channel.dart';
import 'package:client_common/utils/connexion_utils_stub.dart'
    if (dart.library.io) 'package:client_common/utils/connexion_utils_io.dart'
    if (dart.library.js) 'package:client_common/utils/connexion_utils_web.dart';
import 'package:phoenix_wings/phoenix_wings.dart';

class DevToolsSocketModel extends SocketModel {
  PhoenixSocket _socket;

  DevToolsSocketModel()
      : this._socket = createPhoenixSocket(
          "ws://localhost:4000/socket/websocket",
          {"token": "token"},
        ) {
    this._socket.connect();
  }

  LenraChannel channel(String channelName, Map<String, dynamic> params) {
    return new LenraChannel(this._socket, channelName, params);
  }
}
