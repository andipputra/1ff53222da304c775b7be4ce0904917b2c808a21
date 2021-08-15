import 'dart:async';

import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/cart.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/repositories/cart_repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'add_cart_event.dart';

part 'add_cart_state.dart';

class AddCartBloc extends Bloc<AddCartEvent, AddCartState> {
  AddCartBloc(this.cartRepositories) : super(AddCartInitial());

  final CartRepositories cartRepositories;

  @override
  Stream<AddCartState> mapEventToState(
    AddCartEvent event,
  ) async* {
    if (event is AddToCart) {
      print('add to cart bloc');

      yield (AddCartProcessing());

      final response = await cartRepositories.addCart(event.cart);

      print(response.response);

      if (response.success) {
        yield (AddCartSuccess());
      } else {
        yield (AddCartFailure(response.response as String));
      }
    }
  }
}
