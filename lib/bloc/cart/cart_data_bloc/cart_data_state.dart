part of 'cart_data_bloc.dart';

@immutable
abstract class CartDataState {}

class CartDataInitial extends CartDataState {}

class CartDataSuccess extends CartDataState {
  final CartSumamry cartSumamry;

  CartDataSuccess({required this.cartSumamry});
}

class CartDataFailure extends CartDataState {
  final String message;

  CartDataFailure({required this.message});
}

class CartDataProcessing extends CartDataState {}
