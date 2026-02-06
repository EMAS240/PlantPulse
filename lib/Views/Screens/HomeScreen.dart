import 'dart:convert';
import 'dart:typed_data';
import 'package:untitled4/Views/Widgets/CustomButton.dart';
import 'package:untitled4/Views/Widgets/DrawerMenu.dart';
import 'package:untitled4/Views/Widgets/PlayerSounds.dart';
import 'package:untitled4/Views/Widgets/backgroundDecoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import '../../Controllers/HomeController.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  Future<void> generateAndDownloadPDF(
      Uint8List imageBytes, String reportText) async {
    final pdf = pw.Document();

    final fontData =
        await rootBundle.load('assets/fonts/NotoKufiArabic-Black.ttf');
    final ttf = pw.Font.ttf(fontData);

    final image = pw.MemoryImage(imageBytes);

    final isArabic = Get.locale?.languageCode == 'ar';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) {
          return [
            pw.Directionality(
              textDirection:
                  isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'plant_report'.tr,
                    style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        font: ttf,
                        color: PdfColor.fromInt(0xff3CAA3C)),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Container(
                      width: 400,
                      height: 400,
                      child: pw.Image(
                        image,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    reportText,
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: ttf,
                    ),
                    textAlign:
                        isArabic ? pw.TextAlign.right : pw.TextAlign.left,
                  ),
                ],
              ),
            )
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      body: Stack(
        children: [
          Container(decoration: backgroundDecoration()),

          // Menu Button
          Positioned(
            top: 45,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1D5B27),
                    Color(0xFF3CAA3C),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                },
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'home'.tr,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3CAA3C),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'upload_image'.tr +
                                "\n" +
                                "upload_image_description".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            label: 'upload_image'.tr,
                            onPressed: () async {
                              await controller.pickAndConvertImage();
                              PlayerSounds().pS(1);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 30),
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 20),
                                    Text('loading'.tr),
                                  ],
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Obx(() {
                              if (controller.base64Image.value.isNotEmpty &&
                                  controller.geminiResponse.value.isNotEmpty &&
                                  !controller.isLoading.value) {
                                String reportText = "";
                                try {
                                  final Map<String, dynamic> geminiJson =
                                      jsonDecode(
                                          controller.geminiResponse.value);
                                  final parts = geminiJson['candidates'][0]
                                      ['content']['parts'];
                                  reportText = parts[0]['text'] ?? "";
                                } catch (e) {
                                  reportText = 'no_report'.tr;
                                }

                                final bytes =
                                    base64Decode(controller.base64Image.value);
                                String cleanedReport = reportText
                                    .replaceAll(RegExp(r'\*+'), '')
                                    .replaceAll(RegExp(r'#'), '')
                                    .replaceAll(RegExp(r'_+'), '')
                                    .replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '')
                                    .trim();

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.memory(
                                            bytes,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
                                          child: Text(
                                            'plant_report'.tr,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[700],
                                              fontFamily: 'NotoKufiArabic',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          cleanedReport,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            generateAndDownloadPDF(
                                                bytes, cleanedReport);
                                          },
                                          icon:
                                              const Icon(Icons.picture_as_pdf),
                                          label: Text(
                                            'download_pdf'.tr,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF3CAA3C),
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(50, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
