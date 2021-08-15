part of 'detail_cart_bloc.dart';

@immutable
abstract class DetailCartEvent {}

class GetCartDetail extends DetailCartEvent {
  final int prodId;
  final DateTime dateTime;

  GetCartDetail({required this.prodId, required this.dateTime});
}

class GetAllCartDetail extends DetailCartEvent {
  final DateTime dateTime;

  GetAllCartDetail(this.dateTime);
}
