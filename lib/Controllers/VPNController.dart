import 'dart:convert';
import 'package:untitled4/Views/Widgets/ShowErrorSnackbar.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class VPNController {
  Future<String> fetchIPAddress() async {
    try {
      final response = await http.get(Uri.parse('https://ipinfo.io/ip'));
      if (response.statusCode == 200) {
        return response.body.trim();
      } else {
        throw Exception('Failed to load IP address');
      }
    } catch (e) {
      print('Error: $e');
      return 'failed_to_get_ip'.tr;
    }
  }

  Future<String> getUserCountry(String ipAddress) async {
    final apiKey = 'cbe2ff29110364'; // Replace with your actual API key
    final url = 'https://ipinfo.io/$ipAddress/json?token=$apiKey';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['country'];
      } else {
        return 'failed_to_get_location'.tr;
      }
    } catch (e) {
      print('Error: $e');
      return 'failed_to_get_location'.tr;
    }
  }
}
