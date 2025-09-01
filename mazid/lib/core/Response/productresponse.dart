import 'package:json_annotation/json_annotation.dart';
import 'package:mazid/core/models/product_models.dart';

part 'productresponse.g.dart';

@JsonSerializable(explicitToJson: true)
class Productresponse {
  final String status;
  final String message;

  @JsonKey(defaultValue: [])
  final List<ProductModel> product;

  Productresponse({
    required this.status,
    required this.message,
    required this.product,
  });

  factory Productresponse.fromJson(Map<String, dynamic> json) =>
      _$ProductresponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductresponseToJson(this);
}
