import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pili_phone/automaton/automaton.dart';

class PhoneController extends GetxController {
  final numberField = TextEditingController();
  final coinsField = TextEditingController();

  @override
  void onInit() async {
    final test1 = await Automaton.fromFile('assets/machines/Proyecto 1.jff');
    print('T1 GOB: ${test1.evaluate('4666223')}'); // GOB
    print('T1 INTER: ${test1.evaluate('44466833777')}'); // INTER
    print('T1 JCLC: ${test1.evaluate('5222555222')}'); // JCLC
    print('T1 JCLC 2.0: ${test1.evaluate('JCLC')}'); // JCLC

    final test2 = await Automaton.fromFile('assets/machines/Proyecto 2.jff');
    print('T2 GOB: ${test2.evaluate('466622')}'); // GOB
    print('T2 LOC: ${test2.evaluate('555666222')}'); // LOC
    print('T2 JCLC: ${test2.evaluate('5222555222')}'); // JCLC
    print('T2 JCLC 2.0: ${test2.evaluate('JCLC')}'); // JCLC

    super.onInit();
  }
}
