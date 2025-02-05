import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CartService {
  Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/cart.json');
    final cartJson = jsonEncode(cart);
    await file.writeAsString(cartJson);
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/cart.json');

    if (await file.exists()) {
      final cartJson = await file.readAsString();
      final List<dynamic> cartList = jsonDecode(cartJson);
      return cartList.map((item) => Map<String, dynamic>.from(item)).toList();
    }

    return [];
  }

  Future<void> removeProductFromCart(String productId) async {
    List<Map<String, dynamic>> cart = await getCart();
    cart.removeWhere((item) => item['product']['id'] == productId);
    await saveCart(cart);
  }
}
