class CentroidModel {
  final String typeCode;
  final List<int> vector; // Always expanded to 18 (EI9 + CI9)

  CentroidModel({
    required this.typeCode,
    required this.vector,
  });

  factory CentroidModel.fromMap(String key, Map<String, dynamic> value) {
    if (!value.containsKey('centroid')) {
      throw Exception("Centroid missing for type $key");
    }

    final raw = List<dynamic>.from(value['centroid']);
    final ei = raw.map((e) => (e as num).toInt()).toList();

    // Ensure 18-length vector (EI + CI padded)
    final vector = ei.length == 18 ? ei : [...ei, ...List.filled(9, 0)];

    return CentroidModel(typeCode: key, vector: vector);
  }
}
