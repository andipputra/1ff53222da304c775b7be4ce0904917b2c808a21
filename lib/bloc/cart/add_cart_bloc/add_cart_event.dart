part of 'add_cart_bloc.dart';

@immutable
abstract class AddCartEvent {}

class AddToCart extends AddCartEvent{
  final Cart cart;

  AddToCart(this.cart);
}
