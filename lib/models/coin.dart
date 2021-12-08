class Coin {
  final String name;
  final String picture;
  final int value;
  const Coin({
    required this.name,
    required this.picture,
    required this.value,
  });

  static List<Coin> get all => [dogecoin, monero, ethereum, bitcoin];
}

const Coin dogecoin = Coin(name: 'Bitcoin', picture: 'assets/doge.png', value: 1);
const Coin monero = Coin(name: 'Monero', picture: 'assets/xmr.png', value: 2);
const Coin ethereum = Coin(name: 'Ethereum', picture: 'assets/eth.png', value: 5);
const Coin bitcoin = Coin(name: 'Bitcoin', picture: 'assets/btc.png', value: 10);
