import 'package:http/http.dart' as http;
import 'dart:convert';

// Network dart is useful for getting all url data
class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  Future<dynamic> getData() async{
    http.Response response = await http.get(url);
    if (response.statusCode == 200){
      String data = response.body;
      //print(jsonDecode(data));
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}