import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart_by_date.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart_by_date_and_product.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart_summary.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/product.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/response.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/services/cart_services.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/services/product_services.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CartRepositories {
  final CartServices cartServices;
  final ProductServices productServices;

  final DateFormat formatter = DateFormat('E, dd MM yyyy', 'id_ID');
  // final DateFormat formatter = DateFormat.EEEE('id_ID');

  CartRepositories(this.cartServices, this.productServices);

  Future<ResponseModel> getAllCart() async {
    try {
      final response = await cartServices.getAllCart();
      return ResponseModel(success: true, response: response);
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> getDetailCart(int index) async {
    try {
      final response = await cartServices.getCartDetail(index);
      return ResponseModel(success: true, response: response);
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> getDetailByProdId(int prodId) async {
    try {
      final response = await cartServices.getCartDetail(prodId);
      return ResponseModel(success: true, response: response);
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> getDetailByProdIdandDateTime(
      int prodId, DateTime dateTime) async {
    try {
      final response =
          await cartServices.getCartByProdIdandDate(prodId, dateTime);
      if (response != null) {
        return ResponseModel(success: true, response: response);
      } else {
        return ResponseModel(success: false, response: 'Data Null');
      }
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> getDetailByDateTime(DateTime dateTime) async {
    try {
      final response = await cartServices.getCartByDate(dateTime);
      if (response.isNotEmpty) {
        return ResponseModel(success: true, response: response);
      } else {
        return ResponseModel(success: false, response: 'Data Null');
      }
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> getCartSummary() async {
    try {
      final response = await cartServices.getAllCart();

      if (response.isNotEmpty) {
        int totalPrice = 0;
        int totalItem = 0;

        final listProduct = await productServices.getProduct();

        for (Cart cart in response) {
          totalItem += cart.orderCount;

          final prod = listProduct
              .singleWhere((element) => element.id == cart.productId);

          totalPrice += (cart.orderCount * prod.price);
        }

        final cartSummary = CartSumamry(
          totalItem: totalItem,
          totalPrice: totalPrice,
        );

        return ResponseModel(success: true, response: cartSummary);
      } else {
        return ResponseModel(
          success: true,
          response: CartSumamry(
            totalItem: 0,
            totalPrice: 0,
          ),
        );
      }
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> getCartGroupByDate() async {
    try {
      final listCart = await cartServices.getAllCart();
      final listProduct = await productServices.getProduct();

      var listDate = <String>[];
      var listCartByDate = <CartByDate>[];
      var listProductId = <int>[];

      listCart.forEach((element) {
        final date = formatter.format(element.orderDate);
        listDate.add(date);

        listProductId.add(element.productId);
      });

      final newListDate = listDate.toSet().toList();
      final newListProdId = listProductId.toSet().toList();

      var newListProduct = <Product>[];

      for (int id in newListProdId) {
        final product = listProduct.singleWhere((element) => element.id == id);
        newListProduct.add(product);
      }

      newListDate.forEach((date) {
        var newListCart = <Cart>[];
        listCart.forEach((cart) {
          if (formatter.format(cart.orderDate) == date) {
            newListCart.add(cart);
          }
        });

        var cartByDate = CartByDate(date: date, carts: newListCart);

        listCartByDate.add(cartByDate);
      });

      final listCartByDateAndProduct = CartByDateAndProduct(
          cartByDate: listCartByDate, products: newListProduct);

      return ResponseModel(success: true, response: listCartByDateAndProduct);
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> addCart(Cart cart) async {
    try {
      final response = await cartServices.addToBox(cart);

      return ResponseModel(success: true, response: response);
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> updateCartIncrement(Cart cart) async {
    try {
      await cartServices.updateCartIncrement(cart);
      return ResponseModel(success: true, response: 'success');
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> updateCartDecrement(Cart cart) async {
    try {
      await cartServices.updateCartDecrement(cart);
      return ResponseModel(success: true, response: 'success');
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> deleteCart(Cart cart) async {
    try {
      final response = await cartServices.deleteFromBox(cart);
      return ResponseModel(success: true, response: 'success');
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> deleteAllCart() async {
    try {
      final response = await cartServices.deleteAll();
      return ResponseModel(success: true, response: response);
    } on HiveError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }
}
