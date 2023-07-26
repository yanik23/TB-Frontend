

/// This DTO class is used to represent a dish for the delivery.
///
///
class DishForDeliveryDTO {
  int id;
  String name;
  double price;
  int quantityRemained;
  int quantityDelivered;

  DishForDeliveryDTO(this.id, this.name, this.price, this.quantityRemained, this.quantityDelivered);

  factory DishForDeliveryDTO.fromJson(Map<String, dynamic> json) {
    return DishForDeliveryDTO(
      json['id'],
      json['name'],
      json['price'],
      json['quantityRemained'],
      json['quantityDelivered'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantityRemained': quantityRemained,
    'quantityDelivered': quantityDelivered,
  };
}