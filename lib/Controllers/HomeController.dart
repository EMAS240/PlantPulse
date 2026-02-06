import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxString base64Image = ''.obs;
  RxString serverResponse = ''.obs;
  RxString geminiResponse = ''.obs;
  RxBool isLoading = false.obs;

  /// اختيار صورة من المعرض وتحويلها إلى Base64
  Future<void> pickAndConvertImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      final String base64Str = base64Encode(bytes);

      base64Image.value = base64Str;
      geminiResponse.value = ''; // تفريغ تقرير جيميناي القديم
      print("11111111111111111");
      print(base64Str);
      await sendImageToServer(base64Str);
    } else {
      print('no_image_selected'.tr); // نص مترجم: "لم يتم اختيار صورة"
    }
  }

  /// إرسال الصورة إلى API التعرف على النبات
  Future<void> sendImageToServer(String base64Image) async {
    final url = Uri.parse('https://api.plant.id/v2/identify');

    final Map<String, dynamic> data = {
      "images": ["data:image/jpeg;base64,$base64Image"],
      "organs": ["leaf"]
    };

    try {
      isLoading.value = true;

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Api-Key": "DL8CbEWOp9UmIGGKTIdKPYpR1gir5aHK6YNFBH6QLHpXgGwNuY",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        serverResponse.value = response.body;
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey('suggestions') &&
            (jsonResponse['suggestions'] as List).isNotEmpty) {
          final plantName = jsonResponse['suggestions'][0]['plant_name'];
          print(plantName);
          await sendRequestToGemini(plantName);
        } else {
          print('no_suggestions_found'
              .tr); // "لم يتم العثور على اقتراحات للنبات."
          isLoading.value = false;
        }
      } else {
        serverResponse.value = "${'error_code'.tr}: ${response.statusCode}";
        isLoading.value = false;
      }
    } catch (e) {
      serverResponse.value = "${'exception'.tr}: $e";
      isLoading.value = false;
    }
  }

  /// إرسال طلب لجيميناي للحصول على تقرير مختصر للنبات
  Future<void> sendRequestToGemini(String plantName) async {
    final geminiUrl = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyCwasPsmZKt6vdfKOvXwtOt58Ar1SuyRZA');

    final promptText = '''
${'write_report_for'.tr} $plantName

- ${'environment_and_climate'.tr}
- ${'preferred_soil_type'.tr}
- ${'watering_and_fertilizing'.tr}
- ${'ideal_planting_time'.tr}
- ${'general_care_tips'.tr}
- ${'medical_benefits'.tr}
- ${'report_word_limit'.tr}

''';

    final Map<String, dynamic> body = {
      "contents": [
        {
          "parts": [
            {"text": promptText}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        geminiUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        geminiResponse.value = response.body;
      } else {
        geminiResponse.value = "${'error_gemini'.tr}: ${response.statusCode}";
      }
    } catch (e) {
      geminiResponse.value = "${'exception_gemini'.tr}: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
