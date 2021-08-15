import 'dart:async';

import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/cart_summary.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/repositories/cart_repositories.dart';
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
