import 'dart:io';
import "package:path_provider/path_provider.dart";

Future<String> getIp() async {
  var socket = await Socket.connect('8.8.8.8', 80);
  return socket.address.address;

}

Future<void> startServer() async {
  print("Starting server");
  var server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    8765,
  );
  print("Server started ");
  var applicationDirectory = await getApplicationDocumentsDirectory();
  await for (var request in server) {
    // handle Get
    if (request.method == 'GET') {
      var filename = request.uri.pathSegments.last;
      var file = File('${applicationDirectory.path}/$filename');
      if (await file.exists()) {
        request.response.headers.contentType = ContentType.binary;
        await request.response.addStream(file.openRead());
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
      request.response.close();
    }

    // handle Post
    if (request.method == 'POST') {
      print('POST for ${request.uri.pathSegments.last}');
      var filename = request.uri.pathSegments.last;
      var file = File('${applicationDirectory.path}/$filename');
      await file.writeAsBytes(await request.first);
      request.response.statusCode = HttpStatus.ok;
      request.response.close();
    }
  }
}