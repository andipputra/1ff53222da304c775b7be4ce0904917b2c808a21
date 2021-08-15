import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/cart_by_date.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/product.dart';

class CartByDateAndProduct {
  final List<CartByDate> cartByDate;
  final List<Product> products;

  CartByDateAndProduct({required this.cartByDate, required this.products});
}
