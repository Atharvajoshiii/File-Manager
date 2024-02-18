class Folder {
  final String name;
  final DateTime createdAt;

  Folder({required this.name, required this.createdAt});

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
