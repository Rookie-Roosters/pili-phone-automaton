import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pili_phone/config/app_themes.dart';
import 'package:pili_phone/models/coin.dart';
import 'package:pili_phone/pages/phone_controller.dart';
import 'package:pili_phone/utils/ui_utils.dart';

class PhonePage extends GetView<PhoneController> {
  const PhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Container(
            decoration: const BoxDecoration(color: kPrimaryColor, borderRadius: kRoundedBorder),
            padding: kPadding2,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: controller.numberField,
                readOnly: true,
                style: Get.textTheme.bodyText1?.copyWith(color: Colors.white30),
                decoration: InputDecoration(
                  label: Text('Número', style: Get.textTheme.subtitle1?.copyWith(color: Colors.white)),
                ),
              ),
              kSpacerY1,
              TextField(
                controller: controller.coinsField,
                style: Get.textTheme.bodyText1?.copyWith(color: Colors.white30),
                readOnly: true,
                decoration: InputDecoration(
                  label: Text('Dinero', style: Get.textTheme.subtitle1?.copyWith(color: Colors.white)),
                ),
              ),
            ]),
          ).expanded(),
          DragTarget<Coin>(
            builder: (context, candidateItems, rejectedItems) {
              return Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(color: kSecondaryColor, borderRadius: kRoundedBorder),
                alignment: Alignment.center,
                margin: kPaddingL3,
                child: Text('Varo aquí', textAlign: TextAlign.center, style: Get.textTheme.headline6?.copyWith(color: Colors.white)),
              );
            },
            onAccept: (coin) {
              controller.coinsField.value = TextEditingValue(text: ((int.tryParse(controller.coinsField.text) ?? 0) + coin.value).toString());
            },
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Coin.all.map((coin) {
            return LongPressDraggable<Coin>(
              data: coin,
              dragAnchorStrategy: pointerDragAnchorStrategy,
              feedback: Image.asset(coin.picture).box(60, 60),
              child: Image.asset(coin.picture).box(50, 50),
            ).px2;
          }).toList(),
        ).py,
        GridView.builder(
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: kSpacing, mainAxisSpacing: kSpacing),
          itemBuilder: (context, index) {
            if (index == 9 || index == 11) {
              return const SizedBox();
            }
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: kRoundedBorder),
              child: Text(index == 10 ? '0' : (index + 1).toString(), style: Get.textTheme.headline3).bottom([
                Text(_keyboard[index], style: Get.textTheme.subtitle1),
              ], crossAxisAlignment: CrossAxisAlignment.center),
            ).mouse(() {
              controller.numberField.value = TextEditingValue(text: '${controller.numberField.text}${index + 1}');
            });
          },
        ).expanded(),
      ]).p3.safeArea(),
    );
  }
}

const _keyboard = [
  '',
  'ABC',
  'DEF',
  'GHI',
  'JKL',
  'MNO',
  'PQRS',
  'TUV',
  'WXYZ',
  '',
  '',
  '',
];
