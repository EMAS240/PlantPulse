import 'package:get_storage/get_storage.dart';
import 'package:untitled4/Views/Widgets/PlayerSounds.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerMenu extends StatefulWidget {
  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final Uri _url = Uri.parse('https://wa.me/+963986344057');
  final box = GetStorage();
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      Get.snackbar('Error', 'Could not launch $_url',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1D5B27),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // استبدال الأيقونة بصورة النبتة
                  Image.asset(
                    'images/icon1.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "PlantPulse",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.connect_without_contact,
                    color: Color(0xFF3CAA3C),
                  ),
                  title: Text('contact_us'.tr),
                  onTap: () {
                    PlayerSounds().pS(7);
                    _launchUrl();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.language,
                    color: Color(0xFF3CAA3C),
                  ),
                  title: Text('select_language'.tr),
                  onTap: () {
                    PlayerSounds().pS(3);
                    _showLanguageDialog();
                  },
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "© 2025 PlantPulse",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    Get.defaultDialog(
      title: 'select_language'.tr,
      content: Column(
        children: [
          ListTile(
            title: const Text("English"),
            onTap: () {
              box.write('lang', 'en');
              Get.updateLocale(const Locale('en'));
              Get.back();
            },
          ),
          ListTile(
            title: const Text("العربية"),
            onTap: () {
              box.write('lang', 'ar');
              Get.updateLocale(const Locale('ar'));
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Português"),
            onTap: () {
              box.write('lang', 'pt');
              Get.updateLocale(const Locale('pt'));
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
