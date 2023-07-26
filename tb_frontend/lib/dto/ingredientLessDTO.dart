
/// This class contains the information of an ingredient with the weight.
///
/// Used to add ingredients to a dish.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class IngredientLessDTO {
  int id;
  String name;
  double? weight;

  IngredientLessDTO(this.id, this.name, this.weight);

  /// This function is used to create an ingredient with the weight from a json.
  factory IngredientLessDTO.fromJson(Map<String, dynamic> json) {
    return IngredientLessDTO(
      json['id'],
      json['name'],
      json['weight'],
    );
  }

  /// This function is used to convert an ingredient with the weight to a json.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'weight': weight,
  };
}