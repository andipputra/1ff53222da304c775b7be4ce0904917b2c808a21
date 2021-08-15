import 'package:hive/hive.dart';

part 'cart.g.dart';

@HiveType(typeId: 1)
class Cart {
  @HiveField(0)
  final DateTime orderDate;
  @HiveField(1)
  final int orderCount;
  @HiveField(2)
  final int productId;

  Cart({required this.orderDate, required this.orderCount, required this.productId});

  @override
  String toString() {
    // TODO: implement toString
    return "${this.orderDate}, ${this.orderCount}. ${this.productId}";
  }
}