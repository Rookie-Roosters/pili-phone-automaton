class Transition {
  final int from;
  final int to;
  final String read;
  final String write;
  final String? move;
  const Transition({
    required this.from,
    required this.to,
    required this.read,
    this.write = ' ',
    this.move,
  });

  Transition copyWith({
    int? from,
    int? to,
    String? read,
    String? write,
    String? move,
  }) {
    return Transition(
      from: from ?? this.from,
      to: to ?? this.to,
      read: read ?? this.read,
      write: write ?? this.write,
      move: move ?? this.move,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'read': read,
      'write': write,
      'move': move,
    };
  }

  factory Transition.fromMap(Map<String, dynamic> map) {
    return Transition(
      from: map['from']?.toInt() ?? 0,
      to: map['to']?.toInt() ?? 0,
      read: map['read'] ?? ' ',
      write: map['write'] ?? ' ',
      move: map['move'],
    );
  }

  @override
  String toString() {
    return 'Transition(from: $from, to: $to, read: $read, write: $write, move: $move)';
  }
}
