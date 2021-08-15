import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CartServices {
  final String _boxName = "Cart";

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<Box<Cart>> cartBox() async {
    var box = await Hive.openBox<Cart>(_boxName);
    return box;
  }

  // get all cart
  Future<List<Cart>> getAllCart() async {
    final box = await cartBox();
    List<Cart> carts = box.values.toList();
    return carts;
  }

  // get by cartData
  Future<Cart?> getCartDetail(int index) async {
    final box = await cartBox();

    var cart = box.getAt(index);

    return cart;
  }

  // get cart by productId
  Future<List<Cart>> getCartByProdId(int prodId) async {
    final box = await cartBox();

    var carts =
        box.values.where((element) => element.productId == prodId).toList();

    return carts;
  }

  Future<Cart?> getCartByProdIdandDate(int prodId, DateTime dateTime) async {
    final box = await cartBox();



    var carts2 = box.values
        .where((element) =>
            element.productId == prodId &&
            formatter.format(element.orderDate) == formatter.format(dateTime))
        .toList();

    print('cart');
    carts2.forEach((element) {
      print(
          '${element.productId}, ${element.orderDate}, ${element.orderCount}');
    });

    // var carts = box.values
    //     .firstWhere((element) =>
    //         element.productId == prodId && element.orderDate == dateTime);

    if (carts2.isNotEmpty) {
      return carts2.first;
    } else {
      return null;
    }
  }

  Future<List<Cart>> getCartByDate(DateTime dateTime) async {
    final box = await cartBox();

    var carts = box.values
        .where((element) =>
            formatter.format(element.orderDate) == formatter.format(dateTime))
        .toList();

    return carts;
  }

  // to add data in box
  Future<int> addToBox(Cart cart) async {
    print('add cart');
    print(cart);

    final box = await cartBox();

    final res = await box.add(cart);

    print(res);

    return res;
  }

  // delete data from box
  Future<void> deleteFromBox(Cart cart) async {
    final box = await cartBox();

    var carts = box.values.toList();

    var index = carts.indexOf(cart);

    return await box.deleteAt(index);
  }

  // delete all data from box
  Future<int> deleteAll() async {
    final box = await cartBox();
    return await box.clear();
  }

  // update data
  Future<void> updateCartIncrement(Cart cart) async {
    final box = await cartBox();

    var carts = box.values.toList();

    var index = carts.indexOf(cart);

    var data = Cart(
        orderDate: cart.orderDate,
        orderCount: cart.orderCount + 1,
        productId: cart.productId);

    return await box.putAt(index, data);
  }
  // update data
  Future<void> updateCartDecrement(Cart cart) async {
    final box = await cartBox();

    var carts = box.values.toList();

    var index = carts.indexOf(cart);

    var newCount = cart.orderCount - 1;

    if(newCount != 0){
      var data = Cart(
          orderDate: cart.orderDate,
          orderCount: newCount,
          productId: cart.productId);

      return await box.putAt(index, data);
    } else {
      return await box.deleteAt(index);
    }
  }
}
