import 'dart:convert';

import 'package:http/http.dart' as http;

Future sendNotification(
    String to, String title, String body, Map<String, String> data) async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAAWzCgE0:APA91bGzZ0NEt9x0tWrVJI-PKLS1uV8vAH6d0KS4sAR0JyDKs2G9quRcAHq1-eY5JeZU9nPRqs9wI5LM8RadgKk0WuhJsbEueoeSsMvPpOklnmz2lveOG0r4f5JAP1uOqQPmvcP4K4ED'
  };
  var request =
      http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
  request.body = json.encode({
    "to": to,
    "notification": {"title": title, "body": body, "mutable_content": true},
    "data": data
  });
  request.headers.addAll(headers);
  print(request.body);
  http.StreamedResponse response =
      await request.send().timeout(Duration(seconds: 30));

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
