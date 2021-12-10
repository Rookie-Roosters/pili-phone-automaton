import 'package:get/get.dart';
import 'package:pili_phone/models/coin.dart';

class WalletController extends GetxController {
  var coinStack = <Coin>[].obs;
  int get total => coinStack.fold(0, (value, item) => value + item.value);

  void addCoin(Coin coin) {
    coinStack.add(coin);
  }
}
