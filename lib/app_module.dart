import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/add_cart_bloc/add_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/cart_data_bloc/cart_data_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/detail_cart_bloc/detail_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/list_cart_bloc/list_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/remove_cart_bloc/remove_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/update_cart_bloc/update_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/repositories/cart_repositories.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/repositories/product_repositories.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/services/cart_services.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/services/product_services.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/product/product_bloc/product_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/models/cart.dart';

class AppModule {
  // ignore: non_constant_identifier_names
  static final GetIt injector = GetIt.instance;

  AppModule();

  void setup() {
    // configurePermission();
    configureDatabase();
    configureDependencies();
    configureService();
    configureRepository();
  }

  void configurePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    print(statuses);
  }

  void configureDatabase() async {
    // var path = Directory.current.path;
    // Hive
    //   ..init(path)
    //   ..registerAdapter(CartAdapter());

    await Hive.initFlutter();
    Hive.registerAdapter<Cart>(CartAdapter());

    // await Hive
    //   ..initFlutter()
    //   ..registerAdapter(CartAdapter());
    await Hive.openBox<Cart>("Cart");
  }

  void configureDependencies() async {
    final dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    injector.registerSingleton<Dio>(dio);
  }

  void configureService() {
    injector
        .registerSingleton<ProductServices>(ProductServices(injector.get()));

    injector.registerSingleton<CartServices>(CartServices());
  }

  void configureRepository() {
    //TODO put all repository here
    injector
        .registerSingleton(ProductRepository(productServices: injector.get()));

    injector
        .registerSingleton(CartRepositories(injector.get(), injector.get()));
  }

  Widget configureBloc(Widget app) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(create: (_) => ProductBloc(injector.get())),
        BlocProvider<AddCartBloc>(create: (_) => AddCartBloc(injector.get())),
        BlocProvider<RemoveCartBloc>(
            create: (_) => RemoveCartBloc(injector.get())),
        BlocProvider<DetailCartBloc>(
            create: (_) => DetailCartBloc(injector.get())),
        BlocProvider<CartDataBloc>(create: (_) => CartDataBloc(injector.get())),
        BlocProvider<UpdateCartBloc>(
            create: (_) => UpdateCartBloc(injector.get())),
        BlocProvider<ListCartBloc>(create: (_) => ListCartBloc(injector.get())),
      ],
      child: app,
    );
  }
}
