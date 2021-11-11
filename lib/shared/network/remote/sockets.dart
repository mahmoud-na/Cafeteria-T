import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cafeteriat/shared/components/constants.dart';

import '../end_points.dart';

class Sockets {
  static var timeOut = false;
  static const delayTime = 6;

 static Future<void> sendMessage(Socket socket, String message) async {
    print("-------------------------------------------\n");
    print('Client: $message');
    print("-------------------------------------------\n");
    socket.write(message);
  }

  static Future connectToServer({
     required String query,
  }) async {
    timeOut = false;
    List<int> toBeDecoded = [];
    late StreamSubscription<Uint8List> subscription;

    try {
      final socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(
          seconds: delayTime,
        ),
      );
      print("-------------------------------------------\n");
      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
      print("-------------------------------------------\n");
      await sendMessage(socket, query);
      subscription = socket.listen((Uint8List data) {
        toBeDecoded += data;
      }, onError: (error) {
        socket.destroy();
      });
      await subscription.asFuture<void>().timeout(
            const Duration(
              seconds: delayTime,
            ),
          );
      print("-------------------------------------------\n");
      print('Server left.');
      print("-------------------------------------------\n");
      socket.destroy();
      final decodedData = jsonDecode(utf8.decode(toBeDecoded));
      print("-------------------------------------------\n");
      print('Server: $decodedData');
      // printFullText(decodedData);
      print("-------------------------------------------\n");
      return decodedData;
    } on SocketException {
      print(
          "========================================================= SocketException =========================================================}");
      timeOut = true;
    } on TimeoutException {
      print(
          "========================================================= TimeoutException =========================================================}");
      timeOut = true;
    } catch (e) {
      print(
          "========================================================= Connection error ========================================================= $e}");
      // if (toBeDecoded.isNotEmpty) {
      //   await connectToServer(query: query);
      // }
    }
  }
}
