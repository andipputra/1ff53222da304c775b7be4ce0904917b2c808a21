import 'dart:async';

import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/cart.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/repositories/cart_repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_cart_event.dart';
part 'update_cart_state.dart';

class UpdateCartBloc extends Bloc<UpdateCartEvent, UpdateCartState> {
  UpdateCartBloc(this.cartRepositories) : super(UpdateCartInitial());

  final CartRepositories cartRepositories;

  @override
  Stream<UpdateCartState> mapEventToState(
    UpdateCartEvent event,
  ) async* {
    if (event is IncrementCart) {
      yield (UpdateCartProcessing());

      final res = await cartRepositories.updateCartIncrement(event.cart);

      if (res.success) {
        yield (UpdateCartSuccess());
      }
    }

    if (event is DecrementCart) {
      yield (UpdateCartProcessing());

      final res = await cartRepositories.updateCartDecrement(event.cart);

      if (res.success) {
        yield (UpdateCartSuccess());
      }
    }
  }
}
