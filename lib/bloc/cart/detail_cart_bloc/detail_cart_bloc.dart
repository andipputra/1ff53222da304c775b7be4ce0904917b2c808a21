import 'dart:async';

import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/repositories/cart_repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'detail_cart_event.dart';

part 'detail_cart_state.dart';

class DetailCartBloc extends Bloc<DetailCartEvent, DetailCartState> {
  DetailCartBloc(this.cartRepositories) : super(DetailCartInitial());

  final CartRepositories cartRepositories;

  @override
  Stream<DetailCartState> mapEventToState(
    DetailCartEvent event,
  ) async* {
    if (event is GetCartDetail) {
      yield (DetailCartProcessing());

      print('event data');
      print('${event.prodId}, ${event.dateTime}');

      final res = await cartRepositories.getDetailByProdIdandDateTime(
          event.prodId, event.dateTime);

      if (res.success) {
        final cart = res.response as Cart;
        yield (DetailCartSuccess(cart));
      } else {
        yield (DetailCartFailure(message: res.response as String));
      }
    }

    if (event is GetAllCartDetail) {
      yield (DetailCartProcessing());

      final res = await cartRepositories.getDetailByDateTime(event.dateTime);

      if (res.success) {
        yield (DetailAllCartSuccess(res.response as List<Cart>));
      } else {
        yield (DetailCartFailure(message: res.response as String));
      }
    }
  }
}
