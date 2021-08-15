part of 'update_cart_bloc.dart';

@immutable
abstract class UpdateCartState {}

class UpdateCartInitial extends UpdateCartState {}

class UpdateCartProcessing extends UpdateCartState {}

class UpdateCartSuccess extends UpdateCartState {}
