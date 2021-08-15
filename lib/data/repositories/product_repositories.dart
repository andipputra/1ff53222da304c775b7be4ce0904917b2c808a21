import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/response.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/services/product_services.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  final ProductServices productServices;

  ProductRepository({required this.productServices});

  Future<ResponseModel> getProducts(
      {required int page, required int limit}) async {
    try {
      final productList = await productServices.getProduct(page: page, limit: limit);

      return ResponseModel(success: true, response: productList);
    } on DioError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }

  Future<ResponseModel> getProductDetail(int id) async {
    try {
      final product = await productServices.getProductDetail(id);

      return ResponseModel(success: true, response: product);
    } on DioError catch (e) {
      return ResponseModel(success: false, response: e.message);
    }
  }
}
