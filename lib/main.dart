import 'package:untitled4/Views/Screens/WelcomeScreen.dart';
import 'package:untitled4/Views/Screens/LanguageSelectionScreen.dart';
import 'package:untitled4/lang/MyTranslations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    String? savedLang = box.read('lang');
    Locale initialLocale = savedLang != null ? Locale(savedLang) : Locale('en');

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: initialLocale,
      translations: MyTranslations(),
      theme: ThemeData(
        fontFamily: 'NotoKufiArabic',
        colorScheme: ColorScheme.light(
          primary: Color(0xFF3CAA3C),
        ),
      ),
      home: savedLang == null ? LanguageSelectionScreen() : WelcomeScreen(),

      // 👇 هذه الإضافة تجعل اتجاه النص يعتمد على اللغة المختارة
      builder: (context, child) {
        return Directionality(
          textDirection: Get.locale?.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
