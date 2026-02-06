import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:untitled4/Controllers/VPNController.dart';
import 'package:untitled4/Views/Screens/HomeScreen.dart';
import 'package:untitled4/Views/Screens/VpnScreen.dart';
import 'package:untitled4/Views/Widgets/CustomButton.dart';
import 'package:untitled4/Views/Widgets/NotificationService.dart';
import 'package:untitled4/Views/Widgets/PlayerSounds.dart';
import 'package:untitled4/Views/Widgets/backgroundDecoration.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _notificationSent = false;
  bool _isLoading = false;

  Future<void> _requestPermissions() async {
    if (kIsWeb) {
      // لا حاجة لطلب صلاحيات في الويب
      print('Running on Web — no permissions required');
      return;
    }

    // طلب صلاحية الإشعارات (Android 13+)
    if (!await Permission.notification.isGranted) {
      await Permission.notification.request();
    }

    // طلب صلاحية التخزين (Android و iOS)
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration(),
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
                    offset: const Offset(0, 5),
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
                        'welcome'.tr,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3CAA3C),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'welcome_description'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  // طلب الصلاحيات بشكل آمن حسب المنصة
                                  await _requestPermissions();

                                  // تهيئة الإشعارات وعرض إشعار ترحيبي
                                  NotificationService notificationService =
                                      NotificationService();
                                  await notificationService
                                      .initializeNotifications();
                                  await notificationService
                                      .showWelcomeNotification();
                                  _notificationSent = true;

                                  // جلب IP والدولة
                                  var userIpAddress =
                                      await VPNController().fetchIPAddress();
                                  print("User IP: $userIpAddress");
                                  var userCountry = await VPNController()
                                      .getUserCountry(userIpAddress);
                                  print(
                                      "User Country: ${userCountry.toLowerCase()}");

                                  // تشغيل صوت
                                  PlayerSounds().pS(7);

                                  // التوجيه حسب الدولة
                                  if (userCountry.toLowerCase() == 'sy' ||
                                      userCountry.toLowerCase() ==
                                          'failed_to_get_location'.tr) {
                                    Get.offAll(() => VpnScreen());
                                  } else {
                                    Get.offAll(() => HomeScreen());
                                  }
                                } catch (e) {
                                  print("Error: $e");
                                  Get.snackbar("Error", e.toString());
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                              label: 'next'.tr,
                            ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// هذا الكود مع اعلانات بعد الضغط على زر التالي
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:startapp_sdk/startapp.dart';

// import 'package:untitled4/Controllers/VPNController.dart';
// import 'package:untitled4/Views/Screens/HomeScreen.dart';
// import 'package:untitled4/Views/Screens/VpnScreen.dart';
// import 'package:untitled4/Views/Widgets/CustomButton.dart';
// import 'package:untitled4/Views/Widgets/NotificationService.dart';
// import 'package:untitled4/Views/Widgets/PlayerSounds.dart';
// import 'package:untitled4/Views/Widgets/backgroundDecoration.dart';

// class WelcomeScreen extends StatefulWidget {
//   @override
//   _WelcomeScreenState createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   bool _notificationSent = false;
//   bool _isLoading = false;

//   StartAppSdk startAppSdk = StartAppSdk();

//   StartAppRewardedVideoAd? rewardedVideoAd;
//   StartAppInterstitialAd? interstitialAd;

//   @override
//   void initState() {
//     super.initState();

//     startAppSdk.setTestAdsEnabled(false);

//     // تحميل إعلانات مسبقاً
//     _loadRewardedVideoAd();
//     _loadInterstitialAd();
//   }

//   Future<void> _loadRewardedVideoAd() async {
//     try {
//       var ad = await startAppSdk.loadRewardedVideoAd(
//         prefs:
//             const StartAppAdPreferences(adTag: 'welcome_screen_rewarded_video'),
//         onAdDisplayed: () {
//           debugPrint('Rewarded video ad displayed');
//         },
//         onAdNotDisplayed: () {
//           debugPrint('Rewarded video ad not displayed');
//           setState(() {
//             rewardedVideoAd = null;
//           });
//         },
//         onAdClicked: () {
//           debugPrint('Rewarded video ad clicked');
//         },
//         onAdHidden: () {
//           debugPrint('Rewarded video ad hidden');
//           setState(() {
//             rewardedVideoAd?.dispose();
//             rewardedVideoAd = null;
//           });
//         },
//         onVideoCompleted: () {
//           debugPrint('Rewarded video completed, user gained reward');
//           _continueAfterAd();
//         },
//       );
//       setState(() {
//         rewardedVideoAd = ad;
//       });
//     } catch (e) {
//       debugPrint("Error loading rewarded video ad: $e");
//       rewardedVideoAd = null;
//     }
//   }

//   Future<void> _loadInterstitialAd() async {
//     try {
//       var ad = await startAppSdk.loadInterstitialAd(
//         prefs:
//             const StartAppAdPreferences(adTag: 'welcome_screen_interstitial'),
//         onAdDisplayed: () {
//           debugPrint('Interstitial ad displayed');
//         },
//         onAdNotDisplayed: () {
//           debugPrint('Interstitial ad not displayed');
//           setState(() {
//             interstitialAd = null;
//           });
//         },
//         onAdClicked: () {
//           debugPrint('Interstitial ad clicked');
//         },
//         onAdHidden: () {
//           debugPrint('Interstitial ad hidden');
//           setState(() {
//             interstitialAd?.dispose();
//             interstitialAd = null;
//           });
//           // بعد انتهاء الإعلان، نكمل عملية التوجيه
//           _continueAfterAd();
//         },
//       );
//       setState(() {
//         interstitialAd = ad;
//       });
//     } catch (e) {
//       debugPrint("Error loading interstitial ad: $e");
//       interstitialAd = null;
//     }
//   }

//   Future<void> _requestPermissions() async {
//     if (kIsWeb) {
//       print('Running on Web — no permissions required');
//       return;
//     }

//     if (!await Permission.notification.isGranted) {
//       await Permission.notification.request();
//     }

//     if (!await Permission.storage.isGranted) {
//       await Permission.storage.request();
//     }
//   }

//   Future<void> _continueAfterAd() async {
//     try {
//       await _requestPermissions();

//       NotificationService notificationService = NotificationService();
//       await notificationService.initializeNotifications();
//       await notificationService.showWelcomeNotification();
//       _notificationSent = true;

//       var userIpAddress = await VPNController().fetchIPAddress();
//       print("User IP: $userIpAddress");
//       var userCountry = await VPNController().getUserCountry(userIpAddress);
//       print("User Country: ${userCountry.toLowerCase()}");

//       PlayerSounds().pS(7);

//       if (userCountry.toLowerCase() == 'sy' ||
//           userCountry.toLowerCase() == 'failed_to_get_location'.tr) {
//         Get.offAll(() => VpnScreen());
//       } else {
//         Get.offAll(() => HomeScreen());
//       }
//     } catch (e) {
//       print("Error: $e");
//       Get.snackbar("Error", e.toString());
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _onNextPressed() async {
//     setState(() {
//       _isLoading = true;
//     });

//     if (rewardedVideoAd != null) {
//       try {
//         await rewardedVideoAd!.show().onError((error, stackTrace) {
//           debugPrint("Error showing rewarded video ad: $error");
//           // إذا فشل عرض فيديو، جرب عرض الإعلان التفاعلي (interstitial)
//           _showInterstitialOrContinue();
//           return false;
//         });
//         // الاستمرار بعد انتهاء الفيديو يتم في onVideoCompleted callback تلقائياً
//       } catch (e) {
//         debugPrint("Exception showing rewarded video ad: $e");
//         await _showInterstitialOrContinue();
//       }
//     } else {
//       // إذا لم يكن هناك إعلان فيديو، جرب عرض إعلان تفاعلي
//       await _showInterstitialOrContinue();
//     }
//   }

//   Future<void> _showInterstitialOrContinue() async {
//     if (interstitialAd != null) {
//       try {
//         await interstitialAd!.show().onError((error, stackTrace) {
//           debugPrint("Error showing interstitial ad: $error");
//           // إذا فشل العرض، نتابع مباشرة
//           _continueAfterAd();
//           return false;
//         });
//         // الاستمرار بعد انتهاء العرض في onAdHidden callback تلقائياً
//       } catch (e) {
//         debugPrint("Exception showing interstitial ad: $e");
//         await _continueAfterAd();
//       }
//     } else {
//       // لا يوجد إعلان تفاعلي، نتابع مباشرة
//       await _continueAfterAd();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: backgroundDecoration(),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 10),
//                       Text(
//                         'welcome'.tr,
//                         style: const TextStyle(
//                           fontSize: 36,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF3CAA3C),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         'welcome_description'.tr,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       _isLoading
//                           ? const CircularProgressIndicator()
//                           : CustomButton(
//                               onPressed: _onNextPressed,
//                               label: 'next'.tr,
//                             ),
//                       const SizedBox(height: 30),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



