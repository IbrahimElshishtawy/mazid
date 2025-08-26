import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mazid/core/models/animals_models.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:mazid/core/service/animals_service.dart';
import 'package:mazid/core/service/auction_service.dart';
import 'package:mazid/core/service/barter_service.dart';
import 'package:mazid/core/service/product_service.dart';
import 'package:mazid/core/service/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auction_model.dart';
import '../models/barter_model.dart';
import '../models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zfmvvfobherprpcyqkqe.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmbXZ2Zm9iaGVycHJwY3lxa3FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxMTE5MzMsImV4cCI6MjA3MTY4NzkzM30.pQNpOdhFGxtACYlw4FtJDBjNyGZE-MQ3kAhcAK8_3Cg',
  );
  // Create service instances
  final productService = ProductService();
  final catService = AnimalsService();
  final auctionService = AuctionService();
  final barterService = BarterService();
  final userService = UserService();

  // Test Products
  if (kDebugMode) {
    print('===== Products =====');
  }
  try {
    List<ProductModel> products = await productService.getProducts();
    for (var product in products) {
      if (kDebugMode) {
        print(
          'Name: ${product.name}, Category: ${product.category}, Price: \$${product.price}, Rate: ${product.rate}',
        );
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching products: $e');
    }
  }

  // Test Cats
  if (kDebugMode) {
    print('\n===== Cats =====');
  }
  try {
    List<AnimalsModels> cats = await catService.getAnimals();
    for (var cat in cats) {
      if (kDebugMode) {
        print(
          'Name: ${cat.name}, Breed: ${cat.type}, Age: ${cat.age}, Price: \$${cat.price}, Rate: ${cat.rate}',
        );
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching cats: $e');
    }
  }

  // Test Auctions
  if (kDebugMode) {
    print('\n===== Auctions =====');
  }
  try {
    List<AuctionModel> auctions = await auctionService.getAuctions();
    for (var auction in auctions) {
      if (kDebugMode) {
        print(
          'Product ID: ${auction.productId}, Start: \$${auction.startPrice}, Current Bid: \$${auction.currentBid}, Ends At: ${auction.endsAt}',
        );
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching auctions: $e');
    }
  }

  // Test Barters
  if (kDebugMode) {
    print('\n===== Barters =====');
  }
  try {
    List<BarterModel> barters = await barterService.getBarters();
    for (var barter in barters) {
      if (kDebugMode) {
        print(
          'Offered: ${barter.offeredItemId}, Requested: ${barter.requestedItemId}, Proposer: ${barter.proposerId}, Status: ${barter.status}',
        );
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching barters: $e');
    }
  }

  // Test Users
  if (kDebugMode) {
    print('\n===== Users =====');
  }
  try {
    List<UserModel> users = await userService.getUsers();
    for (var user in users) {
      if (kDebugMode) {
        print(
          'Name: ${user.name}, Email: ${user.email}, Avatar: ${user.avatar}',
        );
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching users: $e');
    }
  }

  if (kDebugMode) {
    print('\n===== Test Completed =====');
  }
}
