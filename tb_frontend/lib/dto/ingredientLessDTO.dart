




class IngredientLessDTO {
  int id;
  String name;
  double? weight;

  IngredientLessDTO(this.id, this.name, this.weight);

  factory IngredientLessDTO.fromJson(Map<String, dynamic> json) {
    return IngredientLessDTO(
      json['id'],
      json['name'],
      json['weight'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'weight': weight,
  };
}