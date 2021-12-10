import 'package:flutter/services.dart' show rootBundle;
import 'package:pili_phone/automaton/turing_tape.dart';
import 'package:xml/xml.dart';
import 'state.dart';
import 'transition.dart';

class Automaton {
  final String type;
  final List<State> states;
  final List<Transition> transitions;
  const Automaton({
    required this.type,
    required this.states,
    required this.transitions,
  });

  static Future<Automaton> fromFile(String fileName) async {
    final text = await rootBundle.loadString(fileName);
    final document = XmlDocument.parse(text);
    final _type = document.findAllElements('type').first.innerText;
    final _states = document.findAllElements('state').map((e) {
      return State(
        id: int.parse(e.getAttribute('id') ?? '0'),
        name: e.getAttribute('name')!,
        label: e.getElement('label')?.innerText,
        isInitial: e.getElement('initial') != null,
        isFinal: e.getElement('final') != null,
      );
    }).toList();
    final _transitions = document.findAllElements('transition').map((e) {
      final read = e.getElement('read')?.innerText ?? ' ';
      final write = e.getElement('write')?.innerText ?? ' ';
      return Transition(
        from: int.parse(e.getElement('from')?.innerText ?? '0'),
        to: int.parse(e.getElement('to')?.innerText ?? '0'),
        read: read.isEmpty ? ' ' : read,
        write: write.isEmpty ? ' ' : write,
        move: e.getElement('move')?.innerText,
      );
    }).toList();
    return Automaton(
      type: _type,
      states: _states,
      transitions: _transitions,
    );
  }

  bool evaluate(String input) {
    final initial = states.singleWhere((element) => element.isInitial);
    if (type == 'turing') {
      final tape = TuringTape(head: 0, tape: input.split(''));
      return _turing(tape, initial);
    } else if (type == 'fa') {
      return _nfa(input, 0, initial);
    }
    return false;
  }

  bool _turing(TuringTape tape, State state) {
    if (state.isFinal) return true;
    final _transitions = transitions.where((element) => element.from == state.id && element.read == tape.headSymbol).toList();
    for (final transition in _transitions) {
      final tapeCopy = tape.copyWith()..write(transition);
      final toState = states.singleWhere((element) => element.id == transition.to);
      final res = _turing(tapeCopy, toState);
      if (res) {
        return true;
      }
    }
    return false;
  }

  bool _nfa(String input, int index, State state) {
    if (index == input.length) {
      return state.isFinal;
    }
    final symbol = input.split('')[index];
    final _transitions = transitions.where((element) => element.from == state.id && element.read == symbol).toList();
    for (final transition in _transitions) {
      final toState = states.singleWhere((element) => element.id == transition.to);
      final res = _nfa(input, index + 1, toState);
      if (res) {
        return true;
      }
    }
    return false;
  }

  Automaton copyWith({
    String? type,
    List<State>? states,
    List<Transition>? transitions,
  }) {
    return Automaton(
      type: type ?? this.type,
      states: states ?? this.states,
      transitions: transitions ?? this.transitions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'states': states.map((x) => x.toMap()).toList(),
      'transitions': transitions.map((x) => x.toMap()).toList(),
    };
  }

  factory Automaton.fromMap(Map<String, dynamic> map) {
    return Automaton(
      type: map['type'] ?? '',
      states: List<State>.from(map['states']?.map((x) => State.fromMap(x)) ?? const []),
      transitions: List<Transition>.from(map['transitions']?.map((x) => Transition.fromMap(x)) ?? const []),
    );
  }

  @override
  String toString() => 'Automaton(type: $type, states: $states, transitions: $transitions)';
}
