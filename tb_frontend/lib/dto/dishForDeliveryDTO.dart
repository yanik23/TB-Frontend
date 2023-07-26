

/// This DTO class is used to represent a dish for the delivery.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class DishForDeliveryDTO {
  int id;
  String name;
  double price;
  int quantityRemained;
  int quantityDelivered;

  DishForDeliveryDTO(this.id, this.name, this.price, this.quantityRemained, this.quantityDelivered);

  /// This function is used to create a dish for the delivery from a json.
  factory DishForDeliveryDTO.fromJson(Map<String, dynamic> json) {
    return DishForDeliveryDTO(
      json['id'],
      json['name'],
      json['price'],
      json['quantityRemained'],
      json['quantityDelivered'],
    );
  }

  /// This function is used to convert a dish for the delivery to a json.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantityRemained': quantityRemained,
    'quantityDelivered': quantityDelivered,
  };
}