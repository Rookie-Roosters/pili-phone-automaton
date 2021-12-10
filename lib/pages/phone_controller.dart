import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pili_phone/models/automaton.dart';
import 'package:xml/xml.dart';

class PhoneController extends GetxController {
  final numberField = TextEditingController();
  final coinsField = TextEditingController();

  @override
  void onInit() async {
    final test = await Automaton.fromFile('assets/machines/Proyecto 1.jff');
    print('Type: ${test.type}');
    print('STATES:');
    for (final state in test.states) {
      print(state);
    }
    print('TRANSITIONS:');
    for (final transition in test.transitions) {
      print(transition);
    }

    //print(document.toXmlString(pretty: true, indent: '\t'));
    super.onInit();
  }
}
