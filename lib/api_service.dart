import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 10.0.2.2 is the address for android emulator
  final String baseUrl = 'http://10.0.2.2:3000'; 

  Future<List<dynamic>> getData() async {
    final response = await http.get(Uri.parse('$baseUrl/data'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> postData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/data'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post data');
    }
  }
}
