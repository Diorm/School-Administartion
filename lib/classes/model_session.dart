class Session {
  final int? id;
  final String nomSession;

  Session({
    this.id,
    required this.nomSession,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomSession': nomSession,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      nomSession: map['nomSession'],
    );
  }
}
