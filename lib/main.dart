import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pili_phone/pages/phone_controller.dart';
import 'package:pili_phone/pages/phone_page.dart';
import 'package:pili_phone/pages/wallet/wallet_controller.dart';
import 'config/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initServices();
  runApp(const PiliPhone());
}

Future<void> initServices() async {
  Get.put(PhoneController());
  Get.put(WalletController());
}

class PiliPhone extends StatelessWidget {
  const PiliPhone({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.main,
        home: const PhonePage(),
      ),
    );
  }
}
