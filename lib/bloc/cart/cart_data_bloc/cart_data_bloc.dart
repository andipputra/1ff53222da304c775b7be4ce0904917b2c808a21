import 'dart:async';

import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart_summary.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/repositories/cart_repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cart_data_event.dart';

part 'cart_data_state.dart';

class CartDataBloc extends Bloc<CartDataEvent, CartDataState> {
  CartDataBloc(this.cartRepositories) : super(CartDataInitial());

  final CartRepositories cartRepositories;

  @override
  Stream<CartDataState> mapEventToState(
    CartDataEvent event,
  ) async* {
    if (event is GetCartData) {
      yield (CartDataProcessing());

      final res = await cartRepositories.getCartSummary();

      if (res.success) {
        var cartSummary = res.response as CartSumamry;

        print('${cartSummary.totalItem}, ${cartSummary.totalPrice}');

        yield (CartDataSuccess(cartSumamry: cartSummary));
      } else {
        print('${res.response}');
        yield (CartDataFailure(message: res.response as String));
      }
    }
  }
}
