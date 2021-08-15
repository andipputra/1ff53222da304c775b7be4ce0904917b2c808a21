part of 'remove_cart_bloc.dart';

@immutable
abstract class RemoveCartEvent {}

class RemoveAllCart extends RemoveCartEvent {}

class RemoveCart extends RemoveCartEvent {
  final Cart cart;

  RemoveCart(this.cart);
}
