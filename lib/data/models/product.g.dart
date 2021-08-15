// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as int,
    name: json['name'] as String,
    imageUrl: json['image_url'] as String,
    brandName: json['brand_name'] as String,
    packageName: json['package_name'] as String,
    price: json['price'] as int,
    rating: (json['rating'] as num).toDouble(),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'brand_name': instance.brandName,
      'package_name': instance.packageName,
      'price': instance.price,
      'rating': instance.rating,
    };
