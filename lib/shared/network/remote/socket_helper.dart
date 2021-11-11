import 'package:cafeteriat/shared/network/remote/sockets.dart';

class SocketHelper {
  static Future getData({
    required String query,
  }) async {
    return await Sockets.connectToServer(
      query: query,
    );
  }

  static Future postData({
    required String query,
  }) async {
    return await Sockets.connectToServer(
      query: query,
    );
  }
}
