part of 'list_cart_bloc.dart';

@immutable
abstract class ListCartState {}

class ListCartInitial extends ListCartState {}

class ListCartLoading extends ListCartState {}

class ListCartSuccess extends ListCartState {
  final CartByDateAndProduct cartData;

  ListCartSuccess({required this.cartData});
}

class ListCartEmpty extends ListCartState {}

class ListCartFailure extends ListCartState {
  final String message;

  ListCartFailure({required this.message});
}
