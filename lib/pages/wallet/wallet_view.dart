import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pili_phone/config/app_themes.dart';
import 'package:pili_phone/models/coin.dart';
import 'package:pili_phone/pages/wallet/wallet_controller.dart';
import 'package:pili_phone/utils/ui_utils.dart';

class WalletView extends GetView<WalletController> {
  const WalletView._({Key? key}) : super(key: key);

  static Future<void> show() async {
    return await Get.bottomSheet(
      const WalletView._(),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kBorderRadius))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Text('CriptoWallet', style: Get.textTheme.headline4?.copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor)).left([
        const Icon(LineIcons.coins, color: kPrimaryColor, size: 50).pr2,
      ]).p3,
      GridView.builder(
          itemCount: Coin.all.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: kSpacing, vertical: kSpacing1),
          physics: kNeverScroll,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 2.5, crossAxisSpacing: kSpacing2, mainAxisSpacing: kSpacing2),
          itemBuilder: (context, index) {
            final coin = Coin.all[index];
            return Container(
              decoration: BoxDecoration(borderRadius: kRoundedBorder / 2, border: Border.all(color: kPrimaryColor)),
              padding: kPadding2,
              child: Image.asset(coin.picture, width: 35, height: 35).right([
                Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  Text(coin.name),
                  Text(NumberFormat.simpleCurrency().format(coin.value * 1000),
                      style: Get.textTheme.caption?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold)),
                ]).pl2,
                kSpacer,
                const Icon(LineIcons.plusCircle, color: kPrimaryColor)
              ]),
            ).mouse(() {
              controller.addCoin(coin);
            });
          }),
      Obx(
        () => Row(
          children: controller.coinStack.map((coin) {
            return Image.asset(coin.picture, width: 40, height: 40).px1.mouse(() {
              controller.coinStack.remove(coin);
            });
          }).toList(),
        ).height(40),
      ).scrollable(direction: Axis.horizontal, padding: kPadding3),
      Obx(() => ElevatedButton.icon(
            icon: const Icon(LineIcons.plusCircle),
            label: Text('Agregar ${NumberFormat.simpleCurrency().format(controller.total * 1000)}'),
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: kRoundedBorder),
              primary: kSecondaryColor,
              padding: kPadding2,
              elevation: 0,
            ),
            onPressed: () {
              Get.back();
            },
          )).px3,
      kSpacerY,
    ]);
  }
}
