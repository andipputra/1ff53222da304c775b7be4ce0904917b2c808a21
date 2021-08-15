import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/product.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'product_services.g.dart';

@RestApi(baseUrl: "https://kulina-recruitment.herokuapp.com/")
abstract class ProductServices {
  factory ProductServices(Dio dio) = _ProductServices;

  @GET('/products')
  Future<List<Product>> getProduct({
    @Query('_page') int? page,
    @Query('_limit') int? limit,
  });

  @GET('/products/{id}/')
  Future<Product> getProductDetail(@Path("id") int id);
}
