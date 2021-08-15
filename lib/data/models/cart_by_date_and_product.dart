import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart_by_date.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/product.dart';

class CartByDateAndProduct {
  final List<CartByDate> cartByDate;
  final List<Product> products;

  CartByDateAndProduct({required this.cartByDate, required this.products});
}
