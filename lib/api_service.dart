import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json'));
  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Error al cargar los datos');
  }
}
