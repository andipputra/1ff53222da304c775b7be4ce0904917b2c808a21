import 'dart:async';

import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart_by_date.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart_by_date_and_product.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/repositories/cart_repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'list_cart_event.dart';

part 'list_cart_state.dart';

class ListCartBloc extends Bloc<ListCartEvent, ListCartState> {
  ListCartBloc(this.cartRepositories) : super(ListCartInitial());

  final CartRepositories cartRepositories;

  @override
  Stream<ListCartState> mapEventToState(
    ListCartEvent event,
  ) async* {
    if (event is GetListCart) {
      yield (ListCartLoading());

      final response = await cartRepositories.getCartGroupByDate();

      if (response.success) {
        final data = response.response as CartByDateAndProduct;

        if (data.cartByDate.isEmpty) {
          yield (ListCartEmpty());
        } else {
          yield (ListCartSuccess(cartData: data));
        }
      } else {
        yield (ListCartFailure(message: response.response as String));
      }
    }
  }
}
