import 'dart:async';

import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/cart.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/repositories/cart_repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'remove_cart_event.dart';

part 'remove_cart_state.dart';

class RemoveCartBloc extends Bloc<RemoveCartEvent, RemoveCartState> {
  RemoveCartBloc(this.cartRepositories) : super(RemoveCartInitial());

  final CartRepositories cartRepositories;

  @override
  Stream<RemoveCartState> mapEventToState(
    RemoveCartEvent event,
  ) async* {
    if (event is RemoveAllCart) {
      yield (RemoveProcessing());

      final res = await cartRepositories.deleteAllCart();

      if (res.success) {
        yield (RemoveCartSuccess());
      }
    }

    if (event is RemoveCart) {
      yield (RemoveProcessing());

      final res = await cartRepositories.deleteCart(event.cart);

      if (res.success) {
        yield (RemoveCartSuccess());
      }
    }
  }
}
