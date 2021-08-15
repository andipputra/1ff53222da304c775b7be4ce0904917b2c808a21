import 'dart:async';

import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/product.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/repositories/product_repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this.productRepository) : super(ProductInitial());

  final ProductRepository productRepository;

  int initialPage = 1;
  int initialLimit = 5;

  bool isLastPage = false;

  final PagingController<int, Product> listController =
      PagingController(firstPageKey: 1);

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is GetFirstProduct) {
      final res = await productRepository.getProducts(
          page: initialPage, limit: initialLimit);

      if (res.success) {
        listController.itemList?.clear();

        var response = res.response as List<Product>;
        if (response.length < initialLimit) {
          isLastPage = true;
          listController.appendLastPage(response);
        } else {
          listController.appendPage(response, response.length);
        }

        yield ProductGetted();
      } else {
        yield ProductError(res.response.toString());
      }
    }

    if (event is GetNextProduct) {
      initialPage += 1;
      final res = await productRepository.getProducts(
          page: initialPage, limit: initialLimit);

      if (res.success) {
        var response = res.response as List<Product>;
        if (response.length < initialLimit) {
          isLastPage = true;
          listController.appendLastPage(response);
        } else {
          listController.appendPage(response, response.length);
        }

        yield ProductGetted();
      } else {
        yield ProductError(res.response.toString());
      }
    }
  }
}
