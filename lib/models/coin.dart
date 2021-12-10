class Coin {
  final String name;
  final String picture;
  final int value;
  final String variable;
  const Coin({
    required this.name,
    required this.picture,
    required this.value,
    required this.variable,
  });

  static List<Coin> get all => [dogecoin, monero, ethereum, bitcoin];
}

const Coin dogecoin = Coin(name: 'Dogecoin', picture: 'assets/doge.png', value: 1, variable: 'A');
const Coin monero = Coin(name: 'Monero', picture: 'assets/xmr.png', value: 2, variable: 'B');
const Coin ethereum = Coin(name: 'Ethereum', picture: 'assets/eth.png', value: 5, variable: 'C');
const Coin bitcoin = Coin(name: 'Bitcoin', picture: 'assets/btc.png', value: 10, variable: 'D');
