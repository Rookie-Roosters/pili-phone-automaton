import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';

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
      return Transition(
        from: int.parse(e.getElement('from')?.innerText ?? '0'),
        to: int.parse(e.getElement('to')?.innerText ?? '0'),
        read: e.getElement('read')?.innerText ?? '',
        write: e.getElement('write')?.innerText ?? '',
        move: e.getElement('move')?.innerText,
      );
    }).toList();
    return Automaton(
      type: _type,
      states: _states,
      transitions: _transitions,
    );
  }
}

class State {
  final int id;
  final String name;
  final String? label;
  final bool isInitial;
  final bool isFinal;
  const State({
    required this.id,
    required this.name,
    this.label,
    this.isInitial = false,
    this.isFinal = false,
  });

  @override
  String toString() {
    return '\nState(id: $id, name: $name, label: $label, isInitial: $isInitial, isFinal: $isFinal)';
  }
}

class Transition {
  final int from;
  final int to;
  final String read;
  final String? write;
  final String? move;
  const Transition({
    required this.from,
    required this.to,
    required this.read,
    this.write,
    this.move,
  });

  @override
  String toString() {
    return '\nTransition(from: $from, to: $to, read: $read, write: $write, move: $move)';
  }
}
