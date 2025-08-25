class AnimalsModels {
  String? id;
  String? name;
  String? age;
  String? breed;
  String? image;
  String? rate;
  int? price;

  AnimalsModels({
    required this.id,
    required this.name,
    required this.age,
    required this.breed,
    required this.image,
    required this.rate,
    required this.price,
  });

  factory AnimalsModels.fromJson(Map<String, dynamic> json) {
    return AnimalsModels(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      breed: json['breed'],
      image: json['image'],
      rate: json['rate'],
      price: json['price'],
    );
  }
}
