import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pili_phone/automaton/automaton.dart';
import 'package:pili_phone/pages/phone_page.dart';
import 'package:pili_phone/pages/wallet/wallet_controller.dart';
import 'package:pili_phone/utils/ui_utils.dart';

class PhoneController extends GetxController {
  final numberField = TextEditingController();
  final numberMask = MaskTextInputFormatter(mask: '(###) ### #### ###', filter: {"#": RegExp(r'[0-9]')});
  var numberName = ''.obs;

  @override
  void onInit() {
    numberField.addListener(() {
      final unmasked = numberMask.unmaskText(numberField.text);
      numberName(getNumberName(unmasked));
    });
    super.onInit();
  }

  String getNumberName(String number) {
    String name = '';
    int counter = 0;
    for (int i = 0; i < number.length; i++) {
      final keys = keyboard[number[i]]!;
      if (i != 0 && number[i] != number[i - 1] || counter >= keys.length) {
        counter = 0;
        name += (keys.isNotEmpty ? keys[counter] : '');
      }
      name = name.substring(0, max(name.length - 1, 0)) + (keys.isNotEmpty ? keys[counter] : '');
      counter++;
    }
    return name;
  }

  void call() async {
    final unmasked = numberMask.unmaskText(numberField.text);
    final t1 = await Automaton.fromFile('assets/machines/Proyecto 2.jff');
    final t2 = await Automaton.fromFile('assets/machines/Proyecto 1.jff');
    final nfa = await Automaton.fromFile('assets/machines/NFA proyecto.jff');
    final r1 = t1.evaluate(unmasked) ? '1' : '0';
    final r2 = t2.evaluate(unmasked) ? '1' : '0';
    if (r1 == '0' && r2 == '0') {
      callDialog(CallStatus.wrongNumber);
      return;
    }
    final coins = Get.find<WalletController>().coinStack.fold('', (value, coin) => '$value${coin.variable}');
    final res = nfa.evaluate('$r1$r2$coins');
    if (res) {
      callDialog(
        CallStatus.success,
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Text('Marcando a ${numberName.value}', style: Get.textTheme.bodyText1?.copyWith(color: Colors.white), textAlign: TextAlign.center),
          Lottie.asset('assets/animations/ringing.json', width: 150, height: 150).pb,
        ]),
      );
    } else {
      callDialog(
        CallStatus.insufficientMoney,
        Text('Es necesario tener al menos \$${prices[numberName.value]} para marcar a ${numberName.value}',
            style: Get.textTheme.bodyText1?.copyWith(color: Colors.white), textAlign: TextAlign.center),
      );
    }
  }
}

const keyboard = <String, String>{
  '1': '',
  '2': 'ABC',
  '3': 'DEF',
  '4': 'GHI',
  '5': 'JKL',
  '6': 'MNO',
  '7': 'PQRS',
  '8': 'TUV',
  '9': 'WXYZ',
  '*': ',',
  '0': '+',
  '#': ';',
};

const prices = <String, int>{
  'GOB': 5,
  'LOC': 10,
  'INTER': 12,
};
