part of 'remove_cart_bloc.dart';

@immutable
abstract class RemoveCartState {}

class RemoveCartInitial extends RemoveCartState {}

class RemoveProcessing extends RemoveCartState {}

class RemoveCartSuccess extends RemoveCartState {}
