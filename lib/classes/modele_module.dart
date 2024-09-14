/* class Module {
  final int? id;
  final String nomModule;
  final int volumeHoraire;
  final String semestre; // New field for semester
  final String filiere; // New field for program

  Module({
    this.id,
    required this.nomModule,
    required this.volumeHoraire,
    required this.semestre, // Required parameter for semester
    required this.filiere, // Required parameter for program
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomModule': nomModule,
      'volumeHoraire': volumeHoraire,
      'semestre': semestre, // Include semester in the map
      'filiere': filiere, // Include program in the map
    };
  }

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
      id: map['id'],
      nomModule: map['nomModule'],
      volumeHoraire: map['volumeHoraire'],
      semestre: map['semestre'], // Extract semester from the map
      filiere: map['filiere'], // Extract program from the map
    );
  }
}
 */
class Module {
  final int? id;
  final String nomModule;
  final int volumeHoraire;
  final String semestre;
  final String filiere;

  Module({
    this.id,
    required this.nomModule,
    required this.volumeHoraire,
    required this.semestre,
    required this.filiere,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomModule': nomModule,
      'volumeHoraire': volumeHoraire,
      'semestre': semestre,
      'filiere': filiere,
    };
  }

  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
      id: map['id'],
      nomModule: map['nomModule'],
      volumeHoraire: map['volumeHoraire'],
      semestre: map['semestre'],
      filiere: map['filiere'],
    );
  }

  @override
  String toString() {
    return nomModule; // Retourne le nom du module comme chaîne de caractères
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Module && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
