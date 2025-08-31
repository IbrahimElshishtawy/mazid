// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['_id'] as String,
  status: json['status'] as String,
  category: json['category'] as String,
  name: json['name'] as String,
  price: ProductModel._toDouble(json['price']),
  description: json['description'] as String,
  image: json['image'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  company: json['company'] as String,
  countInStock: (json['countInStock'] as num).toInt(),
  sales: (json['sales'] as num).toInt(),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'status': instance.status,
      'category': instance.category,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'image': instance.image,
      'images': instance.images,
      'company': instance.company,
      'countInStock': instance.countInStock,
      'sales': instance.sales,
    };
