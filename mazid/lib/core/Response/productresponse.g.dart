// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productresponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Productresponse _$ProductresponseFromJson(Map<String, dynamic> json) =>
    Productresponse(
      status: json['status'] as String,
      message: json['message'] as String,
      product: (json['product'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductresponseToJson(Productresponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'product': instance.product,
    };
