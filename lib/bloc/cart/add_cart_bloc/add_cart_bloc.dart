import 'dart:async';

import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/repositories/cart_repositories.dart';
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
