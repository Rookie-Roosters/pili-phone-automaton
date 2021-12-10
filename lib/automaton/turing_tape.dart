import 'transition.dart';

class TuringTape {
  List<String> tape;
  int head;
  int _offset = 0;
  int get _logicalHead => head - _offset;
  String get headSymbol => tape[_logicalHead];

  TuringTape({
    required this.tape,
    required this.head,
  }) {
    if (head >= tape.length) {
      tape.add(' ');
    } else if (head < 0) {
      tape.insert(0, ' ');
      _offset = head;
    }
  }

  void write(Transition transition) {
    if (transition.read == headSymbol) {
      tape[_logicalHead] = transition.write;
      if (transition.move == 'L') {
        if (--head < _offset) {
          _offset = head;
          tape.insert(0, ' ');
        }
      } else if (transition.move == 'R') {
        if (++head >= tape.length) {
          tape.add(' ');
        }
      }
    }
  }

  TuringTape._({
    required this.tape,
    required this.head,
    required int offset,
  }) : _offset = offset;
  TuringTape copyWith({
    List<String>? tape,
    int? head,
  }) {
    return TuringTape._(
      tape: tape ?? this.tape,
      head: head ?? this.head,
      offset: _offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tape': tape,
      'head': head,
      '_offset': _offset,
    };
  }

  factory TuringTape.fromMap(Map<String, dynamic> map) {
    return TuringTape._(
      tape: List<String>.from(map['tape'] ?? const []),
      head: map['head']?.toInt() ?? 0,
      offset: map['_offset']?.toInt() ?? 0,
    );
  }

  @override
  String toString() => 'TuringTape(tape: $tape, head: $head, _offset: $_offset)';
}
