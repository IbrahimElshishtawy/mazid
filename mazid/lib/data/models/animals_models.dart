class AnimalsModels {
  String? id;
  String? name;
  String? age;
  String? type;
  String? image;
  String? rate;
  int? price;

  AnimalsModels({
    required this.id,
    required this.name,
    required this.age,
    required this.type,
    required this.image,
    required this.rate,
    required this.price,
  });

  factory AnimalsModels.fromJson(Map<String, dynamic> json) {
    return AnimalsModels(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      type: json['type'],
      image: json['image'],
      rate: json['rate'],
      price: json['price'],
    );
  }
}
