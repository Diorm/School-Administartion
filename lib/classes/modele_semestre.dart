class Semestre {
  final int? id;
  final String nomSemestre;

  Semestre({
    this.id,
    required this.nomSemestre,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomSemestre': nomSemestre,
    };
  }

  factory Semestre.fromMap(Map<String, dynamic> map) {
    return Semestre(
      id: map['id'],
      nomSemestre: map['nomSemestre'],
    );
  }
}
