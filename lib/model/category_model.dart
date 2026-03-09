class CategoryModel {
  final int? id;
  final String name;
  final String description;
  final String icon;

  const CategoryModel({
    this.id,
    this.name = 'Unnamed',
    this.description = '',
    this.icon = 'assets/icons/grocery.png',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json,
      {String? fallbackIcon}) {
    return CategoryModel(
      id: _asInt(json['id'] ?? json['category_id']),
      name: (json['name'] ?? json['title'] ?? 'Unnamed').toString(),
      description: (json['description'] ?? '').toString(),
      icon: (json['icon'] ??
              json['icon_url'] ??
              json['image_url'] ??
              fallbackIcon ??
              'assets/icons/grocery.png')
          .toString(),
    );
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? description,
    String? icon,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
