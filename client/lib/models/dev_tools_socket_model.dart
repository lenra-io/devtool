import 'package:fr_lenra_client/models/socket_model.dart';
import 'package:fr_lenra_client/socket/lenra_channel.dart';
import 'package:fr_lenra_client/utils/connexion_utils_stub.dart'
    if (dart.library.io) 'package:fr_lenra_client/utils/connexion_utils_io.dart'
    if (dart.library.js) 'package:fr_lenra_client/utils/connexion_utils_web.dart';
import 'package:phoenix_wings/phoenix_wings.dart';

class DevToolsSocketModel extends SocketModel {
  PhoenixSocket _socket;

  DevToolsSocketModel()
      : this._socket = createPhoenixSocket(
          "ws://localhost:4000/socket/websocket",
          {},
        ) {
    this._socket.connect();
  }

  LenraChannel channel(String channelName, Map<String, dynamic> params) {
    return new LenraChannel(this._socket, channelName, params);
  }
}
