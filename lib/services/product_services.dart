import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyek/models/product.dart';

class ProductService {
  static const String _baseUrl = 'http://192.168.0.107:8000/api/client';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

/*************  ✨ Windsurf Command ⭐  *************/
/// Fetches a list of products from the server.
///
/// Sends a GET request to the products endpoint with the provided 
/// authentication token. If the request is successful, it returns a 
/// list of `Product` objects. If the request fails, an exception is 
/// thrown.
///
/// Throws:
/// - `Exception` if the request fails or an error occurs during 
///   fetching.
///
/// Parameters:
/// - `token`: A string representing the authorization token.

/*******  76bed8f5-bbee-4281-8049-a6eb83438b8d  *******/
  Future<List<Product>> getProducts(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['data'] as List)
            .map((product) => Product.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Product> purchaseProduct(String token, int productId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/products/$productId/purchase'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data['data']['product']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to purchase product');
      }
    } catch (e) {
      throw Exception('Purchase failed: $e');
    }
  }
}