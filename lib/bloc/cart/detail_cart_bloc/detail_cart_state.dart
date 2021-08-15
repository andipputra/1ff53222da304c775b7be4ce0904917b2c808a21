part of 'detail_cart_bloc.dart';

@immutable
abstract class DetailCartState {}

class DetailCartInitial extends DetailCartState {}

class DetailCartSuccess extends DetailCartState {
  final Cart cart;

  DetailCartSuccess(this.cart);
}

class DetailAllCartSuccess extends DetailCartState {
  final List<Cart> carts;

  DetailAllCartSuccess(this.carts);
}

class DetailCartProcessing extends DetailCartState {}

class DetailCartFailure extends DetailCartState {
  final String message;

  DetailCartFailure({required this.message});
}
