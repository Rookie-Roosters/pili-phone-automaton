import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pili_phone/config/app_themes.dart';
import 'package:pili_phone/pages/phone_controller.dart';
import 'package:pili_phone/pages/wallet/wallet_controller.dart';
import 'package:pili_phone/pages/wallet/wallet_view.dart';
import 'package:pili_phone/utils/ui_utils.dart';

class PhonePage extends GetView<PhoneController> {
  const PhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        Container(
            alignment: Alignment.center,
            child: Text(
              'Pilifón',
              textAlign: TextAlign.center,
              style: Get.textTheme.headline2?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ).left([
              const Icon(LineIcons.phoneVolume, color: Colors.white, size: 55).pr,
            ])).expanded(),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(kBorderRadius)),
          ),
          padding: kPadding,
          child: Column(children: [
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: kRoundedBorder),
              padding: kPadding2,
              child: Row(children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                    controller: controller.numberField,
                    readOnly: true,
                    inputFormatters: [controller.numberMask],
                    textAlign: TextAlign.center,
                    style: Get.textTheme.headline5?.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(border: InputBorder.none, filled: false),
                  ),
                  Obx(() => Text(
                        controller.numberName.value,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headline6?.copyWith(color: Colors.grey.shade500, fontWeight: FontWeight.normal),
                      )),
                ]).expanded(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Ink(child: const Icon(LineIcons.backspace, size: 30)),
                    onLongPress: () => controller.numberField.clear(),
                    onTap: () {
                      final unmasked = controller.numberMask.unmaskText(controller.numberField.text);
                      controller.numberField.text = controller.numberMask.maskText(unmasked.substring(0, max(unmasked.length - 1, 0)));
                    },
                  ),
                ).box(40, 40),
              ]),
            ),
            kSpacerY,
            const _DialPad(),
            kSpacerY2,
            Row(children: [
              Obx(
                () => Text(
                  '\$${Get.find<WalletController>().total}',
                  style: Get.textTheme.headline5?.copyWith(color: Colors.orange),
                ).bottom([
                  const Icon(LineIcons.coins, color: Colors.orange),
                ], crossAxisAlignment: CrossAxisAlignment.center),
              ).expanded(),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 80, height: 80),
                child: ElevatedButton(
                  child: const Icon(LineIcons.phone, size: 40),
                  onPressed: () => controller.call(),
                  style: ElevatedButton.styleFrom(
                    primary: kSecondaryColor,
                    shape: const CircleBorder(),
                  ),
                ),
              ).expanded(),
              IconButton(
                color: kPrimaryColor,
                icon: const Icon(LineIcons.wallet, size: 40),
                onPressed: () => WalletView.show(),
              ).expanded(),
            ]),
          ]),
        ),
      ]).safeArea(),
    ).overlayStyle(statusBar: kPrimaryColor, navigationBar: Colors.white);
  }
}

class _DialPad extends GetView<PhoneController> {
  const _DialPad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 12,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 9 / 7),
      itemBuilder: (context, index) {
        final key = keyboard.keys.elementAt(index);
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text(
            key,
            style: Get.textTheme.headline3?.copyWith(fontWeight: FontWeight.bold, color: kDarkColor, height: 0.8),
          ).bottom([
            Text(keyboard[key]!, style: Get.textTheme.subtitle1?.copyWith(color: Colors.grey, height: 1)),
          ], crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center),
        ).mouse(() {
          if (key != '*' && key != '#' && key != '0' && key != '1') {
            final unmasked = controller.numberMask.unmaskText(controller.numberField.text);
            controller.numberField.text = controller.numberMask.maskText('$unmasked${index + 1}');
          }
        });
      },
    );
  }
}

Future<void> callDialog(CallStatus status, [Widget? extra]) async {
  return Get.dialog(Material(
    color: Colors.transparent,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: kRoundedBorder,
        color: status == CallStatus.success ? kSuccessColor : kWarningColor,
      ),
      padding: kPadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        Text(status.title.toUpperCase(),
            style: Get.textTheme.headline5?.copyWith(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        kSpacerY,
        if (status.text.isNotEmpty)
          Text(
            status.text,
            style: Get.textTheme.bodyText1?.copyWith(color: Colors.white),
          ),
        if (extra != null) extra.pt
      ]),
    ),
  ).p4.centered());
}

enum CallStatus {
  insufficientMoney,
  wrongNumber,
  success,
}

extension CallStatusExtension on CallStatus {
  String get title {
    switch (this) {
      case CallStatus.insufficientMoney:
        return 'Saldo insuficiente';
      case CallStatus.wrongNumber:
        return 'Número incorrecto';
      case CallStatus.success:
        return 'Conectando llamada...';
    }
  }

  String get text {
    switch (this) {
      case CallStatus.insufficientMoney:
        return 'Ingresa más fondos desde tu billetera electrónica';
      case CallStatus.wrongNumber:
        return 'Intenta con alguno de los siguientes: INTER, GOB, LOC';
      case CallStatus.success:
        return '';
    }
  }
}
