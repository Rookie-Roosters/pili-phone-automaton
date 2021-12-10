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

  State copyWith({
    int? id,
    String? name,
    String? label,
    bool? isInitial,
    bool? isFinal,
  }) {
    return State(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      isInitial: isInitial ?? this.isInitial,
      isFinal: isFinal ?? this.isFinal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'label': label,
      'isInitial': isInitial,
      'isFinal': isFinal,
    };
  }

  factory State.fromMap(Map<String, dynamic> map) {
    return State(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      label: map['label'],
      isInitial: map['isInitial'] ?? false,
      isFinal: map['isFinal'] ?? false,
    );
  }

  @override
  String toString() {
    return 'State(id: $id, name: $name, label: $label, isInitial: $isInitial, isFinal: $isFinal)';
  }
}
