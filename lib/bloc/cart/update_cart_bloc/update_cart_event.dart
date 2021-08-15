part of 'update_cart_bloc.dart';

@immutable
abstract class UpdateCartEvent {}

class IncrementCart extends UpdateCartEvent{
  final Cart cart;

  IncrementCart(this.cart);
}

class DecrementCart extends UpdateCartEvent{
  final Cart cart;

  DecrementCart(this.cart);
}
