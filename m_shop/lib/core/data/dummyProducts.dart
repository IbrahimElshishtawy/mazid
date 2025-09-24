// ignore_for_file: file_names

import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'package:m_shop/core/models/swap/swap_request_model.dart';

final List<ProductModel> dummyProducts = [
  ProductModel(
    id: "p1",
    status: "active",
    category: "Electronics",
    name: "iPhone 15 Pro Max",
    title: "Apple iPhone 15 Pro Max - 256GB",
    price: 1199.99,
    description:
        "The latest iPhone 15 Pro Max with A17 Pro chip, 256GB storage, and titanium design.",
    image:
        "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-max",
    images: [
      "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-max",
      "https://m.media-amazon.com/images/I/71v0UN-K9-L._AC_SL1500_.jpg",
    ],
    company: "Apple",
    countInStock: 12,
    v: 1,
    sales: 5,
    rating: 4.8,
    ratingCount: 145,
  ),
  ProductModel(
    id: "p2",
    status: "active",
    category: "Electronics",
    name: "MacBook Air M3",
    title: "Apple MacBook Air 13-inch M3",
    price: 999.99,
    description:
        "Lightweight and powerful MacBook Air with M3 chip, 8GB RAM, 256GB SSD.",
    image:
        "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/macbook-air-m3",
    images: [
      "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/macbook-air-m3",
      "https://m.media-amazon.com/images/I/71gD8WdSlaL._AC_SL1500_.jpg",
    ],
    company: "Apple",
    countInStock: 8,
    v: 1,
    sales: 3,
    rating: 4.6,
    ratingCount: 87,
  ),
  ProductModel(
    id: "p3",
    status: "active",
    category: "Gaming",
    name: "PlayStation 5",
    title: "Sony PlayStation 5 Console",
    price: 499.99,
    description:
        "Experience lightning-fast loading with an ultra-high-speed SSD and deeper immersion with haptic feedback.",
    image: "https://m.media-amazon.com/images/I/619BkvKW35L._AC_SL1500_.jpg",
    images: [
      "https://m.media-amazon.com/images/I/619BkvKW35L._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71v0UN-K9-L._AC_SL1500_.jpg",
    ],
    company: "Sony",
    countInStock: 20,
    v: 1,
    sales: 10,
    rating: 4.9,
    ratingCount: 230,
  ),
];

final List<Map<String, dynamic>> dummyBids = [
  {"productId": "p1", "user": "أحمد", "amount": 600.0, "time": "قبل 10 دقائق"},
  {"productId": "p1", "user": "خالد", "amount": 650.0, "time": "قبل 8 دقائق"},
  {"productId": "p1", "user": "منى", "amount": 700.0, "time": "قبل 5 دقائق"},
  {"productId": "p2", "user": "يوسف", "amount": 1050.0, "time": "قبل 20 دقيقة"},
  {"productId": "p2", "user": "علي", "amount": 1100.0, "time": "قبل 15 دقيقة"},
  {"productId": "p3", "user": "محمود", "amount": 480.0, "time": "قبل 25 دقيقة"},
];

final List<SwapProductModel> dummySwapProducts = dummyProducts.map((p) {
  return SwapProductModel(
    id: p.id,
    name: p.name,
    description: p.description,
    imageUrl: p.image,
    ownerId: "unknown", // placeholder
    status: "pending",
    createdAt: DateTime.now(),
    price: p.price,
    rating: p.rating,
  );
}).toList();
